---
description: Check current project status — where we are, what's done, what's next
---

# Progress

Status check with analysis. Run anytime.

## 1. Load State

```bash
cat .planning/STATE.md
cat .planning/ROADMAP.md
```

## 2. Scan Artifacts

```bash
# Count plans and summaries per phase
for phase_dir in .planning/phases/*/; do
  phase=$(basename "$phase_dir")
  plans=$(ls "$phase_dir"*-PLAN.md 2>/dev/null | wc -l | tr -d ' ')
  summaries=$(ls "$phase_dir"*-SUMMARY.md 2>/dev/null | wc -l | tr -d ' ')
  uat=$(ls "$phase_dir"*-UAT.md 2>/dev/null | wc -l | tr -d ' ')
  echo "$phase: $summaries/$plans plans complete, $uat UAT files"
done 2>/dev/null

# Check for handoff files (paused work)
find .planning/phases -name ".continue-here.md" 2>/dev/null

# Check for diagnosed UAT gaps
grep -rl "status: diagnosed" .planning/phases/ 2>/dev/null
```

## 3. Present Status Dashboard

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

| # | Phase | Status | Plans | Notes |
|---|-------|--------|-------|-------|
| 1 | [name] | ✓ | 3/3 | Verified |
| 2 | [name] | ◆ | 1/4 | In progress |
| 3 | [name] | ○ | 0/2 | Not started |
```

## 4. Risk Analysis

After presenting the dashboard, analyze for risks and patterns:

### Staleness Check

```bash
# Check last commit date
git log -1 --format="%cr" 2>/dev/null

# Check file ages for active phase
ls -lt .planning/phases/*/  2>/dev/null | head -5
```

| Indicator | Threshold | Action |
|-----------|-----------|--------|
| Phase idle > 3 days | ⚠️ Warning | "Phase [X] hasn't been touched in [N] days. Blocked or deprioritized?" |
| Phase idle > 7 days | 🛑 Risk | "Phase [X] is stale. Resume, defer, or re-scope?" |
| No commits in > 1 day when mid-execution | ⚠️ Warning | "Execution paused — consider `/pause-work` to preserve state" |

### Deviation Trend

If summaries exist, count deviations across completed plans:

```bash
grep -c "Rule [1-4]" .planning/phases/*/*-SUMMARY.md 2>/dev/null
```

| Pattern | Signal | Recommendation |
|---------|--------|----------------|
| Rising Rule 4 (architectural) deviations | Plans are underspecified | "Plans need more detail — consider running `/discuss-phase` before planning next phase" |
| Rising Rule 1-2 (bug/validation) deviations | Quality pressure | "Growing bug rate — consider slowing execution, adding more test coverage" |
| Zero deviations across 3+ plans | Plans are well-calibrated | "Plans are landing clean — good calibration ✓" |

### Test Debt

```bash
# Count unchecked test matrix items
grep -c "\[ \]" .planning/phases/*/*-TEST-MATRIX.md 2>/dev/null
```

If unchecked items > 0: "⚠️ [N] test matrix items incomplete — these will surface as UAT failures."

## 5. Blockers & Concerns

```
## Blockers
[Any blocking issues from STATE.md or .continue-here files]

## Concerns
[Trends surfaced from analysis above]
```

## 6. Route to Next Action

```
## ▶ Next
[Recommended next action based on routing table below]
```

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
| **I** | Phase stale (> 7 days idle) | "Re-assess: resume, defer, or re-scope?" |
