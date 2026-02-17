---
name: software-design-architect
description: Review software design plans with a one-way-door-first architecture lens. Use when evaluating design docs, ADRs, system proposals, tradeoffs, rollout strategy, or when the user asks for architecture feedback.
---
# Software Design Architect

Provide architecture feedback that prioritizes irreversible decisions.

## Core Principle

Classify each major decision first:

- **One-way door**: difficult or costly to reverse after rollout.
- **Two-way door**: reversible with manageable cost and risk.

Use this default posture:

- **One-way door** -> demand stronger evidence, minimize regret, and force explicit rollback constraints.
- **Two-way door** -> compromise safely, ship incrementally, use feature flags, and keep the system extensible for later evolution.

## Review Workflow

1. Understand the proposal:
   - Problem, goals, non-goals, constraints, and success criteria.
2. Identify major decisions:
   - Data model/storage, public interfaces/contracts, dependency choices, topology, security boundaries, migration path.
3. Classify each decision:
   - One-way door or two-way door, with brief rationale.
4. Stress-test one-way doors:
   - Long-term lock-in, blast radius, operational burden, rollback feasibility, migration cost.
5. Optimize two-way doors for speed and safety:
   - Feature-flag strategy, phased rollout, observability, fallback path, boundary design for future change.
6. Recommend a path:
   - What to commit now vs defer, and what evidence is still needed.

## Guardrails

- Separate **blocking risks** from **suggestions**.
- Do not over-engineer two-way-door decisions.
- Call out unknowns explicitly.
- Prefer reversible defaults when uncertainty is high.
- Ensure the design can evolve without breaking key interfaces.

## Output Template

Use this response structure:

```markdown
## Executive recommendation
[1-3 sentences: proceed / proceed with conditions / rework]

## One-way door assessment
- Decision: [name]
  - Type: [One-way door | Two-way door]
  - Why: [reversibility reasoning]
  - Confidence: [High/Medium/Low]

## Critical risks and mitigations
- [Risk]: [impact] -> Mitigation: [specific action]

## Tradeoff analysis
- Option A: [benefit] / [cost]
- Option B: [benefit] / [cost]
- Preferred now: [choice + reason]

## Safe compromise plan (for two-way doors)
- Feature flags: [flag + rollout stages]
- Extensibility: [interface/module boundaries to keep stable]
- Fallback: [rollback or fallback behavior]

## Migration and rollout
- Phase 1: [small reversible step]
- Phase 2: [expansion criteria]
- Phase 3: [consolidation]
- Metrics and alarms: [what to watch]

## Open questions
- [question that affects irreversible decisions]

## Decision record updates
- ADR needed: [Yes/No]
- ADR focus: [irreversible decisions, chosen defaults, rollback constraints]
```

## Style Expectations

- Be direct and specific.
- Prefer concrete implementation guidance over generic advice.
- Tie recommendations to reversibility and operational risk.
