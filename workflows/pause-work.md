---
description: Create a handoff file preserving complete work state for seamless session resumption
---

# Pause Work

Creates `.continue-here.md` so a fresh session can instantly pick up where you left off.

## When to Use

- Ending a work session mid-phase
- Context is getting large and you need to `/clear`
- Switching to a different task temporarily

## 1. Detect Current Work

```bash
# Find most recent phase directory with work
ls -lt .planning/phases/*/*-PLAN.md 2>/dev/null | head -3
```

If no active phase detected, ask user which phase they're pausing.

## 2. Gather State

Collect complete state for the handoff:

1. **Current position**: Which phase, which plan, which task
2. **Work completed**: What got done this session
3. **Work remaining**: What's left in current plan/phase
4. **Decisions made**: Key decisions and rationale
5. **Blockers/issues**: Anything stuck
6. **Mental context**: The approach, next steps, "vibe"
7. **Files modified**: What's changed but not committed

```bash
git status --short
git diff --stat
```

Ask user for clarifications if needed.

## 3. Write Handoff

Create `.planning/phases/XX-name/.continue-here.md`:

```markdown
---
phase: XX-name
task: 3
total_tasks: 7
status: in_progress
last_updated: [timestamp]
---

## Current State
[Where exactly are we? Immediate context]

## Completed Work
- Task 1: [name] - Done
- Task 2: [name] - Done
- Task 3: [name] - In progress, [what's done]

## Remaining Work
- Task 3: [what's left]
- Task 4: Not started
- Task 5: Not started

## Decisions Made
- Decided to use [X] because [reason]
- Chose [approach] over [alternative] because [reason]

## Blockers
- [Blocker 1]: [status/workaround]

## Context
[Mental state, what were you thinking, the plan]

## Next Action
Start with: [specific first action when resuming]
```

**Be specific enough for a fresh AI instance to understand immediately.**

## 4. Commit & Confirm

```bash
git add .planning/phases/XX-name/.continue-here.md .planning/STATE.md
git commit -m "wip: [phase-name] paused at task [X]/[Y]"
```

```
✓ Handoff created: .planning/phases/[XX-name]/.continue-here.md

Current state:
- Phase: [XX-name]
- Task: [X] of [Y]
- Status: [in_progress/blocked]
- Committed as WIP

To resume: /resume-project
```
