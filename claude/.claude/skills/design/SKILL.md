---
name: design
description: "Orchestrated design workflow: think→spec→dtd→architecture review. Use when starting from ambiguity on a net-new feature or system. Runs a full iterative interview loop — stops at each stage until the spec is genuinely clear, never skips forward with assumptions."
---

# Design

An end-to-end design workflow that chains four stages into one iterative session. The goal is to take ambiguity as input and produce a validated DTD plus architecture review as output — with human confirmation gates at every step.

This is not the same as `/plan-gate`. Plan-gate is a quality check on a spec you already have. `/design` is the full creative process for when you don't have a spec yet — or when the one you have is too vague to trust.

## When to Trigger

**Explicit invocation**: User types `/design`

**Auto-trigger when**:
- "let's design...", "I want to architect...", "help me spec out..."
- Any request for a net-new feature or system from ambiguity
- The user has an idea but not yet a spec

**Do NOT trigger for**:
- Bug fixes or small, well-defined changes
- Cases where the user already has a complete spec (use `/plan-gate` instead)
- When the user explicitly wants just one stage (use that skill directly)

---

## Core Principle

> If the answer to any question is unclear, ambiguous, or vague — stop and ask. Never proceed with an assumption. The whole point of this skill is to be the thing that catches underspecification before it causes rework.

This applies at every stage. Probe vague answers. "I'm not sure" is not an answer — it's an invitation to ask a more targeted question. The discomfort of a hard question now is far cheaper than rework after implementation.

---

## Stage 1: Think

**Goal**: Produce a compact brief from the raw idea.

Run the 7 think questions to help the user clarify what they actually want. Present each question and wait for a real answer. Don't rush through them — the uncomfortable ones are the highest signal.

### The 7 Questions

1. **What am I actually trying to accomplish?** State the outcome, not the task. What changes in the world when this is done?
2. **Why does this matter?** What breaks if this doesn't happen? Who cares?
3. **What does "done" look like?** Specific, observable. Not "it works" — describe what you'd see, click, test, or measure.
4. **What does "wrong" look like?** A technically correct but bad outcome. What would the Klarna Pattern failure look like here?
5. **What do I already know that I haven't written down?** Institutional knowledge, prior decisions, things you'd tell a new hire.
6. **What are the pieces?** 3–7 distinct components or steps. Don't sequence yet — enumerate.
7. **What's the hard part?** Judgment calls, uncertainty, places where AI is most likely to go wrong without guidance.

### Handling Vague Answers

If the user gives a short or unclear answer, don't accept it and move on. Ask one follow-up that makes the question more concrete. Examples:
- "I'm not sure" → "What would need to be true for you to feel sure? What's the uncertainty?"
- "It should work well" → "What would a tester click to verify it's working? What would they see?"
- "The usual thing" → "Walk me through the last time this came up — what happened?"

### Stage 1 Output

After all 7 questions, produce a compact brief:

```
## Brief: [one-line description]

**Goal**: [outcome, not task — one sentence]
**Done when**: [specific, observable criteria]
**Wrong looks like**: [Klarna Pattern failure mode for this task]
**Context you need**: [institutional knowledge, prior decisions, constraints]
**Pieces**: [3–7 components]
**Hard parts**: [judgment calls, uncertainty, places to check in]
```

**Gate**: Present the brief. Ask: "Does this capture what you're trying to do, or is anything off?" Do not advance to Stage 2 until the user confirms the brief is accurate.

---

## Stage 2: Spec (Plan Gate)

**Goal**: Validate the brief against 5 dimensions. Surface every gap. Iterate until the spec passes.

Using the confirmed brief as input, evaluate it across five dimensions:

### The 5 Dimensions

**1. Intent Clarity** (required): Can you state in one sentence what this system does and who it's for?

**2. Behavioral Contract** (required): Are inputs, outputs, and system behaviors described — especially for failure cases?

**3. Explicit Boundaries** (important): Is it clear what this should NOT do? Is scope constrained?

**4. Integration Context** (important): Are external systems named and described at the contract level?

**5. Success Criteria** (important): How will we know it's done? What does "correct" look like from the outside?

### Scoring Logic

- **5/5**: Advance.
- **4/5**: Flag the gap. Ask one targeted question to close it. Once answered, advance.
- **3/5 or below**: Stop. Present the gaps clearly. For each gap, ask one targeted question. Do not advance until the spec scores 4–5/5.

### Taste Check

After scoring, ask: would a staff engineer at a top FANG company be proud to hand this spec to their team? Flag anti-patterns even if the rubric passes:
- Implementation masquerading as spec
- First-draft spec with no evidence hard tradeoffs were considered
- Option soup — lists approaches without a recommendation

### Spec Output

When the spec passes, produce it in this format:

```
# Spec: [Feature Name]

## System Overview
[2–3 sentences: what this is, who it serves, why it exists]

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
| System | Data In | Data Out | Unavailability Behavior |

## Behavioral Scenarios
[Minimum 3 happy-path, 2 error, 2 edge-case]

## Constraints
[Stack, files to never touch, version requirements]

## Ambiguity Warnings
- [ ] [What's ambiguous] — likely assumption: [X] — resolving question: [Y]
```

**Gate**: Do not advance to Stage 3 until the spec scores 4–5/5. This is a hard gate — not a suggestion.

---

## Stage 3: DTD

**Goal**: Produce a complete, Confluence-ready DTD.

Using the confirmed spec as context, run the 6 DTD questions. Do not re-ask questions already answered in the brief or spec — pull those answers forward and use them. Only ask about genuinely new dimensions.

### The 6 DTD Questions

1. **Feature name and context links**: "What is the feature name? Share any relevant links (Asana, Figma, Discovery Doc, related PRs)."
2. **Problem statement**: Already established in Think — confirm or refine: "Here's the problem as I understand it from our brief: [X]. Is this accurate for the DTD?"
3. **Proposed solution**: Already established in the spec — confirm: "Here's the proposed solution: [X]. Any changes for the formal doc?"
4. **Phased release plan**: "How will this ship? Main phases or epics? Fine if it's a single phase."
5. **API and data model changes**: "Any known API changes, new endpoints, or data model changes? Or 'none yet' if unknown."
6. **Authorization changes**: "Any changes to authorization scopes or permission checks? Which endpoints or resources?"

For any question where the answer is unclear: probe, don't stub. A stub in the DTD signals "this is unknown" — that's intentional. But "I'm not sure" about a critical API contract is a problem to surface now, not defer.

### DTD Output

Produce the full DTD using the standard template:

```markdown
# [Feature Name] — Design Technical Document

## Related Links
| Type | Link |
|------|------|
| Asana | [ADD LINK] |
| Figma | [ADD LINK] |
| Discovery Doc | [ADD LINK] |
| Preliminary Design | [ADD LINK] |

---

## Problem Statement
[2–5 sentences. What is broken, missing, or painful today?]

---

## Proposed Solution
[2–5 sentences. What is the approach? Why is this right? What does it not do?]

---

## Phased Release Plan
| Phase | Epic / Description | Notes |
|-------|--------------------|-------|

---

## Implementation Details

### System Design

#### Architecture
[ADD CONTENT HERE]

#### Data Model
[ADD CONTENT HERE]

#### UI
[ADD CONTENT HERE]

#### API Docs
[ADD CONTENT HERE]

---

### Fault Tolerance
[ADD CONTENT HERE]

---

### Test Plan

#### Automation Tests
| Test | Type | Description | Coverage |
|------|------|-------------|----------|

---

### Observability

#### Amplitude Events
| Event Name | Trigger | Properties | Notes |
|------------|---------|------------|-------|

#### Datadog Metrics
| Metric | Type | Description | Alert Threshold |
|--------|------|-------------|-----------------|

---

### Changes to Managed Objects
| Object | Change Type | Description |
|--------|-------------|-------------|

---

### Authorization
| Endpoint / Resource | Scope Required | Change |
|--------------------|----------------|--------|

---

### Product Metrics
| Event | Description | Target |
|-------|-------------|--------|

---

### Solution Alternatives
| Alternative | Why Considered | Why Rejected |
|-------------|----------------|--------------|
```

**Gate**: Present the DTD. Ask: "Does this capture the design, or are there sections you want to revise before I run the architecture review?" Do not advance to Stage 4 until the user confirms.

---

## Stage 4: Architecture Review (Parallel)

**Goal**: Produce a unified executive recommendation combining reversibility analysis and technical depth.

After the DTD is confirmed, launch two analyses simultaneously against the DTD as input:

### Parallel Analysis

**Analysis A — Reversibility (one-way-door-review)**:
Run the one-way-door review workflow against the DTD:
1. Classify each major decision: one-way door or two-way door
2. Stress-test one-way doors: long-term lock-in, blast radius, rollback feasibility
3. Optimize two-way doors for speed and safety: feature flags, phased rollout, fallback path
4. Identify what to commit now vs. defer

**Analysis B — Technical Depth (software-architect agent)**:
Run a deep technical analysis against the DTD:
- API contract design and consistency
- Tradeoff evaluation across major implementation choices
- ADR candidates (decisions worth recording)
- Technical risks and mitigations
- Implementation sequencing

Both analyses take the confirmed DTD as input and run in parallel. Neither depends on the other.

### Synthesis Step

After both analyses complete, merge outputs into a single unified recommendation:

1. **Risk posture first**: The one-way-door findings set the risk posture and identify which decisions cannot be undone. These frame everything else.
2. **Technical depth second**: The software-architect findings add implementation tradeoffs and concrete guidance within the risk constraints.
3. **Surface conflicts**: Any place where the two analyses disagree or tension each other — raise it as an explicit open question, not a silent resolution.

### Stage 4 Output

```markdown
## Architecture Review: [Feature Name]

### Executive Recommendation
[1–3 sentences: proceed / proceed with conditions / rework. Include confidence level.]

### Irreversible Decisions (One-Way Doors)
[List each one-way door with: decision name, why it's irreversible, confidence, required evidence before committing]

### Technical Analysis
[Key tradeoffs, API contract recommendations, implementation sequencing, ADR candidates]

### Risk Register
[Blocking risks with specific mitigations. Non-blocking risks clearly labeled.]

### Safe Path Forward
[Phased approach: what to commit now, what to defer, what to prototype first]

### Open Questions
[Conflicts between analyses + unresolved decisions that affect irreversible choices]

### ADR Candidates
[Decisions that warrant a formal Architecture Decision Record]
```

---

## End State

When Stage 4 is complete, the user has:

1. **Brief** — compact 6-field summary of what they're building and why
2. **Spec** — validated behavioral contract (4–5/5 on all dimensions)
3. **DTD** — complete Confluence-ready design document
4. **Architecture Review** — unified recommendation with one-way door assessment and technical depth

These four artifacts are the complete output of `/design`. They can be handed directly to an implementation agent, a team review, or filed as the design record for the feature.

---

## What Not to Do

- Don't skip the Think stage because the user seems to know what they want — the brief is the contract for everything that follows
- Don't advance past a gate with a vague or unconfirmed answer — the gates are the whole point
- Don't re-interview on questions already answered in earlier stages — carry answers forward
- Don't merge the architecture analyses before both are complete — synthesis requires both inputs
- Don't produce a DTD with stub sections for things that were actually discussed — stubs signal genuine unknowns, not laziness
- Don't let "I'm not sure" be the final answer to any question that drives an irreversible decision
