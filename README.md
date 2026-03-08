# Axiom

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Workflows](https://img.shields.io/badge/Workflows-19-green.svg)](workflows/)
[![eComX](https://img.shields.io/badge/Built%20by-eComX-black.svg)](https://ecom-x.com)

> 19 deterministic AI development workflows — plan, build, verify, and deploy complex software with zero drift.

Built by [eComX](https://ecom-x.com) — the Context-First AI development methodology for serious operators.

---

## What This Is

Axiom is a complete workflow suite for agentic software development. 19 markdown workflow files, each a precise, step-by-step process your AI agent follows as a slash command.

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
└───────────────────────┬─────────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                  DEPLOYMENT & MAINTENANCE                   │
│                                                             │
│   /deploy ──→ /retrospective                                │
│      │                                                      │
│   FAIL? ──→ Rollback ──→ /diagnose-issues                   │
│                                                             │
│   /dependency-audit    Periodic security & license check    │
│   /scope-change        Mid-project scope management         │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   SESSION MANAGEMENT                        │
│                                                             │
│   /context     Load project context at session start        │
│   /progress    Check current status + risk analysis         │
│   /quick       Fast execution for small tasks               │
│   /pause-work  Save state for session handoff               │
│   /resume-project  Restore full context                     │
│   /clear       Save state + fresh context window            │
└─────────────────────────────────────────────────────────────┘
```

---

## The 19 Workflows

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
| Diagnose Issues | `/diagnose-issues` | Root cause analysis with taxonomy and ruled-out tracking |

### Deployment & Maintenance

| Workflow | Command | Purpose |
|----------|---------|---------|
| Deploy | `/deploy` | Pre-deploy checklist, smoke test, rollback protocol |
| Retrospective | `/retrospective` | End-of-milestone reflection with velocity analysis |
| Scope Change | `/scope-change` | Formal mid-project scope change with impact analysis |
| Dependency Audit | `/dependency-audit` | Security vulns, outdated packages, license compliance |

### Session Management

| Workflow | Command | Purpose |
|----------|---------|---------|
| Context | `/context` | Auto-discover project environment at session start |
| Progress | `/progress` | Status + risk analysis, velocity trends, test debt |
| Quick | `/quick` | Fast task execution with risk gate |
| Pause Work | `/pause-work` | Granular handoff file for mid-task session pause |
| Resume Project | `/resume-project` | Restore full context across sessions |
| Clear | `/clear` | Save state and prepare for fresh context window |

---

## Install

**One-liner** (recommended):

```bash
curl -fsSL https://raw.githubusercontent.com/ecomxco/axiom/main/install.sh | bash
```

This installs all 19 workflows into `.agent/workflows/` in the current directory.

**Options:**

```bash
# Install into a specific project
curl -fsSL https://raw.githubusercontent.com/ecomxco/axiom/main/install.sh | bash -s -- --dir ~/projects/my-app

# Install a specific version
curl -fsSL https://raw.githubusercontent.com/ecomxco/axiom/main/install.sh | bash -s -- --version v1.0.0

# Use Cursor's directory convention
curl -fsSL https://raw.githubusercontent.com/ecomxco/axiom/main/install.sh | bash -s -- --agent-dir .cursor/rules
```

**Manual install:**

```bash
git clone https://github.com/ecomxco/axiom.git
cp -r axiom/workflows/ /path/to/your-project/.agent/workflows/
```

### Update

```bash
curl -fsSL https://raw.githubusercontent.com/ecomxco/axiom/main/update.sh | bash
```

Updates all workflows while preserving your customized `context.md`.

### Start Using

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
