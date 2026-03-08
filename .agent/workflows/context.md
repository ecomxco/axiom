---
description: Project context and environment setup that should be loaded at the start of every session
---

# Project Context

Load environment context before starting any work. This workflow auto-discovers your project setup and verifies readiness.

## 🔒 Security Rules (MANDATORY)

1. **NEVER hardcode API keys, tokens, JWTs, or secrets** in any source file — not even as "fallbacks" or "defaults". Always use `process.env.VAR_NAME` and fail clearly if the var is missing.
2. **All credentials come from `.env`** (gitignored). Scripts should load via `set -a && source .env && set +a` or `dotenv`.
3. **Pre-commit hooks** should automatically block commits containing sensitive patterns (e.g., `service_role`, `sk_live_`, `ghp_`).
4. **Never log or print** secret values. Only log whether a credential was found (e.g., `✅ SUPABASE_URL loaded`).
5. **`.env` files in sub-apps** (e.g., `apps/web/.env`) are gitignored and should mirror keys from root `.env`.

## 1. Detect Environment Files

```bash
# Check for .env files
ls -la .env .env.* 2>/dev/null
cat .env.example 2>/dev/null || echo "No .env.example found"
```

> **Rule:** When any package or app needs environment variables, pull the real values from the root `.env` instead of creating stubs. The root file is the single source of truth for all credentials.

### Auto-Discover Key Variables

```bash
# Extract variable names from .env.example (or .env if no example exists)
grep -E '^[A-Z_]+=' .env.example 2>/dev/null | cut -d= -f1 | sort
```

Present discovered variables grouped by service pattern:

| Pattern | Likely Service |
|---------|---------------|
| `DATABASE_*`, `SUPABASE_*`, `DB_*` | Database |
| `STRIPE_*`, `SHOPIFY_*`, `STORE_*` | Commerce |
| `SENDGRID_*`, `KLAVIYO_*`, `EMAIL_*` | Email |
| `GA_*`, `ANALYTICS_*` | Analytics |
| `AWS_*`, `S3_*`, `CLOUD_*` | Cloud/Storage |
| `OPENAI_*`, `ANTHROPIC_*`, `AI_*` | AI/ML |

## 2. Detect Authenticated CLIs

```bash
# Check which CLIs are available and authenticated
which git >/dev/null 2>&1 && echo "✅ git $(git --version | cut -d' ' -f3)" || echo "❌ git not found"
which gh >/dev/null 2>&1 && gh auth status 2>&1 | head -1 || echo "❌ gh not found"
which node >/dev/null 2>&1 && echo "✅ node $(node --version)" || echo "❌ node not found"
which npm >/dev/null 2>&1 && echo "✅ npm $(npm --version)" || echo "❌ npm not found"

# Project-specific CLIs (check for common ones)
which vercel >/dev/null 2>&1 && echo "✅ vercel" || true
which supabase >/dev/null 2>&1 && echo "✅ supabase" || true
which docker >/dev/null 2>&1 && echo "✅ docker" || true
which python3 >/dev/null 2>&1 && echo "✅ python3 $(python3 --version 2>&1 | cut -d' ' -f2)" || true
which cargo >/dev/null 2>&1 && echo "✅ cargo" || true
```

> **Rule:** Never ask the user to authenticate or provide credentials. All keys exist in `.env` and all CLIs are pre-authenticated. Just use them.

## 3. Detect Project Structure

```bash
# Show project layout (2 levels deep, directories only)
find . -maxdepth 2 -type d -not -path '*/\.*' -not -path '*/node_modules*' | sort | head -30

# Detect project type
ls package.json 2>/dev/null && echo "→ Node.js project"
ls Cargo.toml 2>/dev/null && echo "→ Rust project"
ls requirements.txt pyproject.toml setup.py 2>/dev/null && echo "→ Python project"
ls go.mod 2>/dev/null && echo "→ Go project"

# Detect monorepo
ls pnpm-workspace.yaml turbo.json lerna.json 2>/dev/null && echo "→ Monorepo detected"
```

## 4. Load Planning State

```bash
# Check for existing Axiom planning state
ls .planning/STATE.md 2>/dev/null && cat .planning/STATE.md | head -20
ls .planning/ROADMAP.md 2>/dev/null && echo "→ ROADMAP.md exists"
ls .planning/PROJECT.md 2>/dev/null && echo "→ PROJECT.md exists"
```

## 5. Load Project-Specific Docs

Check for these reference files and read them if they exist:

```bash
# Architecture and environment docs
cat ENVIRONMENT.md 2>/dev/null || cat .context/ENVIRONMENT.md 2>/dev/null || true
cat .planning/PROJECT.md 2>/dev/null || true
```

## 6. Present Context Summary

After auto-discovery, present a compact summary:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 PROJECT CONTEXT LOADED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Project: [name from package.json/PROJECT.md]
Type: [language/framework]
Structure: [monorepo/single-app]

Environment:
  .env: [found/missing] ([N] variables)
  CLIs: [list of authenticated CLIs]

Planning State: [active phase/no project initialized]

Ready to work. What would you like to do?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Health Checks

If any critical issues are detected during discovery, surface them:

| Issue | Severity | Suggestion |
|-------|----------|------------|
| No `.env` file found | ⚠️ Warning | Create from `.env.example` or ask user for credentials |
| No `.gitignore` | 🛑 Critical | Create one immediately — risk of committing secrets |
| `.env` not in `.gitignore` | 🛑 Critical | Add `.env` to `.gitignore` before any commits |
| No git repo | ⚠️ Warning | Suggest `git init` |
| `node_modules` committed | ⚠️ Warning | Add to `.gitignore`, remove from tracking |
