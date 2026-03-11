---
name: think
description: "Use when the user wants to think through a complex problem before starting work. Runs a 7-question pre-AI thinking exercise that produces a compact brief — the starting context for any session. Prevents the core failure mode: AI thinking for you before you've thought for yourself."
---

# Think

A pen-and-paper exercise in digital form. Run this BEFORE opening any serious AI session. The bottleneck in 2026 AI workflows isn't writing good prompts — it's knowing what you want before AI starts working. If you haven't figured out what you think first, you'll end up thinking what it thinks.

This produces one artifact: a compact brief that becomes the grounding context for the rest of the session.

## When to Trigger

- User says "help me think through," "I need to figure out," "I'm not sure how to approach"
- Before any plan mode session on a complex or ambiguous problem
- When a user is circling a problem without a clear direction
- Before delegating a broad autonomous task to Claude

## The 7 Questions

Work through these in order. Don't skip. The uncomfortable ones are the most important.

### 1. What am I actually trying to accomplish?
State the outcome, not the task. "Ship the billing feature" not "write the Stripe integration." What changes in the world when this is done?

### 2. Why does this matter?
What breaks if this doesn't happen? Who cares? If you can't answer this, the task may not be worth doing.

### 3. What does "done" look like?
Specific, observable. Not "it works" — describe what you'd see, click, test, or measure to know it's actually done.

### 4. What does "wrong" look like?
What would a technically correct but bad outcome look like? (The Klarna Pattern: AI produces something that answers the prompt but misses the point.) Being explicit about failure modes prevents them.

### 5. What do I already know that I haven't written down?
Institutional knowledge, prior decisions, things you'd tell a new hire. This is the context AI is missing that will cause it to produce wrong output.

### 6. What are the pieces?
Decompose the problem. What are the 3-7 distinct components or steps? Don't worry about sequencing yet — just enumerate.

### 7. What's the hard part?
Where are the judgment calls? The uncertainty? The things you're not sure how to handle? These are the places where AI is most likely to go wrong without explicit guidance.

## Output Format

After working through the 7 questions, produce a compact brief in this format:

```
## Brief: [one-line description of the task]

**Goal**: [outcome, not task — one sentence]
**Done when**: [specific, observable criteria]
**Wrong looks like**: [the Klarna Pattern failure mode for this task]
**Context you need**: [institutional knowledge, prior decisions, constraints]
**Pieces**: [3-7 components]
**Hard parts**: [judgment calls, uncertainty, places to check in]
```

Present the brief to the user and ask: "Does this capture what you're trying to do, or is anything off?"

After confirmation, use the brief as the grounding context for the rest of the session. Paste it at the top of any plan file. Reference it when making decisions.

## What Not to Do

- Don't start solving the problem during the thinking exercise
- Don't skip questions because the answer seems obvious
- Don't let the brief get longer than one page — compression is the point
- Don't proceed if question 3 (done looks like) or question 7 (hard parts) is empty — those are the highest-signal answers
