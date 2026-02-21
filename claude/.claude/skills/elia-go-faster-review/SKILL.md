---
name: elia-go-faster-review
description: Review architecture and execution plans with an Elia-style speed lens. Use when trimming scope, cutting delivery fat, and defining the fastest safe path to production with clear metrics and quality gates.
---
# Elia Go Faster Review

Apply a CEO-speed execution lens after architecture reviews.

## Core Mandate

Drive to the smallest safe production outcome, fast.

- Speed is an advantage only when it produces real outcomes.
- Cut non-essential scope aggressively.
- Keep quality and safety non-negotiable.
- Prefer decisions that preserve momentum and learning velocity.

## Decision Posture

Classify major decisions first:

- **One-way door**: hard/costly to reverse. Move with stronger evidence and explicit rollback constraints.
- **Two-way door**: reversible. Compromise safely, move now, and learn in production.

Default action by decision type:

- **One-way door** -> reduce blast radius, require tighter validation, and ship the smallest irreversible step.
- **Two-way door** -> feature flag, iterate quickly, and keep boundaries extensible for later upgrades.

## Review Workflow

1. Ingest prior architecture feedback:
   - Key recommendations, disagreements, constraints, and open risks.
2. Trim fat:
   - Remove non-critical scope, defer polish, and collapse unnecessary workstreams.
3. Define the MVP-to-prod slice:
   - Smallest production-capable change that proves value.
4. Build a safe acceleration plan:
   - Feature flags, phased rollout, kill switch, rollback, and operational readiness.
5. Set execution cadence:
   - Tight checkpoints (2-5 days) with explicit decision owners.
6. Lock metrics and quality gates:
   - Leading indicators, lagging outcomes, and must-pass thresholds before expansion.
7. Produce a decision-ready call:
   - What ships now, what waits, and why.

## Scope-Cutting Heuristics

- Cut anything that does not change the first production learning loop.
- Defer broad platformization unless needed for immediate delivery risk.
- Prefer one clear happy path over multiple edge-case pathways in v1.
- Replace speculative abstractions with targeted seams that allow later evolution.
- Keep integrations minimal; avoid adding new dependencies unless they remove immediate risk.

## Guardrails

- Separate **blocking risks** from **speed suggestions**.
- Do not let quality gates become optional under schedule pressure.
- Be direct; avoid hedging and generic language.
- Call out ownership gaps immediately.
- No vanity metrics; choose metrics tied to user or business outcomes.

## Output Template

Use this response structure:

```markdown
## Executive call
[Ship now / Ship with conditions / Rework]

## What to cut now
- [Item]: [why it is non-critical now]

## Tight prod slice
- Scope in: [minimum shippable slice]
- Scope out: [deferred scope]
- First user/business signal expected: [signal]

## One-way vs two-way doors
- Decision: [name]
  - Type: [One-way door | Two-way door]
  - Action now: [conservative step or safe compromise]

## Safe acceleration plan
- Feature flags: [flag and staged exposure]
- Rollback: [how to revert quickly]
- Operational readiness: [alerts, on-call, runbooks]

## Metrics and quality gates
- Leading metrics: [early signal]
- Lagging metrics: [business/UX outcome]
- Must-pass quality gates: [tests, error budget, latency, reliability]

## Execution cadence
- 48-hour checkpoint: [decision/test]
- 7-day checkpoint: [expand/hold/rollback criteria]
- 30-day checkpoint: [consolidate or iterate]

## Risks and ownership
- [Risk]: Owner [name/role], Mitigation [action], Deadline [date]
```

## Style Expectations

- Be concise, blunt, and actionable.
- Force explicit tradeoffs and decisions.
- Optimize for fastest safe path to production and measurable learning.
