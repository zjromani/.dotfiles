---
name: spec-writer
description: "Turns vague intent into agent-grade specifications. Reach for this when plan-gate blocks you — or proactively for large, high-stakes work where you already know the idea is fuzzy. Draws on the GitHub Spec Kit, Addy Osmani's spec-writing framework, and Nate B. Jones's Level 4-5 behavioral contract patterns."
---

# Spec Writer

Turns vague intent into agent-grade specifications. Most of the time, you hit plan-gate first — it's the entry point for any planning session. Spec-writer is what you reach for when the gate tells you the idea needs more work, or proactively when you already know the idea is large and fuzzy enough that jumping to plan mode would be premature. The bottleneck in AI-assisted development has shifted from implementation speed to specification quality. Ambiguous specs produce ambiguous software. AI agents don't ask clarifying questions — they make assumptions. This skill closes that gap.

## Core Principle

A good spec describes **what the system does from the outside** — observable behaviors, not implementation details. The agent chooses the implementation. You define the behavior.

Think of it as a contract: if the system behaves exactly as the spec describes under all conditions including failures, the job is done.

## The Four-Phase Workflow (GitHub Spec Kit Pattern)

Always move through these phases in order. Don't skip to Tasks or Implementation until the earlier phases are solid.

### Phase 1 — Specify (user experience first)
Start with who uses this, what they need, and what success looks like. No tech stack yet.

Questions to answer:
- Who is this for?
- What problem does it solve?
- What does the user do, see, and get?
- What would failure look like from the user's perspective?

Output: A clear behavioral description in plain language.

### Phase 2 — Plan (technical second)
Now bring in tech constraints, existing systems, and architecture decisions.

Questions to answer:
- What's the tech stack and any mandatory constraints?
- What existing systems does this touch?
- Are there compliance, security, or performance requirements?
- What's the integration contract with external dependencies?

Output: Technical approach and architecture notes added to the spec.

### Phase 3 — Tasks
Break the plan into small, independently verifiable units of work. Each task should be:
- Specific enough to implement and test in isolation
- Expressed as an outcome, not an activity ("user registration endpoint validates email format" not "write validation code")
- Ordered by dependency (foundations before features)

Output: Ordered task list in `tasks.md` or equivalent.

### Phase 4 — Implement
Agent executes tasks one by one. Your job is to verify at each checkpoint, not review every line.

## The Six Required Sections

Every spec Claude produces must cover all six. Based on GitHub's analysis of 2,500+ agent config files, these are what the best ones have in common.

### 1. System Overview
Two to three sentences: what this is, who it serves, why it exists. No implementation details.

### 2. Behavioral Contract
Observable behaviors written as "When [condition], the system [behavior]." Cover:
- Primary flows (happy path)
- Error flows (what happens when things break)
- Boundary conditions (edge cases, limits, unusual inputs)

Not: "The system uses a retry queue." Yes: "When the upstream API returns a 503, the system retries up to 3 times with exponential backoff before returning an error to the caller."

### 3. Explicit Non-Behaviors
What the system must NOT do. This prevents agents from "helpfully" adding scope.

Format: "The system must not [behavior] because [reason]."

Examples:
- "The system must not store raw credit card numbers — PCI compliance requires tokenization only."
- "The system must not send emails directly — it publishes to the notification queue and lets the notification service handle delivery."

### 4. Integration Boundaries
Every external system this touches:
- What data flows in and out
- Expected request/response contract
- What happens when the external system is unavailable
- Whether the agent should use a real service or a mock/twin during development

### 5. Behavioral Scenarios
These replace traditional test cases. Written from an external perspective — what you observe, not how it's implemented. The agent should never see these during development; they're for evaluation after.

Each scenario includes:
- Setup conditions
- Actions taken
- Observable expected outcomes

Minimum set: 3 happy-path, 2 error, 2 edge-case.

### 6. Boundaries and Constraints
What the agent should never touch (secrets, vendor dirs, production configs), stack constraints, version requirements. Keep this minimal — over-constraining defeats the purpose.

## Ambiguity Warnings

After producing a spec, always self-review for places where an agent would need to make an assumption. For each:
- What's ambiguous
- What assumption the agent would likely make
- What question resolves it

Don't fill in ambiguities yourself. Flag them and ask the user.

## Format

Produce specs in Markdown, ready to be saved as `SPEC.md` and handed to an agent. Use headers, not prose paragraphs, for the six required sections.

Use this structure:
```
# Spec: [Feature Name]

## System Overview
...

## Behavioral Contract
### Primary Flows
- When [condition], the system [behavior]

### Error Flows
- When [condition], the system [behavior]

### Boundary Conditions
- When [condition], the system [behavior]

## Explicit Non-Behaviors
- The system must not [X] because [Y]

## Integration Boundaries
| System | Data In | Data Out | Unavailability Behavior | Use Real? |
|--------|---------|----------|------------------------|-----------|

## Behavioral Scenarios
### Happy Path
**Scenario 1: [Name]**
Setup: ...
Action: ...
Expected outcome: ...

### Error Cases
...

### Edge Cases
...

## Constraints
- Stack: ...
- Never touch: ...
- Versions: ...

## Ambiguity Warnings
- [ ] [What's ambiguous] — likely assumption: [X] — resolving question: [Y]
```

## When Invoked from Plan Gate

If the user's prompt failed the plan-gate quality check and they want help writing a better spec rather than just answering questions, activate this skill to produce a structured spec collaboratively. Start with Phase 1 (Specify) and work through the phases.

## Quick Quality Check

Before handing a spec to an agent, verify:
- [ ] A non-technical person could understand what this does
- [ ] Every external system is named with its contract described
- [ ] At least two failure scenarios are explicitly handled
- [ ] Scope is bounded — what's out of scope is stated
- [ ] Behavioral scenarios could be evaluated by a human without reading the code
- [ ] No ambiguity that would force the agent to make a major assumption silently

