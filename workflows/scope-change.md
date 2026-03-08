---
description: Formal mid-project scope change with impact analysis, roadmap adjustment, and stakeholder alignment
---

# Scope Change

Structured process for handling scope changes mid-project. Prevents scope creep by making the cost of change visible before committing to it.

**Core principle:** Scope changes aren't bad — untracked scope changes are. Every change gets an impact assessment so the decision is informed, not impulsive.

## When to Use

- User requests new features mid-project
- Discovery reveals requirements that weren't in the original scope
- External factors change project priorities (market shift, dependency EOL, etc.)
- `/discuss-phase` surfaces ideas that belong in a different phase or milestone

## 1. Capture the Change Request

Before analyzing, capture the request clearly:

```markdown
## Scope Change Request

**Requested by:** [user / discovery / external]
**Date:** [date]
**Description:** [What is being requested?]
**Motivation:** [Why is this needed now?]
```

Ask: "Can you describe what specifically you want added, changed, or removed?"

## 2. Classify the Change

| Type | Description | Typical Impact |
|------|-------------|----------------|
| **Addition** | New feature, endpoint, page, integration | New phase or plans added |
| **Modification** | Change to existing requirement or behavior | Re-plan affected phases |
| **Removal** | Feature or requirement dropped | Plans removed, phases simplified |
| **Pivot** | Fundamental direction change | Major roadmap restructure |
| **Reprioritization** | Same scope, different order | Phase resequencing |

## 3. Impact Analysis

### Affected Artifacts

```bash
# Check what's been planned and executed
echo "=== Current roadmap ==="
cat .planning/ROADMAP.md

echo "=== Requirements ==="
cat .planning/REQUIREMENTS.md 2>/dev/null

echo "=== In-progress work ==="
find .planning/phases -name ".continue-here.md" 2>/dev/null
find .planning/phases -name "*-PLAN.md" -newer .planning/phases -name "*-SUMMARY.md" 2>/dev/null
```

### Impact Matrix

For each affected area, assess:

```
| Area | Impact | Details |
|------|--------|---------|
| REQUIREMENTS.md | [add/modify/remove] | [which requirements] |
| ROADMAP.md | [add phase/reorder/remove phase] | [which phases] |
| Active phase | [no impact/needs re-plan/blocked] | [specifics] |
| Completed work | [no impact/needs rework] | [what would change] |
| Timeline | [+N days/weeks / no change / shorter] | [estimate] |
| Dependencies | [new deps / changed deps / none] | [specifics] |
```

### Risk Assessment

| Risk | Level | Mitigation |
|------|-------|------------|
| Rework of completed phases | 🟢 Low / 🟡 Med / 🔴 High | [specifics] |
| Timeline impact | 🟢 Low / 🟡 Med / 🔴 High | [specifics] |
| Technical complexity added | 🟢 Low / 🟡 Med / 🔴 High | [specifics] |
| Scope creep potential | 🟢 Low / 🟡 Med / 🔴 High | [specifics] |

## 4. Present Options

Present the change with clear options:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SCOPE CHANGE ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Change: [one-liner description]
Type: [addition/modification/removal/pivot]

Impact:
  Phases affected: [N]
  Rework required: [none/minimal/significant]
  Timeline impact: [+N days / none]

Options:
  1. Accept — Integrate now, update roadmap
  2. Defer — Add to backlog for next milestone
  3. Modify — Accept with reduced scope
  4. Reject — Keep current plan unchanged
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Wait for user decision.

## 5. Execute the Decision

### If Accepted

1. Update REQUIREMENTS.md with new/modified requirements
2. Update ROADMAP.md with phase changes
3. If active phase affected → update or re-plan
4. Update STATE.md with scope change record

```bash
git add .planning/REQUIREMENTS.md .planning/ROADMAP.md .planning/STATE.md
git commit -m "docs: scope change — [brief description]"
```

### If Deferred

Add to a backlog section in STATE.md:

```markdown
## Backlog (Deferred Scope)

- [ ] [Description] — Deferred [date]: [reason]
```

### If Rejected

Record the decision for audit trail:

```markdown
## Rejected Changes

| Date | Request | Reason |
|------|---------|--------|
| [date] | [description] | [why rejected] |
```

## 6. Route to Next Action

```
## ▶ Next

[Based on decision:]
- Accepted (new phase): /discuss-phase [N] → /plan-phase [N]
- Accepted (modify current): /plan-phase [N] --replan
- Deferred: Continue with /execute-phase or /progress
- Rejected: Continue with current plan
```
