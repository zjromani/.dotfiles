---
name: plan-gate
description: "Quality gate for plan mode. Fires whenever the user enters plan mode or asks Claude to plan something. Evaluates the spec across 5 dimensions + a taste check. If it passes, proceed. If it doesn't, build a better spec inline — no separate skill needed. Prevents the most common AI dev failure: jumping into implementation before the spec is solid enough to guide it."
---

# Plan Gate

The entry point for every planning session. When the user enters plan mode or asks Claude to plan something, this fires first — before any exploration or design work begins. It makes a single binary call: is the spec solid enough to produce a useful plan, or isn't it? If it isn't, this skill builds a better spec inline — no separate invocation, no redirecting the user elsewhere. The goal is to catch underspecified prompts before they produce wrong output, which is always more expensive to fix than spending 5 minutes sharpening the spec upfront.

The METR study found experienced developers were 19% *slower* with AI tools while believing they were 20% faster. The gap is almost always poor specifications producing rework. This gate exists to close that gap.

## When to Trigger

Activate this skill when:
- User explicitly enters plan mode
- User asks Claude to "plan," "design," "architect," or "spec out" a feature or system
- User uses phrasing like "let's build," "I want to create," "help me design," "write me a..."
- A request involves more than a single file change or a bug fix
- Any agentic task where Claude would take multiple steps autonomously

Do NOT trigger for:
- Simple factual questions
- Single-line bug fixes or very small, well-defined changes
- Explicitly conversational requests
- Requests where the user has already provided a full spec or detailed context

## Step 1: Evaluate

Score the incoming prompt/spec across five dimensions. Each is pass/fail with partial credit.

### 1. Intent Clarity (required)
Can you state in one sentence what this system/feature does and who it's for?

- ✅ Pass: "This is a background job that sends a daily digest email to managers summarizing open support tickets assigned to their team, grouped by priority."
- ⚠️ Partial: "A job that helps with tickets"
- ❌ Fail: "Make it better" / "The usual thing we talked about" / no clear user or outcome stated

### 2. Behavioral Contract (required)
Are the expected inputs, outputs, and system behaviors described — especially for failure cases?

- ✅ Pass: Happy path AND at least one error case described. What happens when the external API is down? What does the user see?
- ⚠️ Partial: Happy path only, no error handling described
- ❌ Fail: No specific behaviors described at all; only a vague goal

### 3. Explicit Boundaries (important)
Is it clear what this should NOT do? Has scope been constrained?

- ✅ Pass: "This only handles order creation, not fulfillment or returns" / "Don't add auth — that's handled upstream"
- ⚠️ Partial: Scope is implied but not explicit
- ❌ Fail: No boundaries stated; scope is wide open and AI will need to make major assumptions

### 4. Integration Context (important for anything touching external systems)
Are the systems this interacts with named and described at the contract level?

- ✅ Pass: "Reads from the payments API; uses the existing PaymentService pattern in /src/services"
- ⚠️ Partial: Systems mentioned but no contract details
- ❌ Fail: Interacts with external systems but none described

### 5. Success Criteria (important)
How will we know it's done? What does "correct" look like from the outside?

- ✅ Pass: Observable, testable outcomes described from the user's perspective
- ⚠️ Partial: "It should work" / vague notion of correctness
- ❌ Fail: No success criteria at all

## Step 2: Taste Check

The rubric catches missing information. Taste catches bad thinking.

A spec can score 5/5 and still be weak. After scoring, ask one qualitative question: **Would a staff engineer at a top FANG company be proud to hand this spec to their team?** If the honest answer is no, flag it — even if it passed every dimension. Be specific about why.

Anti-patterns to call out:

- **Implementation masquerading as spec** — describes how the thing will be built, not what it does. If you see class names, database schemas, or specific library choices in a spec that should be describing behavior, flag it.
- **First-draft spec** — structurally complete but shows no evidence that the hard tradeoffs were considered. It describes the obvious path through the problem and stops there. The difficult cases, the non-obvious constraints, the design decisions that actually matter — all absent.
- **Option soup** — lists three approaches with no opinion on which is right. A spec that presents choices without arguing for one isn't a spec; it's deferred thinking dressed up as thoroughness.

On conviction: if a spec scores 4–5/5 but the approach feels safe, default, or unexamined — say so. A spec that could have been written in five minutes without thinking hard about the problem is a spec that will produce mediocre software. The gate's job isn't just to let through specs that are complete. It's to push for specs that reflect genuine thinking.

## Scoring and Response Logic

**Score 5/5 (all pass):** Proceed. State that the spec looks solid and begin planning.

**Score 4/5 (one partial or fail):** Flag the gap. Ask one targeted question to resolve it. Once answered, proceed.

**Score 3/5 or below:** Stop. Do not begin planning. Present the gaps clearly. Then move directly into the inline spec workflow below to fix them.

**Override available:** If the user explicitly says "proceed anyway," "I know it's vague, just go," or similar — acknowledge the risk clearly ("understood — this spec has [gap X], which means I'll need to make assumptions about [Y]. I'll flag those as I go"), then proceed. Do not block indefinitely; you're a gate, not a wall.

## Inline Spec Workflow

When the spec doesn't pass the gate, build a better one here — don't redirect the user elsewhere. Move through these four phases in order. Don't skip to Tasks or Implementation until earlier phases are solid.

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

Output: Ordered task list.

### Phase 4 — Implement
Agent executes tasks one by one. Your job is to verify at each checkpoint, not review every line.

### Core Principle

A good spec describes **what the system does from the outside** — observable behaviors, not implementation details. The agent chooses the implementation. You define the behavior.

Think of it as a contract: if the system behaves exactly as the spec describes under all conditions including failures, the job is done.

A great spec has a point of view. It doesn't enumerate options — it argues for one and explains why. If you catch yourself listing "approach A vs. approach B" without a recommendation, stop. That's not a spec. That's deferred thinking.

Resist the pull toward the safe, conventional answer. Safe specs produce average software.

## Spec Format

Produce the spec in Markdown, ready to be saved as `SPEC.md` and handed to an agent. Every spec must cover all six sections.

```
# Spec: [Feature Name]

## System Overview
Two to three sentences: what this is, who it serves, why it exists. No implementation details.

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

**On the six sections:**

1. **System Overview** — two to three sentences, who it serves, why it exists, no implementation details
2. **Behavioral Contract** — "When [condition], the system [behavior]" — cover primary flows, error flows, and boundary conditions
3. **Explicit Non-Behaviors** — what the system must NOT do, with reasons; prevents agents from "helpfully" adding scope
4. **Integration Boundaries** — every external system: what data flows in/out, expected contract, unavailability behavior, real vs. mock
5. **Behavioral Scenarios** — minimum 3 happy-path, 2 error, 2 edge-case; written from the outside, evaluated without reading code
6. **Constraints** — stack constraints, files the agent must never touch, version requirements; keep minimal

## Ambiguity Warnings

After producing a spec, self-review for places where an agent would need to make an assumption. For each:
- What's ambiguous
- What assumption the agent would likely make
- What question resolves it

Don't fill in ambiguities yourself. Flag them and ask the user.

## How to Communicate the Gate

Be direct but not condescending. Frame it as: "Before I start planning, I want to make sure the spec is tight enough to get you a useful plan. I have [N] gaps to flag."

Then list gaps concisely. Don't lecture. Don't pad.

**Example — weak prompt:**
> "Build me a modification service for orders"

**Gate response:**
> Before I plan this out, I need to close a few gaps or I'll end up making assumptions that could send us in the wrong direction:
>
> 1. **What does "modification" mean here?** Quantity changes? Address corrections? Item substitutions? All of the above?
> 2. **Who initiates the modification?** The customer directly, a support agent, or an automated system?
> 3. **What systems does this touch?** The existing OrderService? A third-party fulfillment API? Are we writing a new service or extending something existing?
>
> Let me take what you've given me and build out a proper spec. I'll start with the user experience and work inward.

## Quick Self-Check Before Proceeding

**Spec completeness:**
- [ ] Can I state the purpose and user in one sentence?
- [ ] Do I know what happens when something goes wrong?
- [ ] Is the scope bounded — do I know what's out of scope?
- [ ] Do I know every external system this touches?
- [ ] Can I describe what "working correctly" looks like to a user?
- [ ] At least two failure scenarios are explicitly handled
- [ ] Behavioral scenarios could be evaluated by a human without reading the code
- [ ] No ambiguity that would force the agent to make a major assumption silently

**Taste:**
- [ ] Would a staff engineer be proud to hand this to their team?
- [ ] The spec argues for an approach — it doesn't list options without a recommendation
- [ ] The system overview is specific to this system, not generic to any system like it
- [ ] At least one non-obvious scenario is covered (edge case, adversarial input, weird timing)

If any of these is "no," raise it before proceeding.
