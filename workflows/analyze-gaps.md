---
description: Analyze plans against phase context, research, and project requirements to find gaps before execution — catch what planning missed
---

# Analyze Gaps

New workflow for Antigravity. Sits between `/plan-phase` and `/execute-phase`.

**Philosophy:** Planning is comprehensive but never perfect. Context decisions get overlooked, research findings don't make it into plans, test coverage has blind spots, and cross-phase dependencies get missed. Catching gaps *before* execution is 10x cheaper than catching them *after*.

**Core principle:** Plans are compared against the *source of truth* documents — CONTEXT.md, RESEARCH.md, ROADMAP.md, PROJECT.md, architecture diagrams, and the test matrix — to find anything that was promised, decided, or discovered but not planned.

## When to Use

- **After `/plan-phase`** — before starting execution
- **After updating plans** — re-run to verify gap fixes
- Can also be run standalone against any phase with plans

## Prerequisites

- Phase plans exist: `.planning/phases/XX-name/*-PLAN.md`
- Phase test matrix exists: `.planning/phases/XX-name/*-TEST-MATRIX.md`
- At least one source of truth doc exists (CONTEXT.md, RESEARCH.md, ROADMAP.md)

## 1. Load All Source-of-Truth Documents

```bash
# Phase-level context
cat .planning/phases/XX-name/*-CONTEXT.md 2>/dev/null
cat .planning/phases/XX-name/*-RESEARCH.md 2>/dev/null

# Project-level context
cat .planning/ROADMAP.md
cat .planning/PROJECT.md
cat .planning/STATE.md

# Architecture (if exists)
cat .context/architecture-diagram.md 2>/dev/null

# All plans for this phase
cat .planning/phases/XX-name/*-PLAN.md

# Test matrix
cat .planning/phases/XX-name/*-TEST-MATRIX.md
```

Build an internal index of:
- **Locked decisions** from CONTEXT.md
- **Research findings** from RESEARCH.md
- **Phase success criteria** from ROADMAP.md
- **Deferred items** from STATE.md (anything deferred TO this phase)
- **Architecture constraints** from architecture diagrams
- **Cross-phase dependencies** (data ready from prior phases, data expected by future phases)

## 2. Run Gap Checks

Perform each check systematically. For each, compare the source-of-truth against all plans and the test matrix.

### Check 1: Context Decision Coverage

For each **locked decision** in CONTEXT.md:
- Is it reflected in at least one plan?
- Is the implementation approach correct (matches the decision, not a variant)?

**Common misses:**
- Decision made about routing/layout but plan uses different approach
- User specified a library/tool but plan doesn't install/use it
- Behavior specified but no plan implements it
- Decision about data source but plan queries different table

### Check 2: Research Finding Coverage

For each **key finding** in RESEARCH.md:
- Are library choices reflected in dependency setup plans?
- Are identified patterns/APIs used correctly in implementation plans?
- Are documented gotchas/pitfalls addressed?
- Are performance recommendations incorporated?

### Check 3: Roadmap Success Criteria Coverage

For each **success criterion** and **deliverable** in ROADMAP.md for this phase:
- Is there a plan that delivers it?
- Can the criterion be verified from the test matrix?

### Check 4: Deferred Item Resolution

For each item in STATE.md **deferred TO this phase**:
- Is it addressed in a plan?
- Is it in the test matrix?

### Check 5: Cross-Phase Data Flow

**Backward (consuming):** For each data source from prior phases:
- Does the phase actually USE the data it claims to need?
- Are queries/subscriptions to prior-phase tables planned?

**Forward (preparing):** For each future phase that depends on this one:
- Does this phase prepare the foundation it needs?
- Are skeleton pages, schema stubs, or interface contracts planned?

### Check 6: Architecture Alignment

If architecture diagrams exist:
- Do route paths match the architecture?
- Do component hierarchies match the architecture?
- Are Realtime subscriptions, API endpoints, or data flows correctly reflected?
- Do agent/entity names match between architecture and plans?

### Check 7: Test Matrix Completeness

For each plan:
- Are ALL new components/features covered by at least one test?
- Are Realtime subscriptions tested?
- Are responsive breakpoints tested?
- Are accessibility basics covered (reduced-motion, focus trapping, aria)?
- Are i18n/l10n requirements tested?
- Are performance budgets defined?
- Are design system compliance rules tested (token usage, no hardcoded values)?

### Check 8: Internal Consistency

Across all plans:
- Do file paths reference the correct route structure?
- Are shared components defined before they're consumed?
- Are dependency installation plans ordered before usage plans?
- Do plan `depends_on` fields accurately reflect true dependencies?

### Check 9: Scope Creep

For each task across all plans, verify it traces back to a source-of-truth document:
- Is this task required by CONTEXT.md (locked decision)?
- Is this task required by ROADMAP.md (phase deliverable or success criterion)?
- Is this task recommended by RESEARCH.md (best practice or gotcha mitigation)?
- Is this task required by STATE.md (deferred item targeting this phase)?
- Is this task required for a future phase dependency (forward prep)?

**If a task has no traceability** → flag it:

| Disposition | When to apply |
|-------------|---------------|
| **Keep — implicit requirement** | Clearly necessary even if not explicitly stated (e.g., error handling, types, imports) |
| **Keep — best practice** | Industry standard that improves quality (e.g., loading states, empty states) |
| **Remove** | Gold-plating, nice-to-have that wasn't requested or researched |
| **Defer** | Valuable but belongs in a later phase |

**Common scope creep patterns:**
- Adding features "while we're in there" that nobody asked for
- Over-engineering components beyond what the phase requires
- Prematurely optimizing for future phases that haven't been planned
- Adding extra test infrastructure beyond what the test matrix defines

## 3. Classify Gaps

Every gap gets a severity:

| Severity | Definition | Example |
|----------|-----------|---------|
| **Critical** | Missing feature, wrong architecture, data flow broken | Route structure incorrect, Realtime sub missing, wrong data source |
| **Moderate** | Missing enhancement, incomplete implementation, UX gap | Animation not planned, i18n missing, settings panel incomplete |
| **Test Gap** | Test matrix hole — feature exists in plan but no verification | No Realtime test, no responsive test, no accessibility test |

## 4. Propose Resolutions

For each gap, propose a resolution:

- **Which plan to update** — prefer modifying existing plans over creating new ones
- **What specifically to add/change** — concrete implementation detail
- **Why this resolution** — reference the source-of-truth that demands it

**Resolution strategies (ordered by preference):**
1. Add to existing plan (smallest blast radius)
2. Expand test matrix (test-only gaps)
3. Create new plan tasks (if gap is too large for bolt-on)
4. Defer to future phase (if genuinely out of scope — must justify)

## 5. Write GAP-ANALYSIS.md

Create `.planning/phases/XX-name/XX-GAP-ANALYSIS.md`:

```markdown
---
phase: XX-name
status: identified | resolved
total_gaps: [N]
critical: [N]
moderate: [N]
test_gaps: [N]
analyzed_against:
  - CONTEXT.md
  - RESEARCH.md
  - ROADMAP.md
  - PROJECT.md
  - architecture-diagram.md
  - TEST-MATRIX.md
---

# Phase [X]: [Name] — Gap Analysis

> [Summary line: N gaps found — N critical, N moderate, N test gaps]

## Critical Gaps

| ID | Gap | Source | Resolution | Plan |
|----|-----|--------|-----------|------|
| GAP-01 | [what's missing] | [which source doc] | [proposed fix] | [plan to update] |

## Moderate Gaps

| ID | Gap | Source | Resolution | Plan |
|----|-----|--------|-----------|------|
| GAP-05 | [what's missing] | [which source doc] | [proposed fix] | [plan to update] |

## Test Matrix Gaps

| ID | Gap | Source | Resolution | Tests Added |
|----|-----|--------|-----------|-------------|
| TG-01 | [what's not tested] | [which plan] | [proposed test] | [count] |

## No Gaps Found (if applicable)

[If a check category found zero gaps, note it here with a brief justification for confidence]

## Summary

| Metric | Value |
|--------|-------|
| Critical gaps | [N] |
| Moderate gaps | [N] |
| Test matrix gaps | [N] |
| Plans requiring updates | [list] |
| Test matrix items to add | [N] |
```

## 6. Present Findings

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GAP ANALYSIS — PHASE [N]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Analyzed [N] plans + test matrix against:
  CONTEXT.md · RESEARCH.md · ROADMAP.md · architecture

[If gaps found:]
  Found [N] gaps: [C] critical · [M] moderate · [T] test gaps

  | ID | Gap | Severity | Plan |
  |----|-----|----------|------|
  | GAP-01 | [description] | critical | 07 |
  | GAP-02 | [description] | moderate | 02 |
  | TG-01 | [description] | test gap | matrix |

  ▶ Next: Review gaps and apply fixes to plans + test matrix.
     Then re-run /analyze-gaps --verify to confirm all resolved.

[If no gaps:]
  ✅ No gaps found. Plans and test matrix are comprehensive.

  ▶ Next: Run /execute-phase [N] to begin execution.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 7. Apply Fixes (Interactive)

If gaps were found, walk through each gap with the user:

1. **Present the gap** — source, what's missing, proposed resolution
2. **Get user decision** — Accept proposed fix? Different approach? Defer? Override (not a gap)?
3. **Apply the fix** — Update the relevant PLAN.md or TEST-MATRIX.md
4. **Track in GAP-ANALYSIS.md** — Mark as resolved with the chosen approach

After all gaps are addressed:

```bash
git add .planning/phases/XX-name/*-PLAN.md
git add .planning/phases/XX-name/*-TEST-MATRIX.md
git add .planning/phases/XX-name/*-GAP-ANALYSIS.md
git commit -m "docs(phase-XX): gap analysis — [N] gaps resolved"
```

Update GAP-ANALYSIS.md frontmatter `status: resolved`.

## 8. --verify Mode

When running after fixes have been applied:

1. Read existing GAP-ANALYSIS.md
2. Re-run all 9 checks against the UPDATED plans and test matrix
3. Confirm all previously identified gaps are now resolved
4. Check for any NEW gaps introduced by the fixes
5. If clean → mark as verified, proceed to execution
6. If new gaps → another resolution round

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GAP VERIFICATION — PHASE [N]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Previously: [N] gaps found
Resolved: [N]
New gaps: [N]

[If all clear:]
  ✅ All gaps resolved. No new gaps introduced.
  ▶ Next: /execute-phase [N]

[If new gaps:]
  ⚠️ [N] new gaps found during fix application.
     Re-running resolution...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Success Criteria

- [ ] All 9 gap checks performed against source-of-truth documents
- [ ] Every locked decision from CONTEXT.md accounted for in plans
- [ ] Every research finding from RESEARCH.md reflected in plans
- [ ] Every deferred item targeted at this phase is addressed
- [ ] Cross-phase data flows validated (backward and forward)
- [ ] Test matrix covers all new features, Realtime subs, responsive behavior, a11y, i18n
- [ ] GAP-ANALYSIS.md persists with full audit trail
- [ ] Fixes applied to plans AND test matrix (not just noted)
- [ ] --verify mode confirms all gaps resolved before execution begins
