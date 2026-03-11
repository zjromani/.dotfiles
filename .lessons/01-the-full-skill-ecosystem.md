# The Full Skill Ecosystem

You have 12 skills and 4 agents as of March 2026. This lesson maps the full set, explains what each does, and — critically — explains how they relate to each other so you can reach for the right tool without guessing.

---

## What Skills Are

Skills are markdown prompt files in `claude/.claude/skills/`. Each one is a reusable instruction set that Claude activates based on your trigger words or an explicit `/skillname` invocation. They are shared between Claude Code and Cursor via symlinks — the canonical source is always `claude/.claude/skills/`, and `cursor/.cursor/skills/` symlinks back to it.

Skills run in the main Claude context. They don't spawn separate processes or manage their own tool access — they're instructions for how Claude should behave on a specific class of task.

## What Agents Are

Agents are specialized Claude instances defined in `claude/.claude/agents/`. Unlike skills, each agent gets its own context window, its own model (can differ from the main conversation), and can be run in the background. They're invoked via the Agent/Task tool when you need isolated, autonomous work that would pollute the main context or run in parallel.

Use a skill when: the task fits in the main conversation flow.
Use an agent when: the task is long-running, needs isolation, or should run in parallel.

---

## The Full Skill Map

### Pre-Task Skills (start here)

**`think`** — The pre-AI thinking exercise. Runs before any complex session. 7 questions that produce a compact brief. The goal: figure out what you want before AI starts working. Without this, you get technically correct but wrong output.

**`plan-gate`** — Quality gate for plan mode. Evaluates whether your spec is solid enough to plan against. Scores on 5 dimensions. If it fails, builds a better spec inline. Runs automatically when you enter plan mode or ask Claude to "plan" something.

**`delegate`** — Intent encoding for autonomous tasks. Produces a Decision Authority Map (decide alone / notify / escalate) and a Constraint Architecture (Must Do / Must Not Do / Prefer / Escalate). Run this before handing Claude a broad, autonomous task.

### During-Task Skills

**`debug`** — Systematic root cause analysis. 6 steps: Reproduce → Isolate → Hypothesize → Verify → Fix → Regress. Activates when you report a bug or unexpected behavior. Prevents jumping to fixes before understanding the cause.

**`learn`** — Curriculum builder. Creates `.lessons/` directories with structured lesson files. Use when ramping up on a codebase, technology, or team process. Lessons are self-contained — no external links required to follow them.

### Output Skills (end of task)

**`commit`** — Atomic git commits with past-tense, "why"-focused messages. Enforces small, reversible commits. Checks git status, reviews recent log style, then commits.

**`pr`** — GitHub pull requests with concise summary and test plan. Pushes if needed, creates the PR with proper body format via `gh pr create`.

**`review`** — Code review with severity calibration: Critical (production bugs) / Major (logic errors) / Minor (style). Gives specific file:line references, distinguishes blocking from nice-to-have.

### Communication Skills

**`zach-editor`** — Polishes rough text into Zach's authentic voice. Short punchy sentences, no corporate polish, fragment-friendly. Use for Slack messages, async updates, quick notes.

### Architecture / Decision Skills

**`one-way-door-review`** — Architecture review prioritizing irreversible decisions. Classifies every decision as one-way (hard to undo) or two-way (reversible). One-way decisions get higher scrutiny and explicit rollback constraints.

**`elia-go-faster-review`** — CEO-speed execution review. Aggressively trims scope while maintaining quality gates. Core question: what's the smallest safe production outcome, and what can be cut to get there faster?

### Quality / Maintenance Skills

**`eval`** — Personal eval harnesses (Lutke Pattern). Builds regression test suites for recurring AI tasks. Scores outputs against defined qualities. Use after model updates to catch regressions in your workflows.

---

## The Agent Map

**`software-architect`** (opus) — System design, ADRs, task breakdowns, API contracts. Does NOT write implementation code — produces pseudocode, interfaces, contracts. Use when a feature needs proper design before any coding starts.

**`research`** (opus) — Web search, document analysis, fact verification. Tracks sources, distinguishes facts from opinion, flags low-confidence claims. Use when you need reliable information about a technology, library, or approach.

**`session-manager`** (opus) — Long-running workflow continuity. Creates checkpoints at `.claude/checkpoints/`. Compacts context to ~20% of original size. Use when a task is large enough that you might need to pause and resume.

**`build-validator`** (haiku) — Background CI pipeline runner. Detects project type (Node, Ruby, Go, Python, Java/Kotlin, Rust) and runs the appropriate test/lint/type-check pipeline. Reports failures with targeted fix instructions. Use after any code changes, in parallel with your review.

---

## How They Compose

The skills and agents form a flow, not isolated tools:

```
[Complex Task Arrives]
        ↓
  /think  ←─── 7-question brief
        ↓
  /plan-gate ←─── spec quality check
        ↓
  /delegate ←─── autonomous task setup (if broad scope)
        ↓
  [Implementation — debug as needed]
        ↓
  build-validator (background) ←─── parallel CI check
        ↓
  /review ←─── code quality check
        ↓
  /commit → /pr
```

Architecture decisions at any point → `software-architect` agent
Research needs at any point → `research` agent
Long tasks nearing context limit → `session-manager` agent

The most common mistake: skipping the pre-task skills (`think`, `plan-gate`) and jumping straight to implementation. This is where rework originates.

---

## Key Takeaways

- Skills run in the main context; agents run in isolated subprocesses with their own model and context window
- Pre-task skills (`think`, `plan-gate`, `delegate`) are the highest-leverage tools in the set — they prevent rework upstream
- The four new skills added in March 2026 (`think`, `delegate`, `debug`, `eval`) fill specific gaps: pre-thinking, intent encoding, debugging discipline, and quality regression tracking
- `build-validator` is the only background agent — use it after every code change, in parallel, so it doesn't block your flow
- All skills are shared between Claude Code and Cursor via symlinks; `bin/scripts/sync-cursor-skills` keeps them in sync

## Additional Information

- Related lessons: `02-think-pre-ai-thinking.md`, `03-delegate-encoding-your-judgment.md`
- Skill source: `claude/.claude/skills/` (canonical)
- Agent source: `claude/.claude/agents/`
- Sync script: `bin/scripts/sync-cursor-skills`
