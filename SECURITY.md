# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x     | ✅ Active |

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

**Email:** <security@ecom-x.com>

**Do NOT** open a public GitHub issue for security vulnerabilities.

## Security by Design

Axiom workflows enforce security at every stage:

- **`/context`** — Mandates `.env`-only credential storage, never hardcoded
- **`/map-codebase`** — Runs secret scanning before committing analysis docs
- **`/execute-phase`** — Requires individual `git add` (never `git add .`)
- **`/plan-phase`** — Security tests are NEVER marked N/A for phases with DB or API work
- **`/verify-work`** — Mandatory RLS, auth, and input validation verification

## Responsible Disclosure

We will acknowledge receipt within 48 hours and provide a fix timeline within 7 days.
