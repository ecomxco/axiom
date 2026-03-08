---
description: Research how to implement a specific phase — investigate tech, patterns, and gotchas before planning
---

# Research Phase

Standalone research workflow for phase-specific investigation.

**Note:** `/plan-phase` can trigger research automatically. Use this standalone workflow when you want to research without committing to planning, or to re-research a phase with new context.

## When to Use

- Phase involves unfamiliar technology or integrations
- You want to investigate before committing to a plan
- CONTEXT.md exists with decisions that need research backing
- Re-researching after discovering new constraints

## Prerequisites

- `.planning/ROADMAP.md` exists with phase details
- Phase goal and requirements are defined

## 1. Validate Phase

```bash
cat .planning/ROADMAP.md
cat .planning/REQUIREMENTS.md
```

Identify the target phase. Extract:

- Phase goal
- Phase success criteria
- Mapped requirements (REQ-IDs)

## 2. Check Existing Research

```bash
ls .planning/phases/XX-name/*-RESEARCH.md 2>/dev/null
```

If exists → Ask: "Research already exists for this phase. Update it, view it, or skip?"

## 3. Load Context

```bash
cat .planning/phases/XX-name/*-CONTEXT.md 2>/dev/null
cat .planning/STATE.md
```

**If CONTEXT.md exists, respect the decision classification:**

- **Decisions = Locked** — research THESE deeply, no alternatives
- **Claude's Discretion** — research options, recommend best approach
- **Deferred Ideas** — ignore, out of scope

## 4. Research

Focus on answering: **"What do I need to know to PLAN this phase well?"**

Research dimensions based on phase type:

| Phase Type | Research Focus |
|-----------|---------------|
| New tech integration | How does it work? API patterns? Auth? Rate limits? |
| UI/UX feature | Component patterns? Accessibility? Responsive approaches? |
| Data/schema work | Migration strategies? Data integrity? Rollback plans? |
| API design | RESTful patterns? Error codes? Versioning? |
| Infrastructure | Deployment patterns? Monitoring? Scaling considerations? |

**Use real tools:**

- `search_web` for current documentation and patterns
- `read_url_content` for official docs, blog posts, tutorials
- Don't rely on training data for versions, APIs, or current best practices

**For each research finding, note:**

- Source (URL or doc reference)
- Confidence level (high/medium/low)
- Relevance to this specific phase
- Gotchas or common mistakes

## 5. Write RESEARCH.md

Create `.planning/phases/XX-name/XX-RESEARCH.md`:

```markdown
# Phase [X]: [Name] - Research

**Researched:** [date]
**Focus:** [what was investigated]

## Key Findings

### [Topic 1]
**Finding:** [what was discovered]
**Source:** [URL or reference]
**Confidence:** [high/medium/low]
**Implication for planning:** [how this affects the plan]

### [Topic 2]
**Finding:** [what was discovered]
**Source:** [URL or reference]
**Confidence:** [high/medium/low]
**Implication for planning:** [how this affects the plan]

## Recommended Approach

[Based on research, what approach should the planner take?]

## Gotchas & Pitfalls

- **[Gotcha 1]:** [description] — **Prevention:** [how to avoid]
- **[Gotcha 2]:** [description] — **Prevention:** [how to avoid]

## Dependencies & Prerequisites

- [Library/tool] version [X] — [why this version]
- [Service/API] — [access requirements]

## Open Questions

- [Question that research couldn't fully answer]
- [Area that needs user input or further investigation]

---
*Phase: XX-name*
*Research completed: [date]*
```

// turbo

```bash
mkdir -p .planning/phases/XX-name
```

Commit:

```bash
git add .planning/phases/XX-name/XX-RESEARCH.md
git commit -m "docs(phase-XX): phase research"
```

## 6. Present & Route

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 RESEARCH COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Key findings: [N]
Gotchas identified: [N]
Open questions: [N]

## ▶ Next
Run /plan-phase to plan Phase [N]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
