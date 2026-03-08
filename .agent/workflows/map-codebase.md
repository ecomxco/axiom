---
description: Analyze an existing codebase into structured reference documents — for brownfield projects
---

# Map Codebase

Produces 7 structured documents about the existing codebase state. Essential for brownfield projects where understanding existing code is a prerequisite for planning.

Analysis runs sequentially across 4 focus areas, producing the same comprehensive output documents.

## When to Use

- Starting a new project on an existing codebase
- Offered during `/plan-project` when existing code is detected
- Manually when you want to document the current architecture

## 1. Check Existing Map

```bash
ls .planning/codebase/ 2>/dev/null
```

If exists → Ask: "Codebase map exists. Refresh, update specific docs, or skip?"

## 2. Create Structure

// turbo

```bash
mkdir -p .planning/codebase
```

## 3. Analyze Codebase

Analyze the codebase sequentially across 4 focus areas, writing documents as you go.

**Always include file paths** — these docs are reference material for planning. Use backtick formatting: `src/services/user.ts`.

### Focus 1: Technology Stack

Investigate: languages, runtime, frameworks, dependencies, configuration, external APIs, databases, auth providers.

Write:

- `.planning/codebase/STACK.md` — Languages, runtime, frameworks, dependencies, configuration
- `.planning/codebase/INTEGRATIONS.md` — External APIs, databases, auth providers, webhooks

### Focus 2: Architecture

Investigate: patterns, layers, data flow, abstractions, entry points, directory layout, naming conventions.

Write:

- `.planning/codebase/ARCHITECTURE.md` — Pattern, layers, data flow, abstractions, entry points
- `.planning/codebase/STRUCTURE.md` — Directory layout, key locations, naming conventions

### Focus 3: Quality & Conventions

Investigate: code style, naming patterns, error handling, test framework, test structure, mocking patterns, coverage.

Write:

- `.planning/codebase/CONVENTIONS.md` — Code style, naming, patterns, error handling
- `.planning/codebase/TESTING.md` — Framework, structure, mocking, coverage

### Focus 4: Concerns

Investigate: technical debt, known bugs, security issues, performance hotspots, fragile areas.

Write:

- `.planning/codebase/CONCERNS.md` — Tech debt, bugs, security, performance, fragile areas

## 4. Security Scan

**Before committing, scan for accidentally leaked secrets:**

```bash
grep -E '(sk-[a-zA-Z0-9]{20,}|sk_live_|sk_test_|ghp_[a-zA-Z0-9]{36}|AKIA[A-Z0-9]{16}|eyJ[a-zA-Z0-9_-]+\.eyJ)' .planning/codebase/*.md 2>/dev/null && echo "SECRETS_FOUND" || echo "CLEAN"
```

If secrets found → **STOP**, alert user, do NOT commit until resolved.

## 5. Commit & Present

```bash
git add .planning/codebase/*.md
git commit -m "docs: map existing codebase"
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 CODEBASE MAPPED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Created .planning/codebase/:
- STACK.md — Technologies and dependencies
- ARCHITECTURE.md — System design and patterns
- STRUCTURE.md — Directory layout and organization
- CONVENTIONS.md — Code style and patterns
- TESTING.md — Test structure and practices
- INTEGRATIONS.md — External services and APIs
- CONCERNS.md — Technical debt and issues

## ▶ Next
Run /plan-project to initialize the project
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
