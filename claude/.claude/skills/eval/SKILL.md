---
name: eval
description: "Build and run personal eval harnesses for recurring AI tasks (the Lutke Pattern). Creates a regression test suite so you can tell when model updates degrade your workflows. Use when you want to evaluate a skill, prompt, or recurring task. Run after Claude model version changes."
---

# Eval

The Lutke Pattern: build personal test suites for recurring AI tasks, track scores over time, and use the scores to decide how much to trust (and delegate) each task type.

Most developers never do this. They use AI tools for months, model updates silently degrade quality, and they don't notice until something goes wrong in production. This skill makes quality regressions visible.

## When to Trigger

- User says "evaluate," "test this prompt," "how well does this skill work," "build an eval"
- After a Claude model update (check if your workflows degraded)
- When you suspect a skill is producing worse results than it used to
- When you want to decide whether to automate a task further or keep a human in the loop

## Two Modes

### Mode 1: Build an Eval Harness
Run when: you want to create a new eval for a recurring task.

### Mode 2: Run an Eval
Run when: you have an existing eval file and want to score a recent output.

---

## Mode 1: Build an Eval Harness

### Step 1: Pick the Task
What recurring AI task are you evaluating? (e.g., "the commit skill," "code review," "writing Slack messages in my voice")

### Step 2: Collect Sample Inputs
Gather 3-5 representative real inputs you'd actually give this task. Range from easy to hard.

### Step 3: Define Output Qualities (5+)
What makes a good output for this task? Be specific.

Format each as: "The output should [observable, checkable property]"

Examples for a commit skill:
- The output should have a first line under 72 characters
- The output should use past tense ("Fixed" not "Fix")
- The output should explain why, not just what
- The output should not include file names in the first line
- The output should pass `git log --oneline` readability test

### Step 4: List Known Failure Modes
What goes wrong with this task? What have you seen before?

Examples:
- Writes "Fix" instead of "Fixed" (wrong tense)
- First line too long (breaks `git log --oneline`)
- Summarizes file changes instead of explaining intent

### Step 5: Define the Scoring Rubric
Score each output quality 0-2:
- **2**: Clearly passes
- **1**: Partially passes or unclear
- **0**: Fails

Total score = sum across all qualities. Document max possible score.

## Eval File Format

Save to `evals/<task-name>.md`:

```markdown
# Eval: [Task Name]

## Task Description
[What this eval is testing]

## Sample Inputs
1. [Input 1 — easy]
2. [Input 2 — medium]
3. [Input 3 — hard]
4. [Input 4]
5. [Input 5]

## Output Qualities
1. [Quality 1 — observable, checkable]
2. [Quality 2]
3. [Quality 3]
4. [Quality 4]
5. [Quality 5]

## Known Failure Modes
- [Failure mode 1]
- [Failure mode 2]
- [Failure mode 3]

## Scoring Rubric
Each quality scored 0-2. Max score: [N * 2].

| Score | Meaning |
|-------|---------|
| 2 | Clearly passes |
| 1 | Partially passes |
| 0 | Fails |

## Delegation Threshold
- Score >= [X]: Safe to automate fully
- Score [Y-X]: Automate with spot checks
- Score < [Y]: Requires human review on every output

## Result Log

| Date | Model | Input # | Score | Notes |
|------|-------|---------|-------|-------|
```

---

## Mode 2: Run an Eval

Given an eval file and a new output to score:

1. Read the eval file
2. For each output quality, score the output 0-2
3. Sum the scores
4. Compare to the delegation threshold
5. Note any new failure modes not in the file

Return a scoring report:

```
## Eval Result: [Task Name]

**Date**: [today]
**Model**: [model used]
**Input**: [which sample input, or describe]
**Total Score**: [X / max]

### Quality Scores
| Quality | Score | Notes |
|---------|-------|-------|
| [Quality 1] | [0-2] | [what you observed] |
| [Quality 2] | [0-2] | |
...

### Verdict
[Above threshold: Safe to automate / Below: Needs review]

### New Failure Modes Observed
[Any new failures not already in the eval file — add these to the file]
```

## What Not to Do

- Don't write output qualities that are subjective ("sounds good") — make them checkable
- Don't build evals for one-off tasks — only recurring work worth the investment
- Don't set the delegation threshold too high — some human review is appropriate even for good scores
- Don't let result logs go stale — an eval with no recent runs is useless
