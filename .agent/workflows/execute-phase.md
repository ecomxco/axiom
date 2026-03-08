---
description: Execute all plans in a phase sequentially with deviation handling, atomic commits, and state tracking
---

# Execute Phase

Sequential plan execution with deviation handling, atomic commits, and state tracking.

Plans execute sequentially in the current context. To preserve context freshness, the user should `/clear` and re-invoke this workflow if context grows large mid-phase.

## Prerequisites

- Phase plans exist in `.planning/phases/XX-name/`
- `.planning/STATE.md` is current

## 1. Load Context

```bash
cat .planning/STATE.md
ls .planning/phases/XX-name/*-PLAN.md | sort
ls .planning/phases/XX-name/*-SUMMARY.md 2>/dev/null | sort
```

Identify next PLAN without a matching SUMMARY.

## 2. Execute Plan

For the current PLAN.md:

1. **Read the plan** — it IS the execution instructions
2. **Read @context files** referenced in the plan
3. **Per task:**
   - Implement with deviation rules (see below)
   - Verify done criteria
   - Commit immediately after verification:

```bash
# Stage individually — NEVER git add . or git add -A
git add src/specific/file.ts
git add src/specific/other.ts
git commit -m "{type}({phase}-{plan}): {description}"
```

**Commit types:**

| Type | When |
|------|------|
| `feat` | New functionality |
| `fix` | Bug fix |
| `test` | Test-only |
| `refactor` | No behavior change |
| `docs` | Documentation |
| `chore` | Config/deps |

## 3. Deviation Rules

You WILL discover unplanned work. Handle automatically:

| Rule | Trigger | Action | Permission |
|------|---------|--------|------------|
| **Rule 1: Bug** | Broken behavior, errors, type errors, security vulns | Fix → test → verify → track | **Auto** |
| **Rule 2: Missing Critical** | Missing validation, error handling, auth, CORS | Add → test → verify → track | **Auto** |
| **Rule 3: Blocking** | Missing deps, wrong types, broken imports | Fix → verify → track | **Auto** |
| **Rule 4: Architectural** | New DB table, schema change, switching libs, breaking API | **STOP → ask user** | **Ask** |

**Rule 4 format:**

```
⚠️ Architectural Decision Needed

Current task: [task name]
Discovery: [what prompted this]
Proposed change: [modification]
Why needed: [rationale]
Impact: [what this affects]
Alternatives: [other approaches]

Proceed with proposed change? (yes / different approach / defer)
```

**Priority:** Rule 4 (STOP) > Rules 1-3 (auto)
**Heuristic:** Affects correctness/security/completion? → Rules 1-3. Maybe? → Rule 4.

## 4. Spot-Check

After executing all tasks in a plan, verify claims before writing summary:

```bash
# Verify first 2 key files from plan actually exist
ls -la path/to/expected/file1.ts path/to/expected/file2.ts 2>/dev/null

# Verify git commits match what was claimed
git log --oneline -5

# Check for any self-check failure markers
grep -r "TODO\|FIXME\|HACK" path/to/modified/files/ 2>/dev/null | head -5
```

**If spot-check fails** (files missing, no commits, stubs found):

- Do NOT write summary
- Fix the issue first
- Re-verify

## 4.5 Test Matrix Verification (MANDATORY)

After spot-check passes, verify this plan's test matrix items:

1. **Read the TEST-MATRIX.md** for the current phase
2. **Check which test types are assigned to this plan**
3. **Run ALL assigned tests:**
   - Unit + Integration: `npx vitest run` (or equivalent)
   - Regression: Full test suite including prior phases
   - Contract: Schema alignment checks
   - Security: RLS isolation, auth, input validation tests
   - Boundary: Edge case tests
   - Math: Accuracy verification with known-correct values
4. **Update TEST-MATRIX.md:** Check off completed test items `[x]`

```bash
# Run full test suite (regression + unit + integration)
npm test

# Verify no security regressions
grep -r "ENABLE ROW LEVEL SECURITY" supabase/migrations/*.sql | wc -l
```

**If any test matrix item fails:**

- Fix before writing summary (same as spot-check failure)
- Track the fix as a deviation in the summary

## 5. Create Summary

After spot-check passes, create `{phase}-{plan}-SUMMARY.md`:

```markdown
---
phase: XX-name
plan: NN
duration: [X min]
completed: [YYYY-MM-DD]
---

# Phase [X] Plan [Y]: [Name] Summary

[One-liner SUBSTANTIVE: "JWT auth with refresh rotation using jose library" not "Auth implemented"]

## Tasks Completed

| # | Task | Commit | Files |
|---|------|--------|-------|
| 1 | [name] | [hash] | [files] |
| 2 | [name] | [hash] | [files] |

## Deviations from Plan

[Rule N - Category] Title — Found during: Task X | Fix: [what] | Files: [which]

OR: None — plan executed exactly as written.

## Key Files Created/Modified

- `path/to/file.ts` — [what it does]

## Next

[More plans → "Ready for {next-plan}" | Last plan → "Phase complete"]
```

## 6. Update State

Update `.planning/STATE.md`:

- Current position (phase, plan, status)
- Progress bar
- Last activity
- Session continuity

Update `.planning/ROADMAP.md`:

- Plan completion checkbox
- If last plan → mark phase "Complete" with date

Commit metadata:

```bash
git add .planning/phases/XX-name/{phase}-{plan}-SUMMARY.md .planning/STATE.md .planning/ROADMAP.md
git commit -m "docs({phase}-{plan}): complete [plan-name]"
```

## 7. Offer Next

| Condition | Action |
|-----------|--------|
| More plans in this phase | Show next plan, suggest `/execute-phase` |
| Phase complete, not verified | Show completion, suggest `/verify-work` |
| Phase complete, more phases | Suggest `/discuss-phase {N+1}` → `/plan-phase {N+1}` |
| All phases complete | Show milestone complete banner, suggest `/verify-work` |

**Context freshness reminder:** If this was a long execution, suggest: "Consider running `/clear` before next plan for maximum context freshness."
