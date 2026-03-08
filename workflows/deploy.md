---
description: Pre-deploy checklist, environment validation, post-deploy smoke test, and rollback protocol
---

# Deploy

Structured deployment with validation gates before, during, and after. Prevents "it worked locally" failures.

**Core principle:** Deploy is a workflow, not a command. Every deployment gets a pre-flight check, a smoke test, and a defined rollback trigger.

## When to Use

- Deploying to staging or production
- After `/verify-work` passes UAT
- After hotfix execution

## 1. Pre-Deploy Checklist

Before initiating any deployment:

### Code Readiness

```bash
# All changes committed?
git status --short
[ -z "$(git status --short)" ] && echo "✅ Clean" || echo "❌ Uncommitted changes"

# On correct branch?
git branch --show-current

# All tests passing?
npm test 2>/dev/null || echo "No test command configured"

# Build succeeds?
npm run build 2>/dev/null && echo "✅ Build clean" || echo "❌ Build failed"
```

If any check fails → **STOP**. Fix before deploying.

### Environment Validation

```bash
# Compare required vars against target environment
# Pull required vars from .env.example
REQUIRED=$(grep -E '^[A-Z_]+=' .env.example 2>/dev/null | cut -d= -f1 | sort)

echo "Required environment variables:"
echo "$REQUIRED"
echo ""
echo "Verify these are set in your deployment target (Vercel, AWS, etc.)"
```

### Dependency Check

```bash
# Any outdated critical deps?
npm audit --production 2>/dev/null | tail -5

# Lock file in sync?
npm ci --dry-run 2>/dev/null && echo "✅ Lock file valid" || echo "⚠️ Lock file mismatch"
```

## 2. Deploy

### Staging Deploy

```bash
# Platform-specific (adapt to your stack)
# Vercel
vercel --prod=false

# Or direct push
git push staging main

# Or Docker
docker build -t app:staging . && docker push app:staging
```

After staging deploy, proceed to smoke test (step 3) before production.

### Production Deploy

Only after staging smoke test passes:

```bash
# Tag the release
git tag -a "v[VERSION]" -m "Release v[VERSION]"
git push origin "v[VERSION]"

# Deploy
vercel --prod
# or
git push production main
```

## 3. Post-Deploy Smoke Test

Run immediately after deployment completes:

### Automated Checks

```bash
# Is the site up?
curl -s -o /dev/null -w "%{http_code}" https://[your-domain.com] | grep -q "200" && echo "✅ Site responding" || echo "❌ Site down"

# Is the API healthy?
curl -s https://[your-domain.com]/api/health | jq '.status' 2>/dev/null

# Are static assets loading?
curl -s -o /dev/null -w "%{http_code}" https://[your-domain.com]/_next/static/ 2>/dev/null
```

### Manual Verification

Check these in a browser:

- [ ] Homepage loads with correct content
- [ ] Authentication works (login/logout)
- [ ] Core user flow completes end-to-end
- [ ] No console errors in browser dev tools
- [ ] New feature/fix from this deploy works as expected

### Smoke Test Verdict

```
| Check | Status |
|-------|--------|
| Site responding | ✅/❌ |
| API health | ✅/❌ |
| Auth flow | ✅/❌ |
| Core user flow | ✅/❌ |
| New feature works | ✅/❌ |
```

**If any critical check fails** → Trigger rollback (step 4).

## 4. Rollback Protocol

If smoke test fails or critical issues are discovered post-deploy:

### Immediate Rollback

```bash
# Option 1: Revert to previous deployment (Vercel)
vercel rollback

# Option 2: Deploy previous git tag
git checkout v[PREVIOUS_VERSION]
git push production HEAD:main --force

# Option 3: Revert commit
git revert HEAD
git push production main
```

### Post-Rollback

1. Verify rollback succeeded (re-run smoke test)
2. Diagnose the failure (use `/diagnose-issues`)
3. Document what went wrong in LESSONS.md
4. Fix, re-verify, re-deploy

## 5. Record Deployment

Update STATE.md:

```markdown
## Deployments

| Date | Version | Target | Status | Notes |
|------|---------|--------|--------|-------|
| [date] | v[X.Y.Z] | production | ✅ success | [brief note] |
```

Commit:

```bash
git add .planning/STATE.md
git commit -m "docs: record deployment v[VERSION]"
```

## 6. Complete

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 DEPLOYMENT COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Version: v[X.Y.Z]
Target: [staging/production]
Smoke test: [passed/failed]
Rollback: [not needed/triggered]

## ▶ Next
Monitor for 30 minutes, then /progress
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
