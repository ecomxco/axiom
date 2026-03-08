---
description: Verify phase work using goal-backward methodology — conversational UAT with persistent state, severity inference, and gap diagnosis
---

# Verify Work

Goal-backward verification with conversational UAT, persistent state, and gap diagnosis.

## Purpose

Verification != "did the tasks get done?"
Verification = "does the goal work?"

A phase can have all tasks ✓ but still fail verification if:

- Files exist but are stubs
- Code compiles but doesn't do what the user needs
- Components render but aren't wired together
- Tests pass but cover wrong behavior

## When to Use

- After completing all plans in a phase
- To validate a specific deliverable before moving on
- Re-run with `--gaps-only` after fixes to verify remaining issues

## 1. Load Phase Context

```bash
# Load phase details
cat .planning/ROADMAP.md
cat .planning/STATE.md

# Load all summaries for this phase
cat .planning/phases/XX-name/*-SUMMARY.md

# Check if UAT.md already exists (resume case)
ls .planning/phases/XX-name/*-UAT.md 2>/dev/null
```

If UAT.md exists with status "in_progress" → **resume from last position** (see Step 3).

## 2. Post-Execution Gap Analysis

Before UAT, verify that execution delivered what was planned. Compare **summaries** (what was built) against **plans + source-of-truth docs** (what was promised).

### 2a. Plan Coverage Check

For each PLAN.md, check its matching SUMMARY.md:

```bash
# List plans without matching summaries (incomplete execution)
for plan in .planning/phases/XX-name/*-PLAN.md; do
  summary="${plan/PLAN/SUMMARY}"
  [ ! -f "$summary" ] && echo "MISSING: $summary"
done
```

- Every plan has a summary → ✓
- Missing summaries → **blocker** — plans were not executed

### 2b. Deviation Impact Check

Read all SUMMARY.md files and collect deviations:

- **Rule 4 deviations** (architectural) — did the user's decision get implemented correctly?
- **Rules 1-3 deviations** (auto-fixes) — did any auto-fix change scope?
- **Dropped tasks** — any tasks listed in plans but absent from summaries?

### 2c. Test Matrix Completion Check

```bash
cat .planning/phases/XX-name/*-TEST-MATRIX.md
```

Count unchecked items:

- `[ ]` items remaining = **test debt** (flag as UAT items)
- All `[x]` = ✓ matrix complete

### 2d. Source-of-Truth Alignment

Quick check against key source docs:

| Source | Check |
|--------|-------|
| CONTEXT.md locked decisions | Each decision reflected in built code (not just planned) |
| ROADMAP.md success criteria | Each criterion achievable with what was built |
| GAP-ANALYSIS.md (if exists) | All resolved gaps actually implemented, not just noted |
| STATE.md deferred items | Items deferred TO this phase were addressed |

### 2e. Report Pre-UAT Gaps

If gaps found:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 PRE-UAT GAP CHECK — PHASE [N]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Type | Count | Details |
|------|-------|---------|
| Missing summaries | [N] | Plans [X, Y] not executed |
| Dropped tasks | [N] | [list] |
| Unresolved deviations | [N] | [list] |
| Test matrix incomplete | [N] | [N] items unchecked |
| Context decisions missed | [N] | [list] |

⚠️  Fix these before UAT, or they become automatic UAT failures.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**If blockers found** (missing summaries, critical decisions missed) → stop, fix, re-run.
**If only test debt** → continue to UAT, but unchecked test matrix items become automatic test failures.
**If clean** → proceed to UAT.

## 3. Extract Testable Truths

From the phase goal and plan summaries, extract **user-observable truths** — things the user can verify by interacting with the system.

**Good truths (user can verify):**

- "Login form rejects invalid email format with visible error"
- "Dashboard loads within 2 seconds and shows real data"
- "Clicking 'Export' downloads a CSV file with all records"

**Bad truths (implementation details):**

- "useEffect has correct dependency array"
- "API uses JWT middleware"
- "Database has index on user_id column"

Organize truths by priority:

1. **Phase goal truths** — Does the stated goal actually work?
2. **Wiring truths** — Are the pieces connected end-to-end?
3. **Edge case truths** — Do boundary conditions behave correctly?

### Mandatory Verification Categories (ALWAYS include)

In addition to phase-specific truths, EVERY phase UAT MUST include these categories:

**Security Verification (NEVER skip for phases with DB tables or API endpoints):**

- RLS tenant isolation — query as Tenant A, confirm zero data from Tenant B
- Auth enforcement — unauthenticated requests rejected (401/403)
- Governance tokens — write operations without valid token rejected
- Input sanitization — malicious/invalid inputs rejected, no SQL injection vectors
- Sensitive data — no cross-tenant data leakage in error messages or responses

**Regression Verification (NEVER skip):**

- Full test suite passes (`npm test` / `npx vitest run`)
- Phase N-1 functionality still works after Phase N changes
- No new test failures introduced

**Test Matrix Completion:**

- Read the phase's TEST-MATRIX.md
- Verify all `[ ]` items are now `[x]` (completed during execution)
- Any unchecked items become UAT failures

## 4. Create/Update UAT.md

Create `.planning/phases/XX-name/XX-UAT.md` with persistent state:

```markdown
---
phase: XX
status: in_progress
total_tests: [N]
current_test: 1
passed: 0
failed: 0
skipped: 0
last_updated: [timestamp]
---

# Phase [X]: [Name] — User Acceptance Testing

## Tests

1. **[Truth statement]**
   - Expected: [what should happen]
   - Status: pending

2. **[Truth statement]**
   - Expected: [what should happen]
   - Status: pending

[...all truths]

## Gaps

[Empty until gaps found]
```

## 5. Present Tests One-at-a-Time

**This is a conversational loop.** Present ONE test at a time:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 TEST [X] of [N]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Truth statement]

Expected: [what should happen]

How to verify: [specific steps the user can take]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Wait for user response.

### Interpreting User Responses

Users respond in natural language. **Infer the result:**

| User Says | Result | Severity |
|-----------|--------|----------|
| "pass", "works", "good", "✓", "yes" | **Pass** | — |
| "skip", "can't test", "later" | **Skip** | — |
| "crashes", "error", "500", "blank screen" | **Fail** | blocker |
| "doesn't work", "broken", "not happening" | **Fail** | major |
| "partially works", "but...", "almost" | **Fail** | major |
| "looks off", "misaligned", "wrong color" | **Fail** | minor |
| "nitpick", "would be nice", "small thing" | **Fail** | cosmetic |

**After each response:**

1. Update the test status in UAT.md
2. If fail: capture the user's exact words as the `reason`
3. Present next test

**Don't ask for severity explicitly.** Infer it from their description. If ambiguous, defaulting to "major" is safe.

## 6. Update UAT.md Continuously

After each test response, update the UAT.md file:

```yaml
1. **Login form rejects invalid email**
   - Expected: Red error border + message
   - Status: passed

2. **Dashboard shows real data**
   - Expected: Records from database displayed
   - Status: failed
   - Reason: "shows loading spinner forever, never loads data"
   - Severity: blocker
```

Update frontmatter counters (passed/failed/skipped/current_test) so session can be resumed.

## 7. Session Resume

If the session is interrupted (context clear, timeout, etc.), the UAT.md **persists on disk.**

On resume:

1. Read UAT.md frontmatter for `current_test`
2. Skip already-tested items
3. Continue from where left off

```
Resuming UAT session...
Completed: [X] tests ([P] passed, [F] failed, [S] skipped)
Continuing from test [current_test]...
```

## 8. Present Results

After all tests complete:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 UAT COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Results: [passed] ✓  [failed] ✗  [skipped] ○  of [total]

[If all passed:]
  Phase [X] verified ✓ — all truths confirmed.

[If gaps found:]
  ## Gaps Found

  | # | Truth | Severity | Issue |
  |---|-------|----------|-------|
  | 2 | Dashboard shows real data | blocker | Loading spinner forever |
  | 5 | Export downloads CSV | major | File empty, no records |
  | 7 | Mobile layout responsive | minor | Button overlaps on iPhone SE |
```

## 9. Handle Gaps

If gaps were found, route based on severity:

### Any Blockers or Major Issues

```
[N] gaps found ([B] blockers, [M] major, [m] minor).

Recommended next step: Diagnose root causes.

Run /diagnose-issues to investigate, then /plan-phase [N] --gaps to fix.
```

### Only Minor/Cosmetic Issues

```
[N] minor issues found. Phase core functionality works.

Options:
1. Fix now — /plan-phase [N] --gaps
2. Fix later — note as tech debt, continue to next phase
3. Accept — cosmetic issues, not worth a fix plan
```

## 10. Capture Lessons (after UAT passes)

After successful verification, append to `.planning/LESSONS.md`:

```markdown
### Phase [X]: [Name] — Lessons

**Date:** [date]

**What Went Well:**
- [Pattern or approach that worked — carry forward]

**What to Watch For:**
- [Gotcha or surprise encountered — warn future phases]

**Process Observations:**
- [E.g., "Plans were overscoped", "Research phase saved significant rework", etc.]
```

This file accumulates across phases. `/plan-phase` reads it before planning the next phase to avoid repeating mistakes and reinforce what works.

```bash
mkdir -p .planning
git add .planning/LESSONS.md
git commit -m "docs(phase-XX): lessons learned"
```

## 11. Commit UAT

```bash
git add .planning/phases/XX-name/*-UAT.md
git commit -m "docs(phase-XX): UAT [passed/X] of [total] (status)"
```

Update STATE.md with verification results.

## --gaps-only Mode

When running after fixes have been applied:

1. Read existing UAT.md
2. Find all tests with `status: failed`
3. Re-test ONLY those items
4. Update results in place
5. If all now pass → phase verified ✓
6. If gaps remain → another round of diagnosis/fixing

## Success Criteria

- [ ] Post-execution gap analysis performed before UAT (plan coverage, deviations, test matrix, source-of-truth)
- [ ] Testable truths extracted from phase goal (not implementation details)
- [ ] One-test-at-a-time conversational flow
- [ ] Severity inferred from natural language (no explicit severity questions)
- [ ] UAT.md persists across sessions with resume capability
- [ ] Gaps have root cause information after diagnosis
- [ ] Clear routing to fix workflow when gaps found
- [ ] STATE.md updated with verification results
