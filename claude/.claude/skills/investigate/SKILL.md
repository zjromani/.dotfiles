# Investigate

Entry point for delegated async tasks. Fires when Zach provides raw context — a URL, Slack link, text block, code snippet, or meeting notes — and wants Claude primed to investigate before any real work begins.

This is the "get started" skill. The goal is to understand the context quickly, do the minimum research needed to ask *smart* questions, then stop and wait for answers before proceeding.

## When to Trigger

- User provides a URL, Slack link, or raw text as their first message
- Message starts with `/investigate` followed by context
- User says "look into this", "investigate this", "check this out" with context attached

Every investigate session **always defaults to notion-sync** — a Notion Project is created to track it
(see Step 3.5). This includes Alfred-triggered `ai-delegate` runs and manual `/investigate` pastes.

## Behavior (execute in order)

### Step 1 — Identify context type
Classify what was provided:
- **Slack link** (`hotelengine.slack.com/archives/...`) → use MCP Slack to read the message thread
- **URL** (any other URL) → fetch it with WebFetch
- **Plain text / meeting notes** → extract key entities: people, systems, problems, decisions
- **Code snippet** → identify language, system, and what the snippet is doing
- **Jira/Linear ticket** → fetch it if possible

### Step 2 — Do minimal prelim research
Do the minimum to understand what this is actually about. One tool call, maybe two. Don't go deep — just enough to form smart questions.

- If Slack: read the message + immediate thread context
- If URL: fetch the page, skim for the key problem/question
- If text: parse it for the core ask

### Step 3 — State what you found (brief)
2-3 sentences max:
- What this is about
- What domain/system it touches (which repo, which team, which feature)
- What the apparent question or problem is

### Step 3.5 — Auto-track to Notion (always)
Now that you understand the context (Step 3), invoke the **notion-sync** skill to create a Notion Project
that tracks this session — titled from what you just learned, not the raw URL. This runs automatically on
every investigate session; do not ask permission (Notion writes are "act, then notify" per NOTION.md).
notion-sync captures the origin metadata (AI system, model, session ID, resume command) so the work is
resumable from Notion alone.

After it creates the Project, note the Project URL in one line, then continue to Step 4. Do the tracking
before asking questions — a delegate session is fire-and-forget, so it must be captured even if Zach steps away.

### Step 4 — Ask 2-3 targeted follow-up questions
Questions must be specific to what you found — not generic "what do you want me to do?" Questions should unlock the actual investigation path. Examples by context type:

**Bug/incident:**
- "Is the goal root cause analysis, or do you already know the cause and need a fix?"
- "Is this hitting prod or just staging?"

**Slack thread / decision:**
- "Are you trying to understand the decision that was made, or figure out what to do next?"
- "Is this for V1 scope or the Option 2 follow-up?"

**Code/architecture:**
- "Which repo is this in — nexus, members, sapi, or flights?"
- "Is the goal to understand how this works, or to change it?"

**General:**
- "What would 'done' look like for this investigation?"

### Step 5 — Signal readiness
End with one line: "Ready to dig in — answer those and I'll get started."

## What NOT to Do
- Don't start writing code or making changes before questions are answered (creating the Notion tracking
  Project in Step 3.5 is the one allowed exception)
- Don't ask more than 3 questions
- Don't summarize the context at length — brief statement, then questions
- Don't say "Great context!" or add filler before the questions
- Don't ask obvious questions answerable from the context itself
