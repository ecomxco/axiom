---
description: Restore full project context across sessions — reads STATE.md, finds incomplete work, and routes to next action
---

# Resume Project

Instantly answers "Where were we?" with complete context restoration.

## When to Use

- Starting a new session on an existing project
- User says "continue", "what's next", "where were we", "resume"
- Returning after time away from the project

## 1. Check Project Exists

```bash
ls .planning/STATE.md 2>/dev/null && echo "STATE_OK" || echo "NO_STATE"
ls .planning/ROADMAP.md 2>/dev/null && echo "ROADMAP_OK" || echo "NO_ROADMAP"
ls .planning/PROJECT.md 2>/dev/null && echo "PROJECT_OK" || echo "NO_PROJECT"
```

| Condition | Action |
|-----------|--------|
| No `.planning/` at all | Route to `/plan-project` |
| PROJECT.md but no ROADMAP.md | Between milestones — suggest next milestone |
| ROADMAP.md but no STATE.md | Reconstruct STATE.md from artifacts (see step 5) |
| All exist | Continue to step 2 |

## 2. Load State

```bash
cat .planning/STATE.md
cat .planning/PROJECT.md
cat .planning/ROADMAP.md
```

Extract:

- **Project name** and core value
- **Current position**: Phase X of Y, Plan A of B
- **Progress**: Percentage complete
- **Recent decisions**: From STATE.md
- **Blockers/concerns**: Carried forward issues
- **Last activity**: Date and action

## 3. Find Incomplete Work

```bash
# Check for handoff files (mid-plan resumption)
find .planning/phases -name ".continue-here.md" 2>/dev/null

# Check for plans without summaries (incomplete execution)
for plan in .planning/phases/*/*-PLAN.md; do
  summary="${plan/PLAN/SUMMARY}"
  [ ! -f "$summary" ] && echo "Incomplete: $plan"
done 2>/dev/null

# Check for UAT files with gaps
grep -rl "status: diagnosed" .planning/phases/ 2>/dev/null
```

## 4. Present Status

```
╔══════════════════════════════════════════════════════╗
║  PROJECT STATUS                                       ║
╠══════════════════════════════════════════════════════╣
║  Building: [one-liner from PROJECT.md]                ║
║                                                       ║
║  Phase: [X] of [Y] - [Phase name]                    ║
║  Plan:  [A] of [B] - [Status]                        ║
║  Progress: [██████░░░░] XX%                          ║
║                                                       ║
║  Last activity: [date] - [what happened]              ║
╚══════════════════════════════════════════════════════╝

[If incomplete work found:]
⚠️  Incomplete work detected:
    - [.continue-here file or incomplete plan details]

[If blockers exist:]
⚠️  Carried concerns:
    - [blocker 1]

[If UAT gaps exist:]
⚠️  UAT gaps need fixing:
    - [gap details]
```

## 5. Route to Next Action

Based on project state, determine the most logical next action:

| State | Primary Action | Also Available |
|-------|---------------|----------------|
| `.continue-here.md` exists | Resume from checkpoint | Start fresh on current plan |
| Plan without Summary | Complete incomplete plan | Abandon and move on |
| Phase complete, more phases | `/discuss-phase {N+1}` or `/plan-phase {N+1}` | Review completed work |
| Phase ready to plan, no CONTEXT.md | `/discuss-phase {N}` | `/plan-phase {N}` (skip discussion) |
| Phase ready to plan, CONTEXT.md exists | `/plan-phase {N}` | Review roadmap |
| Phase ready to execute | `/execute-phase {N}` | Review the plan first |
| UAT gaps found | `/plan-phase {N} --gaps` | Re-run `/verify-work` |
| All phases complete | Milestone complete! | `/verify-work` first |

Present contextual options:

```
What would you like to do?

1. [Primary action based on state]
2. [Secondary option]
3. Check progress (/progress)
4. Something else
```

## 6. Update Session

Before routing, update STATE.md session continuity:

```markdown
## Session Continuity

Last session: [now]
Stopped at: Session resumed, proceeding to [action]
```

## STATE.md Reconstruction

If STATE.md is missing but other artifacts exist:

1. Read PROJECT.md → Extract name and core value
2. Read ROADMAP.md → Determine phases, find current position
3. Scan `*-SUMMARY.md` files → Extract decisions, concerns
4. Check for `.continue-here` files → Session continuity

Reconstruct STATE.md and proceed normally.

## Quick Resume

If user says "continue" or "go":

- Load state silently
- Determine primary action
- Execute immediately without presenting options

"Continuing from [state]... [action]"
