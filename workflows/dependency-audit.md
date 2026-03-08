---
description: Audit dependencies for outdated packages, security vulnerabilities, and license compliance
---

# Dependency Audit

Systematic review of project dependencies for security, freshness, and license compliance. Run periodically or before major releases.

**Core principle:** Dependencies are attack surface. Every outdated package is a potential vulnerability, every unreviewed license is a potential legal risk.

## When to Use

- Before deploying to production (`/deploy` pre-flight)
- Monthly maintenance cadence
- After adding significant new dependencies
- When security advisories are published for your stack

## 1. Detect Package Manager

```bash
# Detect ecosystem
ls package.json 2>/dev/null && echo "→ npm/node"
ls Cargo.toml 2>/dev/null && echo "→ cargo/rust"
ls requirements.txt pyproject.toml 2>/dev/null && echo "→ pip/python"
ls go.mod 2>/dev/null && echo "→ go modules"
ls Gemfile 2>/dev/null && echo "→ bundler/ruby"
```

## 2. Security Vulnerabilities

### Node.js / npm

```bash
# Audit for known vulnerabilities
npm audit 2>/dev/null

# Production-only (what actually ships)
npm audit --production 2>/dev/null

# Count by severity
npm audit --json 2>/dev/null | jq '.metadata.vulnerabilities'
```

### Python

```bash
pip audit 2>/dev/null || echo "Install: pip install pip-audit"
```

### Rust

```bash
cargo audit 2>/dev/null || echo "Install: cargo install cargo-audit"
```

### Present Results

```
## Security Audit

| Severity | Count | Action |
|----------|-------|--------|
| Critical | [N] | 🛑 Fix immediately — blocks deploy |
| High | [N] | ⚠️ Fix before next release |
| Moderate | [N] | 📋 Schedule fix |
| Low | [N] | 📝 Note for next audit |
```

**If critical or high vulnerabilities found** → List each with:

- Package name and version
- Vulnerability ID (CVE/GHSA)
- Fix version (if available)
- Whether it's a direct or transitive dependency

## 3. Outdated Packages

```bash
# Node.js
npm outdated 2>/dev/null

# Python
pip list --outdated 2>/dev/null

# Rust
cargo outdated 2>/dev/null
```

### Classify Outdated Packages

| Category | Criteria | Action |
|----------|----------|--------|
| **Major behind** | 2+ major versions behind | Review changelog, plan migration |
| **Minor behind** | Current major, behind on minor | Update when convenient |
| **Patch behind** | Current minor, behind on patch | Update immediately (bug/security fixes) |
| **Deprecated** | Package is abandoned/deprecated | Find replacement |

### Present Results

```
## Outdated Dependencies

| Package | Current | Latest | Behind | Risk |
|---------|---------|--------|--------|------|
| next | 14.2.0 | 15.1.0 | Major | Review breaking changes |
| lodash | 4.17.20 | 4.17.21 | Patch | Safe to update |
| [dep] | [ver] | [latest] | [type] | [assessment] |

Recommended updates: [N] packages
Breaking changes expected: [N] packages
```

## 4. License Compliance

```bash
# Node.js — check licenses
npx license-checker --summary 2>/dev/null || echo "Install: npm i -g license-checker"

# Look for problematic licenses
npx license-checker --failOn 'GPL-3.0;AGPL-3.0;SSPL-1.0' 2>/dev/null
```

### License Risk Matrix

| License | Risk | Notes |
|---------|------|-------|
| MIT, Apache-2.0, BSD | 🟢 Safe | Permissive, no issues |
| ISC, Unlicense | 🟢 Safe | Permissive |
| LGPL-2.1, LGPL-3.0 | 🟡 Caution | OK for linking, not modification |
| GPL-2.0, GPL-3.0 | 🔴 Risk | Copyleft — may require source disclosure |
| AGPL-3.0 | 🔴 High Risk | Network copyleft — SaaS implications |
| Unlicensed / Unknown | 🔴 Risk | No license = all rights reserved |

## 5. Dependency Health

For critical dependencies, check project health:

```bash
# Check last publish date for top dependencies
npm view [package] time --json 2>/dev/null | jq 'to_entries | last'
```

| Indicator | Threshold | Signal |
|-----------|-----------|--------|
| Last published > 1 year | ⚠️ Warning | May be unmaintained |
| Last published > 2 years | 🛑 Risk | Likely abandoned |
| Open issues > 500 | ⚠️ Warning | Maintenance burden |
| No TypeScript types | 📝 Note | DX impact |

## 6. Generate Report

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 DEPENDENCY AUDIT COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Date: [date]
Total dependencies: [N] (direct) / [N] (transitive)

Security:    [N] critical, [N] high, [N] moderate
Outdated:    [N] major, [N] minor, [N] patch
Licenses:    [N] permissive, [N] caution, [N] risk
Health:      [N] healthy, [N] stale, [N] abandoned

## Actions Required

🛑 Critical (blocks deploy):
  - [package]: [vulnerability/issue]

⚠️ High (fix before next release):
  - [package]: [vulnerability/issue]

📋 Scheduled (next maintenance window):
  - [package]: [update/replacement]

## ▶ Next
Fix critical issues, then /deploy
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 7. Record Audit

```bash
# Save audit results
mkdir -p .planning/audits
# Write report to dated file
git add .planning/audits/
git commit -m "docs: dependency audit [date]"
```
