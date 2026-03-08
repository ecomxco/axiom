---
description: Quick task execution with planning guarantees but without full phase ceremony — for small, well-understood tasks
---

# Quick Task

Lightweight task execution for small, well-understood work.

## When to Use

- You know exactly what to do
- Task is small (< 1 hour)
- Doesn't need research or verification ceremony
- Examples: "Update config file", "Fix CSS bug", "Add database field", "Tweak API response format"

## Risk Check

Before proceeding, quick-assess: **Could this break existing functionality?**

- If **no** (cosmetic, docs, new isolated addition) → continue with `/quick`
- If **maybe** (modifying shared code, changing schema, touching auth) → suggest `/plan-phase` instead: "This touches [shared concern]. Consider using the full planning workflow to catch side effects."
- If **yes** (breaking change, migration, API contract change) → route to `/plan-phase`

## Prerequisites

`.planning/ROADMAP.md` should exist. If not, warn: "No project initialized. Consider `/plan-project` first, or continue for standalone task."

## Process

### 1. Understand the Task

Ask: "What do you need done?" (one question, get specifics)

### 2. Create Quick Plan

Determine next task number:

```bash
ls .planning/quick/ 2>/dev/null | sort -n | tail -1
```

// turbo

```bash
mkdir -p .planning/quick/NNN-slug
```

Write `.planning/quick/NNN-slug/PLAN.md`:

```markdown
---
task: [short title]
type: quick
created: [date]
---

## Task
[What needs to happen]

## Files
[Specific files to create/modify]

## Done Criteria
[How to know it's complete]
```

### 3. Execute

- Implement the task
- Stage files individually — **NEVER** `git add .` or `git add -A`
- Commit: `fix/feat/chore: [description]`

### 4. Update State

Append to STATE.md "Quick Tasks" section:

```markdown
### Quick Tasks Completed

| # | Task | Date | Commit |
|---|------|------|--------|
| 001 | [description] | [date] | [hash] |
```

### 5. Summary

Create `.planning/quick/NNN-slug/SUMMARY.md` (brief — 15-20 lines max):

```markdown
# Quick Task NNN: [Title]

**Duration:** [X min]
**Files:** [list]
**Commit:** [hash]
**What changed:** [2-3 sentences]
```

Commit docs:

```bash
git add .planning/quick/NNN-slug/ .planning/STATE.md
git commit -m "docs: quick task NNN - [title]"
```

Done. No roadmap update, no phase transition, no verification ceremony.
