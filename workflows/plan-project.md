---
description: Initialize a new project with deep questioning, research, requirements, and roadmap
---

# Plan Project

Initialize a new project through deep questioning, research, and structured planning. Runs sequentially to preserve context quality.

## 1. Pre-Flight Checks

Before ANY user interaction:

```bash
# Check if .planning/ already exists
ls .planning/PROJECT.md 2>/dev/null && echo "PROJECT EXISTS" || echo "NEW PROJECT"

# Check if existing code exists (brownfield detection)
find . -maxdepth 2 -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.md" | head -20

# Check git
git status 2>/dev/null && echo "GIT_OK" || echo "NO_GIT"
```

If `.planning/PROJECT.md` exists → Error: "Project already initialized. Read STATE.md for current status."

If no git → `git init`

If existing code detected → Ask: "Map codebase first (`/map-codebase`), or skip?"

## 2. Deep Questioning

**Philosophy:** This is dream extraction, not requirements gathering. You're a thinking partner.

**Open:** Ask "What do you want to build?" — wait for their response.

**Follow the thread:** Based on what they said, ask follow-up questions that dig into specifics:

- What excited them
- What problem sparked this
- What they mean by vague terms
- What it would actually look like
- What's already decided

**Challenge vagueness:** Never accept fuzzy answers. "Good" means what? "Users" means who?

**Make abstract concrete:** "Walk me through using this." "What does that look like?"

**Background checklist** (check mentally, don't ask as a list):

- [ ] What they're building (concrete enough to explain to a stranger)
- [ ] Why it needs to exist (the problem or desire driving it)
- [ ] Who it's for (even if just themselves)
- [ ] What "done" looks like (observable outcomes)

**Decision gate:** When you could write a clear PROJECT.md → Ask "I think I understand what you're after. Ready to create PROJECT.md, or keep exploring?"

## 3. Write PROJECT.md

Create `.planning/PROJECT.md`:

```markdown
# [Project Name]

## What This Is
[2-3 sentences. What does this product do and who is it for?]

## Core Value
[The ONE thing that matters most. If everything else fails, this must work.]

## Requirements

### Validated
(None yet — ship to validate)

### Active
- [ ] [Requirement 1]
- [ ] [Requirement 2]

### Out of Scope
- [Exclusion 1] — [why]

## Context
[Background: technical environment, prior work, known issues]

## Constraints
- **[Type]**: [What] — [Why]

## Key Decisions
| Decision | Rationale | Outcome |
|----------|-----------|---------|
| [Choice from questioning] | [Why] | — Pending |

---
*Last updated: [date] after initialization*
```

For **brownfield projects**: Infer Validated requirements from existing code.

// turbo

```bash
mkdir -p .planning
```

Commit:

```bash
git add .planning/PROJECT.md && git commit -m "docs: initialize project"
```

## 4. Config

Ask the user about preferences:

**Depth:** Quick (~3-5 phases) / Standard (~5-8 phases) / Comprehensive (~8-12+ phases). These are guidelines, not caps — let the project's actual complexity determine the phase count.

Create `.planning/config.json`:

```json
{
  "depth": "standard",
  "created": "[date]"
}
```

## 5. Research Decision

Ask: "Research the domain ecosystem before defining requirements? (Recommended for unfamiliar domains, skip if you know it well)"

**If research:**

Create `.planning/research/` directory and research 4 dimensions sequentially:

1. **Stack** → Write `.planning/research/STACK.md` (techs, versions, rationale)
2. **Features** → Write `.planning/research/FEATURES.md` (table stakes vs differentiators)
3. **Architecture** → Write `.planning/research/ARCHITECTURE.md` (components, data flow, build order)
4. **Pitfalls** → Write `.planning/research/PITFALLS.md` (common mistakes, prevention)
5. **Summary** → Write `.planning/research/SUMMARY.md` (consolidated findings)

Use `search_web` and `read_url_content` for current information. Don't rely on training data for versions.

**If skip:** Continue to step 6.

## 6. Define Requirements

Load PROJECT.md context. If research exists, load FEATURES.md.

**If research exists:** Present features by category, let user select v1 scope via multi-select.

**If no research:** Ask "What are the main things users need to be able to do?" and gather through conversation.

For each requirement:

- Make it specific and testable: "User can X" not "Handle X"
- Atomic: One capability per requirement
- REQ-ID format: `[CATEGORY]-[NUMBER]` (AUTH-01, CONTENT-02)

Present full requirements list for user confirmation.

Write `.planning/REQUIREMENTS.md` and commit.

## 7. Create Roadmap

Create `.planning/ROADMAP.md`:

For each phase:

1. Derive phases from requirements (don't impose structure)
2. Map every v1 requirement to exactly one phase
3. Derive 2-5 success criteria per phase (observable user behaviors)
4. Validate 100% coverage

Present roadmap table to user. Wait for "Approve" or "Adjust."

After approval, create `.planning/STATE.md` from state template.

Commit all planning docs:

```bash
git add .planning/ROADMAP.md .planning/STATE.md .planning/REQUIREMENTS.md
git commit -m "docs: create roadmap and initialize state"
```

## 8. Complete

Display:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 PROJECT INITIALIZED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Summary
- Project: [name]
- Phases: [N]
- Requirements: [N] v1 / [N] deferred
- Research: [Yes/No]

## ▶ Next
Run /discuss-phase 1 to capture implementation decisions
Then /plan-phase 1 to create execution plans
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
