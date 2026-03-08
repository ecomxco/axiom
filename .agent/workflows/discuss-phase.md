---
description: Extract implementation decisions before planning — identify gray areas, capture locked decisions, and create CONTEXT.md for downstream workflows
---

# Discuss Phase

Captures user decisions that feed into research and planning phases.

**Philosophy:** You are a thinking partner, not an interviewer. The user is the visionary — you are the builder. Capture decisions that will guide research and planning, not figure out implementation yourself.

## When to Use

- Before `/plan-phase` when the phase has ambiguous decisions (UI layout? behavior? library choice?)
- When the user wants to clarify their vision before committing to a plan
- Recommended by `/progress` when no CONTEXT.md exists for the current phase

## Prerequisites

- `.planning/ROADMAP.md` exists with phase details

## 1. Validate Phase

```bash
cat .planning/ROADMAP.md
```

Identify the target phase from the argument. If phase not found → error with available phases.

Check if CONTEXT.md already exists:

```bash
ls .planning/phases/XX-name/*-CONTEXT.md 2>/dev/null
```

If exists → Ask: "Phase [X] already has context. Update it, view it, or skip?"

## 2. Analyze Phase for Gray Areas

Read the phase goal from ROADMAP.md and determine:

1. **Domain boundary** — What capability is this phase delivering?
2. **Gray areas** — What decisions would change the outcome that the user should weigh in on?

**Gray areas are implementation choices the user cares about:**

Generate phase-specific gray areas, NOT generic categories. Examples:

| Phase | Gray Areas |
|-------|------------|
| "User authentication" | Session handling, Error responses, Multi-device policy, Recovery flow |
| "Organize photo library" | Grouping criteria, Duplicate handling, Naming convention, Folder structure |
| "CLI for database backups" | Output format, Flag design, Progress reporting, Error recovery |
| "API documentation" | Structure/navigation, Code examples depth, Versioning approach |

**Claude handles these (don't ask):**

- Technical implementation details, architecture patterns, performance optimization, scope

## 3. Present Gray Areas

State the domain boundary first:

```
Phase [X]: [Name]
Domain: [What this phase delivers]

We'll clarify HOW to implement this.
(New capabilities belong in other phases.)
```

Then present 3-5 phase-specific gray areas for the user to select which ones to discuss.

## 4. Discuss Selected Areas

For each selected area, conduct a focused discussion:

- **4 questions per area, then check:** Ask 4 questions → offer "More questions?" or "Next area?"
- **Concrete options, not abstract:** "Cards" not "Option A"
- **Include "You decide" as an option** when reasonable — captures Claude's discretion areas

**Scope creep handling:**
If user mentions something outside the phase domain:

```
"[Feature] sounds like a new capability — that belongs in its own phase.
I'll note it as a deferred idea.

Back to [current area]: [return to current question]"
```

Track deferred ideas internally.

## 5. Write CONTEXT.md

Create `.planning/phases/XX-name/XX-CONTEXT.md`:

```markdown
# Phase [X]: [Name] - Context

**Gathered:** [date]
**Status:** Ready for planning

## Phase Boundary

[Clear statement of what this phase delivers — the scope anchor]

## Implementation Decisions

### [Category 1 discussed]
- [Decision or preference captured]

### [Category 2 discussed]
- [Decision or preference captured]

### Claude's Discretion
[Areas where user said "you decide" — Claude has flexibility here]

## Specific Ideas

[References, examples, "I want it like X" moments from discussion]

## Deferred Ideas

[Ideas that came up but belong in other phases. Don't lose them.]

---
*Phase: XX-name*
*Context gathered: [date]*
```

// turbo

```bash
mkdir -p .planning/phases/XX-name
```

Commit:

```bash
git add .planning/phases/XX-name/XX-CONTEXT.md
git commit -m "docs(phase-XX): capture phase context"
```

## 6. Next Steps

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 CONTEXT CAPTURED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Decisions captured: [N]
Deferred ideas: [N]

## ▶ Next
Run /plan-phase to plan Phase [N]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Decision Classification (Downstream Awareness)

CONTEXT.md feeds into:

1. **Research** — Reads CONTEXT.md to know WHAT to research
   - "User wants card-based layout" → researcher investigates card component patterns
2. **Planner** — Reads CONTEXT.md to know WHAT decisions are locked
   - Decisions = **Locked** — honor exactly, do not revisit
   - Claude's Discretion = **Freedom** — make implementation choices
   - Deferred Ideas = **Out of scope** — do NOT include
