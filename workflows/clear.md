---
description: Save state and prepare for a fresh context window
---

# Clear Context

Saves current work state and prepares for a fresh context window. Ensures session continuity by persisting progress to disk before clearing.

## When to Use

- Context is growing large after extended execution
- Between workflow steps that benefit from fresh context (e.g., between `/plan-phase` and `/execute-phase`)
- When suggested by other workflows ("Consider running `/clear` first")

## Process

### 1. Save Current State

Before clearing, ensure all state is persisted:

```bash
# Check for uncommitted changes
git status --short

# Verify STATE.md is current
cat .planning/STATE.md | head -20
```

If uncommitted work exists → commit or create `.continue-here.md` (see `/pause-work`).

### 2. State Summary

Present a compact state summary the user can paste into the new session:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 READY TO CLEAR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

State saved. To continue in a fresh session:

1. Start a new conversation
2. Run: /resume-project
   — or if you know the next step:
   /execute-phase [N]
   /plan-phase [N]
   /verify-work [N]

Current position:
  Phase [X], Plan [Y], Status: [status]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 3. Context Loading in New Session

The new session should start by loading context via `/context` workflow, then
run `/resume-project` which will:

- Read STATE.md for current position
- Find any incomplete work
- Route to the appropriate next action

## Why This Matters

Each Antigravity session has a finite context window. Long executions accumulate
file contents, tool outputs, and conversation history. A fresh session starts
with maximum available context for the next workflow step.

**Rule of thumb:** Clear between major workflow boundaries:

- After `/plan-phase` → before `/execute-phase`
- After completing a plan → before the next plan (if context is heavy)
- After `/verify-work` → before fix execution
