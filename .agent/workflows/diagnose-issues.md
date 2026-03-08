---
description: Investigate root causes of UAT gaps before planning fixes — diagnose WHY things are broken, not just WHAT
---

# Diagnose Issues

Investigates UAT gaps sequentially to find root causes before creating fix plans.

**Core principle:** Diagnose before planning fixes. UAT tells us WHAT is broken (symptoms). This workflow finds WHY (root cause). Then `/plan-phase --gaps` creates targeted fixes based on actual causes, not guesses.

Without diagnosis: "Comment doesn't refresh" → guess at fix → maybe wrong
With diagnosis: "Comment doesn't refresh" → "useEffect missing dependency" → precise fix

Investigation runs sequentially using scientific debugging methodology: hypothesis → evidence → root cause.

## When to Use

- Called automatically from `/verify-work` when UAT finds issues
- Can also be run standalone on a UAT.md file with gaps

## 1. Parse Gaps from UAT.md

Read the "Gaps" section (YAML format) from the phase's UAT.md:

```bash
cat .planning/phases/XX-name/*-UAT.md
```

For each gap, extract:

- `truth`: The expected behavior that failed
- `reason`: Verbatim user description
- `severity`: Inferred severity
- `test`: Test number

## 2. Report Diagnosis Plan

```
## Diagnosing [N] Gaps

Investigating root causes sequentially:

| Gap (Truth) | Severity |
|-------------|----------|
| Comment appears immediately after submission | major |
| Reply button positioned correctly | minor |
| Delete removes comment | blocker |

Each investigation will:
1. Read relevant source files
2. Form hypotheses
3. Test hypotheses against actual code
4. Identify root cause
```

## 3. Investigate Each Gap

For each gap, perform scientific debugging:

### Hypothesis Formation

Based on the symptom, form 2-3 hypotheses about the cause:

- What could make [expected] not happen?
- What code path would produce this behavior?
- What's the most likely failure point?

### Evidence Gathering

Use tools to test hypotheses:

```bash
# Search for relevant code
grep -r "relevantPattern" src/
# Check specific files
cat src/components/RelevantFile.tsx
# Check for common issues
grep -n "useEffect\|useState\|fetch" src/components/RelevantFile.tsx
```

### Root Cause Determination

For each gap, determine:

- **Root cause**: Specific code issue with evidence
- **Files involved**: Which files need changes
- **Suggested fix direction**: Brief hint for the planner

## 4. Update UAT.md with Diagnoses

For each gap in the Gaps section, add root cause information:

```yaml
- truth: "Comment appears immediately after submission"
  status: failed
  reason: "User reported: works but doesn't show until I refresh the page"
  severity: major
  test: 2
  root_cause: "useEffect in CommentList.tsx missing commentCount dependency"
  artifacts:
    - path: "src/components/CommentList.tsx"
      issue: "useEffect missing dependency"
  missing:
    - "Add commentCount to useEffect dependency array"
    - "Trigger re-render when new comment added"
```

Update frontmatter status to "diagnosed".

Commit:

```bash
git add .planning/phases/XX-name/*-UAT.md
git commit -m "docs(phase-XX): add root causes from diagnosis"
```

## 5. Report Results

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 DIAGNOSIS COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Gap (Truth) | Root Cause | Files |
|-------------|------------|-------|
| Comment appears immediately | useEffect missing dep | CommentList.tsx |
| Reply button positioned | CSS flex order wrong | ReplyButton.tsx |
| Delete removes comment | API missing auth header | api/comments.ts |

Proceeding to plan fixes...
```

Return to `/verify-work` for automatic fix planning, or present:

```
## ▶ Next
Run /plan-phase [N] --gaps to create fix plans
```
