---
name: delegate
description: "Use before giving Claude a broad autonomous task or agentic workflow. Produces a Decision Authority Map and Constraint Architecture that encodes your judgment upfront — preventing technically-correct-but-wrong output (the Klarna Pattern). Drop the output into CLAUDE.md for per-project use."
---

# Delegate

The Klarna Pattern: AI produces output that technically answers the prompt but misses what you actually wanted. It's the #1 failure mode of autonomous AI workflows, and it's almost never the AI's fault — it's missing judgment that was never encoded.

This skill extracts that judgment before the task starts. It produces two things:
1. A **Decision Authority Map** — what Claude decides alone vs. notifies vs. escalates
2. A **Constraint Architecture** — Must Do / Must Not Do / Prefer / Escalate, each tied to a specific failure mode it prevents

Run this before any broad autonomous task, background agent, or multi-step workflow. Paste the output into the task prompt or CLAUDE.md.

## When to Trigger

- User says "do this without asking me," "run autonomously," "handle this end to end"
- Before spawning background agents or multi-step agentic workflows
- When a task has broad scope where wrong decisions would be hard to reverse
- Before dropping a CLAUDE.md into a new project
- When a user has been frustrated by AI going off-script on previous tasks

## The Interview

Ask the user these questions. Take their answers and build the two artifacts below.

### Decision Authority Questions

1. **What should Claude just do?** What decisions are completely safe to make alone — no need to check in?
2. **What should Claude do but tell you about?** Actions that are fine but you want visibility into?
3. **What must Claude ask before doing?** The hard stops — actions where guessing wrong is costly or irreversible?
4. **What's the blast radius if Claude gets it wrong?** Helps calibrate which tier things fall into.

### Constraint Architecture Questions

Work through these four failure mode prompts:

1. "Describe a time AI did exactly what you asked but not what you wanted." → Produces **Must Not Do** constraints
2. "What would make this output useless even if it's technically correct?" → Produces **Prefer** constraints
3. "What are the non-negotiables — things that can never be wrong?" → Produces **Must Do** constraints
4. "What situations should always require a human decision?" → Produces **Escalate** constraints

## Output Format

### Decision Authority Map

```
## Decision Authority Map

### Decide Autonomously
[List of decisions Claude can make without checking in]
- e.g., File naming and organization
- e.g., Which existing utility to use for a known problem

### Decide with Notification
[Decisions Claude makes but flags in output]
- e.g., "Added X dependency — flagging in case you want a different approach"
- e.g., "Chose pattern Y over Z because [reason] — let me know if you'd prefer otherwise"

### Escalate Before Acting
[Hard stops — must confirm before proceeding]
- e.g., Any change to authentication or permissions
- e.g., Deleting or renaming existing files
- e.g., External API calls that cost money or send data
- e.g., Any database schema change
```

### Constraint Architecture

```
## Constraint Architecture

### Must Do
[Non-negotiables — always true regardless of context]
- [Constraint] — prevents [specific failure mode]

### Must Not Do
[Things that make output wrong even if technically correct]
- [Constraint] — prevents [specific failure mode]

### Prefer
[Defaults that can be overridden with good reason]
- [Constraint] — avoids [specific failure mode]

### Escalate
[Situations requiring human judgment, not AI judgment]
- [Situation] — because [why this isn't a safe autonomous decision]
```

## Delivery

Present both artifacts. Ask: "Anything missing, or does this capture how you want Claude to operate on this task?"

If the user wants to persist this for a project, suggest adding it to CLAUDE.md under a `## Delegation Rules` section.

## What Not to Do

- Don't make the constraint list exhaustive — 3-6 items per category is the right size
- Don't put the same constraint in multiple categories
- Don't leave failure modes vague — each constraint must name the specific bad outcome it prevents
- Don't build this for trivial tasks (single file bug fix, one-line change) — the overhead isn't worth it
