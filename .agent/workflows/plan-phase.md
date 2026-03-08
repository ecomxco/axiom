---
description: Plan a specific phase by breaking it into atomic executable plans with task breakdown, dependency analysis, and goal-backward verification
---

# Plan Phase

Break a phase into atomic executable plans with task breakdown, dependency analysis, and goal-backward verification.

## Prerequisites

- `.planning/PROJECT.md` exists
- `.planning/ROADMAP.md` exists with phase details
- `.planning/STATE.md` exists

## 1. Load Context

```bash
cat .planning/STATE.md
cat .planning/ROADMAP.md
cat .planning/config.json
cat .planning/phases/XX-name/*-CONTEXT.md 2>/dev/null
cat .planning/phases/XX-name/*-RESEARCH.md 2>/dev/null
cat .planning/LESSONS.md 2>/dev/null
```

Identify the target phase from the argument or STATE.md current position.

**If LESSONS.md exists:** Review lessons from prior phases. Apply relevant warnings to this phase's plans. Note successful patterns to reinforce.

## 2. Extract Phase Requirements

From ROADMAP.md, pull:

- Phase goal
- Phase success criteria
- Mapped requirements (REQ-IDs)

From REQUIREMENTS.md, pull full requirement descriptions for mapped REQ-IDs.

## 3. Check for Context & Research

**If CONTEXT.md exists:** Load and respect decision classification:

- **Decisions = Locked** — honor exactly, do not revisit
- **Claude's Discretion** — make implementation choices freely
- **Deferred Ideas** — ignore, out of scope for this phase

**If CONTEXT.md doesn't exist:** Suggest: "No context gathered yet. Consider running `/discuss-phase` first to capture implementation decisions. Or continue planning directly."

**If RESEARCH.md exists:** Load findings and incorporate into planning.

**If RESEARCH.md doesn't exist and phase involves unfamiliar tech:** Suggest: "Consider running `/research-phase` first. Or continue planning directly."

## 5. Goal-Backward Analysis

**Step 1: State the Goal** — Take phase goal from ROADMAP.md (must be outcome-shaped, not task-shaped)

**Step 2: Derive Observable Truths** — "What must be TRUE for this goal to be achieved?" Derive as many truths as the phase requires (simple phases may have 3, complex phases may have 10+). Cover all user-observable outcomes.

**Step 3: Derive Required Artifacts** — For each truth: "What must EXIST for this to be true?" (specific files)

**Step 4: Derive Required Wiring** — For each artifact: "What must be CONNECTED for this to function?"

**Step 5: Identify Key Links** — "Where is this most likely to break?"

## 6. Create Plans

Each plan = a PLAN.md file in `.planning/phases/XX-name/`.

**Naming:** `{phase}-{plan}-PLAN.md` (e.g., `01-01-PLAN.md`)

**Sizing rules:**

- Group related tasks into coherent plans (typically 2-4 tasks, but use judgement — a 5-task plan is fine if the tasks are tightly coupled)
- Each task: 15-60 min execution time
- Target ~50% context usage per plan
- More plans > bigger plans (quality preservation)

**Plan structure:**

```markdown
---
phase: XX-name
plan: NN
type: execute
depends_on: []
files_modified: []
must_haves:
  truths: []
  artifacts: []
  key_links: []
---

## Objective
[What this plan accomplishes and why]

## Context
[References to existing files, prior plan summaries if needed]

## Tasks

### Task 1: [Action-oriented name]
**Files:** `path/to/file.ext`
**Action:** [Specific implementation instructions — what to do, what to avoid, WHY]
**Verify:** [Command or check to prove task is done]
**Done:** [Acceptance criteria — measurable state]

### Task 2: [Action-oriented name]
**Files:** `path/to/file.ext`
**Action:** [Specific instructions]
**Verify:** [Check]
**Done:** [Criteria]

## Verification
[Overall phase checks after all tasks]

## Success Criteria
[Measurable completion — what must be TRUE]
```

**Prefer vertical slices over horizontal layers:**

Good (parallel-capable):

```
Plan 01: User auth feature (model + API + UI)
Plan 02: Product listing feature (model + API + UI)
```

Bad (forced-sequential):

```
Plan 01: All models
Plan 02: All APIs
Plan 03: All UIs
```

**Task specificity test:** Could a different AI instance execute this without asking clarifying questions? If not, add detail.

**Vague → Specific examples:**

| TOO VAGUE | JUST RIGHT |
|-----------|------------|
| "Add auth" | "JWT auth with httpOnly cookie, 15min access / 7day refresh, using jose library" |
| "Create the API" | "POST /api/projects accepting {name, description}, validates name 3-50 chars, returns 201" |
| "Style the page" | "CSS grid 3-col on lg / 1-col on mobile, glassmorphism cards, hover opacity transitions" |

## 7. Create Test Matrix (MANDATORY)

**Every phase MUST produce a `{phase}-TEST-MATRIX.md` alongside the PLAN files.** This ensures comprehensive test coverage is planned before any code is written.

**File:** `.planning/phases/XX-name/XX-TEST-MATRIX.md`

The test matrix covers **8 test types**. For each type, specify: which plan covers it, what specifically is tested, and whether it's applicable. If N/A, justify why.

```markdown
---
phase: XX-name
total_test_types: 8
covered: [N]
not_applicable: [N]
estimated_tests: [N]
---

# Phase [X]: [Name] — Test Matrix

## 1. Unit Tests
**Covered in:** Plan [N], Task [N]
**What:** Individual functions/classes tested in isolation with mocked dependencies.
**Tests:**
- [ ] [specific test description]

## 2. Integration Tests
**Covered in:** Plan [N], Task [N]
**What:** Components wired together correctly, end-to-end pipeline validated.
**Tests:**
- [ ] [specific test description]

## 3. Regression Tests
**Covered in:** Plan [N], Task [N]
**What:** Existing tests still pass. No breakage to prior phases.
**Tests:**
- [ ] Full test suite passes (`npm test` / `npx vitest run`)
- [ ] [specific prior-phase functionality still works]

## 4. Contract Tests
**Covered in:** Plan [N], Task [N]
**What:** SQL schema ↔ TypeScript types ↔ API shapes are aligned. No drift.
**Tests:**
- [ ] [specific schema alignment test]

## 5. Math / Accuracy Tests
**Covered in:** Plan [N], Task [N]
**What:** Computed values match known-correct answers. Multiple scenarios with pre-computed expected values.
**Tests:**
- [ ] [specific calculation verification]

## 6. Boundary / Stress Tests
**Covered in:** Plan [N], Task [N]
**What:** Edge cases: zero, negative, null, empty, massive inputs, concurrent access.
**Tests:**
- [ ] [specific boundary test]

## 7. Security Tests
**Covered in:** Plan [N], Task [N]
**What:** RLS tenant isolation, auth enforcement, governance token validation, input sanitization, no data leakage.
**Tests:**
- [ ] RLS: query as Tenant A sees zero rows from Tenant B
- [ ] Write operations without governance token → rejected
- [ ] Input sanitization: invalid/malicious values rejected
- [ ] [additional security tests specific to this phase]

## 8. UAT (User Acceptance Testing)
**Covered in:** /verify-work after all plans complete
**What:** Observable truths from user perspective — "does it actually work?"
**Tests:**
- [ ] [specific acceptance criteria]

## N/A Justifications
[If any test type is marked N/A, explain why here]
```

**Rules:**

- All 8 types MUST be addressed (either covered or justified N/A)
- Security tests are **never** N/A for phases that add database tables or API endpoints
- UAT tests are **never** N/A
- Math tests are N/A only for phases with no computation logic

## 8. Self-Check Plans

**Before committing, verify plans against the phase goal:**

Re-read all plans just created and check:

| Check | What to Look For |
|-------|------------------|
| **Coverage** | Do the plans cover ALL phase success criteria? |
| **Specificity** | Could a different AI execute each task without clarifying questions? |
| **No stubs** | Are all tasks real implementation, not "TODO" or "implement later"? |
| **Scope match** | Do tasks stay within phase boundary? No scope creep? |
| **Key links** | Are the "most likely to break" points addressed? |
| **Test coverage** | Does TEST-MATRIX.md cover all 8 test types? Are any marked N/A without justification? |
| **Security** | Are RLS, auth, and input validation tests defined for every new table/endpoint? |

**If issues found:** Fix them before committing. Revise until clean — don't stop at a fixed number of passes.

**If clean:** Continue to commit.

## 9. Commit Plans

```bash
mkdir -p .planning/phases/XX-name
git add .planning/phases/XX-name/*.md
git commit -m "docs(phase-XX): create execution plans + test matrix"
```

## 10. Present Summary

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 PHASE [N] PLANNED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Plans created: [N]
Total tasks: [N]
Dependencies: [graph summary]

| Plan | Tasks | Key Output |
|------|-------|------------|
| 01   | 3     | [description] |
| 02   | 2     | [description] |

Test Matrix: 8/8 test types covered
Estimated tests: [N]

## ▶ Next
Run /analyze-gaps to check plans against context, research, and project.
Then /execute-phase to execute Phase [N].
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
