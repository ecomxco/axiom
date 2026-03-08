---
description: Check current project status — where we are, what's done, what's next
---

# Progress

Quick status check. Run anytime.

## Process

1. Read `.planning/STATE.md`, `.planning/ROADMAP.md`
2. Scan for UAT files and gaps: `ls .planning/phases/*/*-UAT.md 2>/dev/null`
3. Present:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 PROJECT STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Project: [name]
Phase: [X] of [Y] ([name])
Plan: [A] of [B]
Progress: [████████░░] 80%
Last activity: [date] — [what]

## Phases

| # | Phase | Status | Plans |
|---|-------|--------|-------|
| 1 | [name] | ✓ | 3/3 |
| 2 | [name] | ◆ | 1/4 |
| 3 | [name] | ○ | 0/2 |

## Blockers
[Any blocking issues from STATE.md]

## ▶ Next
[Recommended next action based on routing table below]
```

4. Route to appropriate next command:

### Routing Table

| Route | State | Suggestion |
|-------|-------|------------|
| **A** | Unexecuted plans exist in current phase | `/execute-phase` |
| **B** | Phase not planned, no CONTEXT.md | `/discuss-phase` → then `/plan-phase` |
| **C** | Phase not planned, CONTEXT.md exists | `/plan-phase` |
| **D** | Phase execution complete, not verified | `/verify-work` |
| **E** | UAT gaps have fix plans (diagnosed) | `/execute-phase --gaps` to run fixes |
| **F** | Phase verified, next phase exists | `/discuss-phase {N+1}` or `/plan-phase {N+1}` |
| **G** | All phases complete | "Milestone complete!" |
| **H** | Between milestones (no active roadmap) | `/plan-project` for new milestone |
