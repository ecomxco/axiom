# CLAUDE.md — Project Instructions

## Project: Axiom — eComX Workflows

**Author:** Jim Moore (<jim@ecomx.co>)
**Primary Agent:** Claude / Antigravity
**Created:** 2026-03-08

---

## Purpose

15 deterministic Axiom development workflows for planning, executing, and verifying complex software builds with AI agents. Zero drift. Auditable results.

---

## The 15 Workflows

### Project Init

- `/map-codebase` — brownfield analysis
- `/plan-project` — new project initialization

### Phase Loop

- `/discuss-phase` → `/research-phase` → `/plan-phase` → `/analyze-gaps` → `/execute-phase` → `/verify-work` → `/diagnose-issues`

### Session Management

- `/context`, `/progress`, `/quick`, `/pause-work`, `/resume-project`, `/clear`

---

## Key Rules

- **Always start with `/context`** to load project state.
- **Never skip `/analyze-gaps`** before execution on complex phases.
- **`/verify-work` is goal-backward** — verify against stated goals, not against implementation.
- **`/pause-work` before closing any session** that has active threads.

---

## File Structure

```
axiom/
├── workflows/
│   ├── analyze-gaps.md
│   ├── clear.md
│   ├── context.md
│   ├── diagnose-issues.md
│   ├── discuss-phase.md
│   ├── execute-phase.md
│   ├── map-codebase.md
│   ├── pause-work.md
│   ├── plan-phase.md
│   ├── plan-project.md
│   ├── progress.md
│   ├── quick.md
│   ├── research-phase.md
│   ├── resume-project.md
│   └── verify-work.md
├── README.md
├── LICENSE
└── .gitignore
```
