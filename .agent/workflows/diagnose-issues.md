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
1. Establish reproduction steps
2. Classify the root cause category
3. Form and test hypotheses
4. Document what was ruled out
5. Identify specific root cause with evidence
```

## 3. Investigate Each Gap

For each gap, follow this structured investigation:

### Step 1: Reproduction

Before hypothesizing, establish clear reproduction steps:

```markdown
**Reproduction:**
1. [Navigate to / trigger condition]
2. [Perform action]
3. [Observe: expected vs actual]

**Reproducible:** always / intermittent / environment-specific
```

If the issue is intermittent, note under what conditions it occurs vs doesn't.

### Step 2: Root Cause Classification

Classify the likely category to focus investigation:

| Category | Indicators | Where to Look |
|----------|-----------|----------------|
| **Logic Error** | Wrong output, incorrect calculation, bad conditional | Business logic functions, state management |
| **Data Flow** | Data exists but doesn't reach UI, stale state | Props, context, API responses, subscriptions |
| **Integration** | Works in isolation, fails when connected | API contracts, type mismatches, auth headers |
| **Race Condition** | Intermittent, order-dependent, timing-sensitive | Async operations, concurrent writes, event ordering |
| **Configuration** | Works locally not in prod, env-specific | Environment variables, build config, feature flags |
| **Schema Mismatch** | Type errors, null where expected, missing fields | DB schema vs TypeScript types vs API shapes |
| **Missing Implementation** | Feature simply not built, stub left behind | Check for TODO/FIXME, empty handlers, placeholder UI |
| **Dependency** | Broke after update, version conflict | package.json changes, breaking API changes |

### Step 3: Hypothesis Formation

Based on the symptom and classification, form hypotheses (as many as the symptom warrants — simple bugs may need 2, complex issues may need 5+):

- What could make [expected] not happen?
- What code path would produce this behavior?
- What's the most likely failure point?

### Step 4: Evidence Gathering

Use tools to test hypotheses:

```bash
# Search for relevant code
grep -r "relevantPattern" src/
# Check specific files
cat src/components/RelevantFile.tsx
# Check for common issues
grep -n "useEffect\|useState\|fetch" src/components/RelevantFile.tsx
# Check for stubs
grep -rn "TODO\|FIXME\|HACK\|not implemented" src/
```

### Step 5: Document Ruled-Out Hypotheses

**Critical:** Track what was checked AND what was eliminated. This prevents future investigators from repeating dead ends.

For each hypothesis tested:

```markdown
**Hypothesis:** [what you suspected]
**Evidence checked:** [what you looked at]
**Result:** ✗ Ruled out — [why this isn't the cause]
```

### Step 6: Root Cause Determination

For each gap, document:

- **Root cause**: Specific code issue with evidence (file, line, what's wrong)
- **Category**: From the taxonomy above
- **Files involved**: Which files need changes
- **Suggested fix direction**: Brief hint for the planner
- **Confidence**: High (definitive evidence) / Medium (strong evidence) / Low (best guess)

## 4. Update UAT.md with Diagnoses

For each gap in the Gaps section, add comprehensive root cause information:

```yaml
- truth: "Comment appears immediately after submission"
  status: failed
  reason: "User reported: works but doesn't show until I refresh the page"
  severity: major
  test: 2
  root_cause: "useEffect in CommentList.tsx missing commentCount dependency"
  category: data_flow
  confidence: high
  reproduction: "Submit comment → observe list doesn't update → refresh page → comment appears"
  artifacts:
    - path: "src/components/CommentList.tsx"
      issue: "useEffect missing dependency"
  ruled_out:
    - "API not saving: Confirmed comment exists in DB immediately after POST"
    - "Caching: No service worker or cache headers interfering"
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

## 5. Cross-Gap Pattern Analysis

After diagnosing all gaps, look for patterns:

| Pattern | Signal | Recommendation |
|---------|--------|----------------|
| Multiple gaps in same file | Systemic issue, not isolated bugs | Consider refactoring the file, not just patching |
| Multiple data_flow issues | State management architecture problem | Review state management approach holistically |
| Multiple schema_mismatch issues | Types are drifting from schema | Add contract tests, consider code generation |
| Gaps cluster around integration points | API contracts are underspecified | Add integration tests, document contracts |

## 6. Report Results

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 DIAGNOSIS COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Gap (Truth) | Category | Root Cause | Confidence | Files |
|-------------|----------|------------|------------|-------|
| Comment appears immediately | data_flow | useEffect missing dep | high | CommentList.tsx |
| Reply button positioned | logic_error | CSS flex order wrong | high | ReplyButton.tsx |
| Delete removes comment | integration | API missing auth header | high | api/comments.ts |

Patterns: [any cross-gap patterns identified]
Hypotheses ruled out: [N] (preserved in UAT.md for audit trail)

Proceeding to plan fixes...
```

Return to `/verify-work` for automatic fix planning, or present:

```
## ▶ Next
Run /plan-phase [N] --gaps to create fix plans
```
