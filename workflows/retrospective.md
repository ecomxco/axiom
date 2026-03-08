---
description: End-of-milestone reflection with velocity analysis, process improvements, and team learnings
---

# Retrospective

Structured reflection at the end of a milestone (all phases complete). Goes beyond per-phase LESSONS.md to analyze patterns across the entire milestone.

**Core principle:** Retrospectives aren't about blame — they're about making the next milestone faster, smoother, and higher quality.

## When to Use

- After all phases in a milestone are verified
- After `/verify-work` passes on the final phase
- Periodically on long-running projects (quarterly)

## 1. Gather Data

```bash
# Load all planning artifacts
cat .planning/STATE.md
cat .planning/ROADMAP.md
cat .planning/LESSONS.md 2>/dev/null

# Count completed work
echo "=== Phases ==="
ls -d .planning/phases/*/ 2>/dev/null | wc -l | tr -d ' '

echo "=== Plans executed ==="
find .planning/phases -name "*-SUMMARY.md" 2>/dev/null | wc -l | tr -d ' '

echo "=== UAT files ==="
find .planning/phases -name "*-UAT.md" 2>/dev/null | wc -l | tr -d ' '

echo "=== Deviations ==="
grep -r "Rule [1-4]" .planning/phases/*/*-SUMMARY.md 2>/dev/null | wc -l | tr -d ' '

echo "=== Gaps diagnosed ==="
grep -r "root_cause" .planning/phases/*/*-UAT.md 2>/dev/null | wc -l | tr -d ' '
```

## 2. Velocity Analysis

Extract timing data from summaries:

```bash
# Pull duration from summary frontmatter
grep -r "^duration:" .planning/phases/*/*-SUMMARY.md 2>/dev/null
grep -r "^started:" .planning/phases/*/*-SUMMARY.md 2>/dev/null
grep -r "^completed:" .planning/phases/*/*-SUMMARY.md 2>/dev/null
```

Calculate and present:

```
## Velocity

| Phase | Plans | Total Duration | Avg per Plan |
|-------|-------|----------------|--------------|
| 01-foundation | 3 | 2h 45m | 55m |
| 02-features | 4 | 4h 20m | 1h 05m |
| 03-polish | 2 | 1h 10m | 35m |

Overall: [N] plans in [total time]
Average plan execution: [X] minutes
Fastest: [plan name] ([time])
Slowest: [plan name] ([time])
```

### Velocity Trend

```
Early phases:  ████████░░ slower (learning, setup)
Middle phases: ██████░░░░ normal
Later phases:  ████░░░░░░ faster (patterns established)
```

Is this pattern healthy? Typically, velocity should improve as patterns are established. If later phases are slower, investigate why.

## 3. Quality Analysis

### Deviation Patterns

```bash
grep -r "Rule [1-4]" .planning/phases/*/*-SUMMARY.md 2>/dev/null | \
  sed 's/.*Rule /Rule /' | sort | uniq -c | sort -rn
```

| Pattern | Count | Signal |
|---------|-------|--------|
| Rule 1 (bug fix) | [N] | [healthy/concerning] |
| Rule 2 (missing validation) | [N] | [healthy/concerning] |
| Rule 3 (critical item) | [N] | [healthy/concerning] |
| Rule 4 (architectural STOP) | [N] | [healthy/concerning] |

### UAT Pass Rate

```
First-pass UAT pass rate: [X]%
Gaps requiring diagnosis: [N]
Gaps requiring re-planning: [N]
```

## 4. Process Reflection

For each category, identify what to **keep**, **stop**, and **start**:

### What Worked (Keep)

- [Patterns, practices, or approaches that produced good results]
- [Things that saved time or prevented issues]

### What Didn't Work (Stop)

- [Practices that wasted time or caused problems]
- [Recurring friction points]

### What to Try Next (Start)

- [New practices suggested by the data]
- [Process improvements for the next milestone]

## 5. Consolidate LESSONS.md

If LESSONS.md has accumulated per-phase entries, synthesize them into milestone-level insights:

```markdown
## Milestone: [Name] — Consolidated Lessons

**Date:** [date]
**Phases:** [N] | **Plans:** [N] | **Duration:** [total]

### Process Insights
- [Cross-cutting lesson 1]
- [Cross-cutting lesson 2]

### Technical Insights
- [Architectural pattern that worked/failed]
- [Tool or library lesson]

### Carry Forward
- [Specific recommendation for the next milestone]
```

## 6. Archive and Reset

```bash
# Archive the milestone
mkdir -p .planning/archive/milestone-[NN]
cp .planning/ROADMAP.md .planning/archive/milestone-[NN]/
cp .planning/LESSONS.md .planning/archive/milestone-[NN]/

# Commit archive
git add .planning/archive/milestone-[NN]/
git commit -m "docs: archive milestone [NN] retrospective"
```

## 7. Complete

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 RETROSPECTIVE COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Milestone: [name]
Phases: [N] completed
Plans: [N] executed in [total time]
UAT pass rate: [X]% first-pass
Deviations: [N] total ([breakdown])

Key takeaway: [one-liner]

## ▶ Next
Run /plan-project for the next milestone
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
