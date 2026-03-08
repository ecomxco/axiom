---
description: Project context and environment setup that should be loaded at the start of every session
---

# Project Context

Before starting any work, always load environment context:

## 🔒 Security Rules (MANDATORY)

1. **NEVER hardcode API keys, tokens, JWTs, or secrets** in any source file — not even as "fallbacks" or "defaults". Always use `process.env.VAR_NAME` and fail clearly if the var is missing.
2. **All credentials come from `.env`** (gitignored). Scripts should load via `set -a && source .env && set +a` or `dotenv`.
3. **Pre-commit hooks** should automatically block commits containing sensitive patterns (e.g., `service_role`, `sk_live_`, `ghp_`).
4. **Never log or print** secret values. Only log whether a credential was found (e.g., `✅ SUPABASE_URL loaded`).
5. **`.env` files in sub-apps** (e.g., `apps/web/.env`) are gitignored and should mirror keys from root `.env`.

## Environment Files

The root of the workspace has **two critical env files** with ALL API keys and credentials:

- **`.env`** — Real secrets. GITIGNORED.
- **`.env.example`** — Template with placeholder values. COMMITTED.

> **Rule:** When any package or app needs environment variables, pull the real values from the root `.env` instead of creating stubs. The root file is the single source of truth for all credentials.

### Key Variables Available

Load your project's specific environment variables here. Example:

| Service | Key Variables |
|---------|--------------|
| **Database** | `DATABASE_URL`, `DATABASE_ANON_KEY`, `DATABASE_SERVICE_ROLE_KEY` |
| **Commerce** | `STORE_DOMAIN`, `STOREFRONT_ACCESS_TOKEN`, `ADMIN_API_ACCESS_TOKEN` |
| **Email** | `EMAIL_PUBLIC_KEY`, `EMAIL_PRIVATE_KEY`, `EMAIL_LIST_ID` |
| **Ads** | `ADS_API_ACCESS_TOKEN`, `AD_ACCOUNT_ID`, `PIXEL_ID` |
| **Analytics** | `ANALYTICS_MEASUREMENT_ID`, `ANALYTICS_API_SECRET` |

> Customize this table with your actual services and variable names.

## Project Files to Know

- **`ENVIRONMENT.md`** — Full tech stack, architecture, and CLI documentation
- **`.planning/STATE.md`** — Current project status and phase progress
- **`.planning/ROADMAP.md`** — Phase structure with success criteria

## CLI Authentication

Document your authenticated CLIs here. Example:

| CLI | Command Prefix | Status |
|-----|---------------|--------|
| **Database** | `supabase` | ✅ Authenticated |
| **Git** | `gh` | ✅ Authenticated |
| **Deploy** | `vercel` | ✅ Authenticated |

> **Rule:** Never ask the user to authenticate or provide credentials. All keys exist in `.env` and all CLIs are pre-authenticated. Just use them.

## Project Structure

Document your project's directory layout here. Example:

```
your-project/
├── .env                    ← ALL secrets (single source of truth)
├── .env.example            ← Template
├── .planning/              ← Axiom planning state
├── src/                    ← Application source
├── tests/                  ← Test suite
└── scripts/                ← Automation scripts
```

> Customize this to match your actual project structure.
