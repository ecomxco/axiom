# Axiom

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Workflows](https://img.shields.io/badge/Workflows-15-green.svg)](workflows/)
[![eComX](https://img.shields.io/badge/Built%20by-eComX-black.svg)](https://ecom-x.com)

> 15 deterministic AI development workflows — plan, build, and verify complex software with zero drift.

Built by [eComX](https://ecom-x.com) — the Context-First AI development methodology for serious operators.

---

## What This Is

Axiom is a complete workflow suite for agentic software development. 15 markdown workflow files, each a precise, step-by-step process your AI agent follows as a slash command.

Unlike generic prompting, Axiom workflows are **deterministic** — they produce consistent, auditable results every time. Each workflow has a defined input, a defined output, and clear deviation handling.

**Philosophy:** AI agents perform at their ceiling when given structured process, not vague instructions. Axiom is the process layer.

---

## How Workflows Connect

```
┌─────────────────────────────────────────────────────────────┐
│                    PROJECT INITIALIZATION                   │
│                                                             │
│   /map-codebase ──→ /plan-project                           │
│   (brownfield)      (greenfield)                            │
└───────────────────────┬─────────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                     PHASE EXECUTION                         │
│                                                             │
│   /discuss-phase ──→ /research-phase ──→ /plan-phase        │
│        │                                      │             │
│        │              ┌───────────────────────┘             │
│        │              ▼                                     │
│        │         /analyze-gaps ──→ /execute-phase           │
│        │                               │                    │
│        │              ┌────────────────┘                    │
│        │              ▼                                     │
│        │         /verify-work                               │
│        │              │                                     │
│        │         ┌────┴────┐                                │
│        │      PASS?     FAIL?                               │
│        │         │         │                                │
│        │    Next Phase   /diagnose-issues ──→ /plan-phase   │
│        │         │                           (--gaps)       │
│        └─────────┘                                          │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   SESSION MANAGEMENT                        │
│                                                             │
│   /context     Load project context at session start        │
│   /progress    Check current status                         │
│   /quick       Fast execution for small tasks               │
│   /pause-work  Save state for session handoff               │
│   /resume-project  Restore full context                     │
│   /clear       Save state + fresh context window            │
└─────────────────────────────────────────────────────────────┘
```

---

## The 15 Workflows

### Project Initialization

| Workflow | Command | Purpose |
|----------|---------|---------|
| Map Codebase | `/map-codebase` | Analyze a brownfield codebase into structured reference docs |
| Plan Project | `/plan-project` | Initialize a new project with deep requirements and roadmap |

### Phase Execution

| Workflow | Command | Purpose |
|----------|---------|---------|
| Discuss Phase | `/discuss-phase` | Extract decisions before planning — identify gray areas |
| Research Phase | `/research-phase` | Research tech, patterns, and gotchas before building |
| Plan Phase | `/plan-phase` | Break a phase into atomic executable plans |
| Analyze Gaps | `/analyze-gaps` | Find gaps in plans before execution |
| Execute Phase | `/execute-phase` | Execute plans sequentially with deviation handling |
| Verify Work | `/verify-work` | Goal-backward verification with UAT tracking |
| Diagnose Issues | `/diagnose-issues` | Root cause analysis before planning fixes |

### Session Management

| Workflow | Command | Purpose |
|----------|---------|---------|
| Context | `/context` | Load full project context at session start |
| Progress | `/progress` | Current status — what's done, what's next |
| Quick | `/quick` | Fast task execution for small, well-understood tasks |
| Pause Work | `/pause-work` | Handoff file for seamless session resumption |
| Resume Project | `/resume-project` | Restore full context across sessions |
| Clear | `/clear` | Save state and prepare for fresh context window |

---

## Quick Start

```bash
git clone https://github.com/ecomxco/axiom.git
cd axiom
```

Copy the `workflows/` directory into your project:

```bash
cp -r workflows/ /path/to/your-project/.agent/workflows/
```

Then in your agent:

```
/context          # Load project context
/plan-phase Phase 3: Checkout Flow
/execute-phase
/verify-work
```

---

## Key Features

| Feature | Description |
|---------|-------------|
| **4-rule deviation system** | Auto-fix bugs, missing validation, blocking deps. STOP for architectural changes. |
| **8-type test matrix** | Unit, integration, regression, contract, math, boundary, security, UAT |
| **Goal-backward verification** | Tests user-observable truths, not implementation details |
| **9-check gap analysis** | Catches what planning missed before execution begins |
| **Scientific debugging** | Hypothesis → evidence → root cause methodology |
| **Session persistence** | UAT state survives across session clears |

---

## Agent Compatibility

| Agent | Setup |
|-------|-------|
| Antigravity | Place in `.agent/workflows/` — auto-detected |
| Claude (Projects) | Upload as project files |
| Cursor | Place in `.cursor/rules/` or `.agents/workflows/` |
| ChatGPT | Paste workflow content at session start |
| Gemini | Upload as files at session start |

---

## Used With

Axiom works across the full eComX tooling stack:

```
/setup-environment → /setup-cli → /setup-data-warehouse → /setup-bios → /emerge-agent → Axiom
```

---

## Support

- 💬 Questions: [ecom-x.com/call](https://ecom-x.com/call)
- 🐛 Issues: [GitHub Issues](https://github.com/ecomxco/axiom/issues)

---

## License

MIT — © 2026 eCom XP LLC
