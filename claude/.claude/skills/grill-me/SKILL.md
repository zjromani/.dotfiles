---
name: grill-me
description: "Relentlessly interview the user to stress-test a plan, decision, or design. Use when the user wants to sharpen their thinking, stress-test an idea, or says 'grill me', 'grill this', or '/grill-me'."
---

# Grill Me

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

## When to Trigger

- User says "grill me," "grill this," "stress-test my plan," "poke holes in this"
- Before committing to a design, architecture, or product decision
- When a plan feels solid but hasn't been challenged
- User runs `/grill-me`

## Question Format

Each question should be formatted like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree — settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

## Facts vs. Decisions

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it — don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report — ask the rest of the frontier now. The _decisions_ are the user's — put each to them and wait.

## Done When

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.

## What Not to Do

- Don't ask one question at a time when multiple frontier questions are ready
- Don't ask the user for facts you can look up yourself
- Don't start implementing or acting on the plan during the grilling session
- Don't skip giving your recommended answer on each question
- Don't end early while decisions remain silently assumed
