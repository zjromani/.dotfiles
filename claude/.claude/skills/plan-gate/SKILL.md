---
name: plan-gate
description: "Quality gate for plan mode. Triggers whenever the user enters plan mode or asks Claude to plan a technical task. Evaluates the prompt/spec before any planning or execution begins. Challenges insufficient specifications and requires the user to either improve them or explicitly override. This skill prevents the most common AI development failure: jumping into implementation before the specification is solid enough to guide it."
---

# Plan Gate

A quality checkpoint that runs before any planning or execution begins. The goal is to catch underspecified prompts before they produce wrong output — which is always more expensive to fix than spending 5 minutes sharpening the spec upfront.

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

## The Evaluation Rubric

Score the incoming prompt/spec across five dimensions. Each is pass/fail with partial credit.

### 1. Intent Clarity (required)
Can you state in one sentence what this system/feature does and who it's for?

- ✅ Pass: "This is a Slack bot that sends daily digest emails to team leads summarizing unresolved Jira tickets assigned to their team."
- ⚠️ Partial: "A bot that helps with Jira stuff"
- ❌ Fail: "Make it better" / "The usual thing we talked about" / no clear user or outcome stated

### 2. Behavioral Contract (required)
Are the expected inputs, outputs, and system behaviors described — especially for failure cases?

- ✅ Pass: Happy path AND at least one error case described. What happens when the external API is down? What does the user see?
- ⚠️ Partial: Happy path only, no error handling described
- ❌ Fail: No specific behaviors described at all; only a vague goal

### 3. Explicit Boundaries (important)
Is it clear what this should NOT do? Has scope been constrained?

- ✅ Pass: "This should only handle lodging bookings, not flights or cars" / "Don't add auth — that's handled upstream"
- ⚠️ Partial: Scope is implied but not explicit
- ❌ Fail: No boundaries stated; scope is wide open and AI will need to make major assumptions

### 4. Integration Context (important for anything touching external systems)
Are the systems this interacts with named and described at the contract level?

- ✅ Pass: "Reads from the Amadeus booking API; uses the existing BookingService pattern in /src/services"
- ⚠️ Partial: Systems mentioned but no contract details
- ❌ Fail: Interacts with external systems but none described

### 5. Success Criteria (important)
How will we know it's done? What does "correct" look like from the outside?

- ✅ Pass: Observable, testable outcomes described from the user's perspective
- ⚠️ Partial: "It should work" / vague notion of correctness
- ❌ Fail: No success criteria at all

## Scoring and Response Logic

**Score 5/5 (all pass):** Proceed. State that the spec looks solid and begin planning.

**Score 4/5 (one partial or fail):** Flag the gap. Ask one targeted question to resolve it. Once answered, proceed.

**Score 3/5 or below:** Stop. Do not begin planning. Present the gaps clearly and ask the user to address them — OR offer to help write a better spec (invoke the spec-writer skill).

**Override available:** If the user explicitly says "proceed anyway," "I know it's vague, just go," or similar — acknowledge the risk clearly ("understood — this spec has [gap X], which means I'll need to make assumptions about [Y]. I'll flag those as I go"), then proceed. Do not block indefinitely; you're a gate, not a wall.

## How to Communicate the Gate

Be direct but not condescending. Frame it as: "Before I start planning, I want to make sure the spec is tight enough to get you a useful plan. I have [N] gaps to flag."

Then list gaps concisely. Don't lecture. Don't pad.

**Example — weak prompt:**
> "Build me a modification service for flight bookings"

**Gate response:**
> Before I plan this out, I need to close a few gaps or I'll end up making assumptions that could send us in the wrong direction:
>
> 1. **What does "modification" mean here?** Date changes? Passenger name corrections? Seat upgrades? All of the above?
> 2. **Who initiates the modification?** The traveler directly, a support agent, or an automated system?
> 3. **What systems does this touch?** Amadeus? Sabre? The existing BookingService? Are we writing a new service or extending something existing?
>
> Answer these and I'll have what I need to write a solid plan. Or say "proceed anyway" and I'll flag my assumptions as I go.

## What Good Looks Like

A spec that passes the gate covers:
- **Who** is doing what
- **What** the system does in normal and error cases
- **What** it explicitly does NOT do
- **What** external systems it touches and how
- **What** done looks like from the outside

It doesn't need to be long. One well-structured paragraph per dimension beats five pages of vague prose.

## Quick Self-Check Before Proceeding

- [ ] Can I state the purpose and user in one sentence?
- [ ] Do I know what happens when something goes wrong?
- [ ] Is the scope bounded — do I know what's out of scope?
- [ ] Do I know every external system this touches?
- [ ] Can I describe what "working correctly" looks like to a user?

If any of these is "no," raise it before proceeding.

