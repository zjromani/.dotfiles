# /resume-project

Load context for an active project and orient for the session.

## Usage

```
/resume-project <NAME>
```

Example: `/resume-project ATC`

## What This Does

Reads the shared source of truth + local working state and synthesizes:
- What phase the project is in
- What's shipped vs. in-flight
- Immediate next steps
- Open questions

## Session Start Protocol

Execute these steps in order:

**Step 1 — Shared source of truth (`atc-context/` or equivalent):**

```
ls ~/flights/atc-context/
```

Read files relevant to the project — for ATC, that's all files in `~/flights/atc-context/`. If a `current-state.md` or cross-repo implementation plan exists, read it. Read `atc-cross-repo-implementation-plan.md` if present — it has PR status and phase tracking.

**Step 2 — Local working state:**

```
Read ~/flights/projects/<NAME>/RESUME.md
```

This is the local session continuity layer: current phase, last session summary, immediate next steps, open questions, key decisions.

**Step 3 — Latest design doc:**

Check `~/flights/projects/<NAME>/design/` for the most recently modified `.md` file and read it if it contains context not already in RESUME.md.

**Step 4 — Synthesize and surface:**

Output a concise orientation (< 20 lines) covering:
1. **Current phase** — where are we in the arc?
2. **What's shipped** — merged PRs, completed milestones
3. **What's in flight** — open PRs, active branches, in-progress tickets
4. **Immediate next steps** — top 2-3 actions to take this session
5. **Open questions** — anything blocking or requiring a decision

Do not dump raw file contents. Synthesize. The goal is to be fully oriented in < 2 minutes.
