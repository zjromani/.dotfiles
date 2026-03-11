---
name: debug
description: "Systematic debugging workflow. Use when the user has a bug, failure, or unexpected behavior. Follows a 6-step root cause process: Reproduce → Isolate → Hypothesize → Verify → Fix → Regress. Prevents the most common debugging mistake: jumping to solutions before understanding the problem."
---

# Debug

The most common debugging mistake is jumping to a fix before understanding the root cause. This produces patches that mask symptoms, break adjacent behavior, or make the real problem harder to find later.

This skill enforces a 6-step process. It is not always linear — you may loop between Hypothesize and Verify — but every step must be visited before shipping a fix.

## When to Trigger

- User says "fix this bug," "it's broken," "why is this failing," "something's wrong with"
- A test is failing and the cause is unclear
- Unexpected behavior in production or staging
- "It works on my machine" situations
- Any situation where the user is guessing at causes

## The 6-Step Process

### Step 1: Reproduce
**Goal**: Establish the exact conditions that trigger the bug.

Questions to answer:
- What is the exact input, state, or sequence of actions that causes the failure?
- Is it consistent or flaky?
- What environment? (local, staging, prod, specific browser/OS)
- When did it start? (was it ever working?)

**Do not proceed until you can reproduce it reliably.** Flaky bugs need their own investigation before this process can apply.

### Step 2: Isolate
**Goal**: Narrow to the minimal failing case.

Strip away everything not essential to the failure. The minimal case should:
- Fail consistently
- Be as small as possible
- Remove all unrelated code, config, and data

If you can't isolate it to a specific component, file, or function — go back to step 1.

### Step 3: Hypothesize
**Goal**: Generate the top 3 possible causes, ranked by likelihood.

For each hypothesis:
- State what would have to be true for this to be the cause
- Explain what evidence supports it
- Explain what evidence would rule it out

Don't commit to a cause yet. Generate at least 2-3 competing explanations.

### Step 4: Verify
**Goal**: Confirm which hypothesis is correct.

For each hypothesis (in order of likelihood):
- Add targeted logging, breakpoints, or assertions
- Construct a test that would pass if the hypothesis is correct and fail otherwise
- Read the code path end to end — don't assume, trace

**Stop when you've confirmed the root cause.** A verified root cause is: "Line X does Y, but it should do Z, because W."

### Step 5: Fix
**Goal**: Minimal, targeted change that addresses the root cause.

Rules:
- Fix the root cause, not the symptom
- Change only what's necessary — no opportunistic refactors
- If the fix is larger than expected, check your root cause — you may be fixing the wrong thing
- Add a comment explaining why if the code is non-obvious

### Step 6: Regress
**Goal**: Verify the fix works and doesn't break adjacent behavior.

- Run the minimal reproduction case — it should pass
- Run the full test suite (or the relevant subset)
- Check the code paths adjacent to the fix for side effects
- If there's no test covering the bug — add one now

## Output Format

After completing the process, produce a debug summary:

```
## Debug Summary

**Bug**: [one-line description]
**Root Cause**: [exact statement of what was wrong and why]
**Fix**: [what was changed, in one sentence]
**Verified by**: [how you confirmed it — test name, repro case, etc.]
**Regression check**: [what you ran to confirm nothing broke]
**Test added**: [yes/no — if no, why not]
```

## What Not to Do

- Don't start with Step 5 — even if you're confident you know the cause
- Don't fix multiple bugs in one PR unless they share a root cause
- Don't add logging in production without a plan to remove it
- Don't skip Step 6 — the most confident fixes break something adjacent
- Don't write "fixed it" without a root cause statement — if you can't state the root cause, you haven't found it
