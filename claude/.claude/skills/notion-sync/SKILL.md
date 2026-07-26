---
name: notion-sync
description: Sync the current AI conversation (Claude Code, Cursor, etc.) to a Notion Project — either create a new Project or link to an existing one, record the session's origin metadata (model, conversation name, session ID, AI system), and append a timestamped status comment. Use this whenever Zach says "sync this to Notion", "track this as a project", "notion-sync", "link this session to Notion", "turn this into a Notion project", or references a Notion project URL to keep working against. Follows the Notion Constitution (~/.claude/NOTION.md). Requires the Notion MCP.
---
# Notion Conversation Sync

Turns the current AI conversation into a Notion Project, or attaches it to an existing one, so the work
is resumable from Notion alone. This skill only implements the mechanics — the workspace-wide rules it
obeys (Project body structure, default status, origin-linking standard) live in `~/.claude/NOTION.md`
(source `claude/.claude/NOTION.md`). Read that file's Sections 5, 6, and "Project Page Structure" before
writing. Reference implementation for Notion writes: `claude/.claude/skills/daily-debrief/SKILL.md`.

**Projects data source:** `e751bb01-362f-498f-b2b4-aa2e55f081f8`
**Areas of Focus data source:** `7e49eef0-a274-45f1-b2b3-e678ef004ac4`
**Weeks data source:** `7dd17d1f-1cf3-4281-8f86-96f4f14db33b`
**Tags data source:** `32ff8ed6-2b1b-49c9-b7cb-c542a69541d3`

Canonical tool names are the `mcp__notion__API-*` set (per NOTION.md §3). On a work machine with no MCP,
use the equivalent REST endpoints from NOTION.md §3.

---

## Step 1 — Capture session metadata (never fabricate)

Collect the origin payload. This is what makes the Project resumable and traceable back to how the
session started. Each field is read from context or explicitly marked `Unclear` — never invented.

| Field | Source | If unavailable |
|---|---|---|
| **AI system** | The harness in use — `Claude Code`, `Cursor`, etc. | `Unclear` |
| **model** | Environment/system context (e.g. `claude-opus-4-8`) | `Unclear` |
| **conversation / session name** | The session `-n/--name` if one was set | `Unclear` |
| **session ID** | The transcript URL in context: `https://claude.ai/code/session_<id>` → `<id>` | `Unclear` — and omit the resume command entirely (NOTION.md §6: omit rather than fabricate) |
| **resume command** | `claude --resume <session-id>` (+ `claude --resume "<name>"` when a name is set) | omit if no session ID |
| **transcript link** | `Session transcript: https://claude.ai/code/session_<id>` | omit if no session ID |

Build the **Origin / Session** block once, as a Notion callout, in this fixed field order:

```
> **Origin / Session**
> - AI system: <Claude Code | Cursor | Unclear>
> - Model: <model | Unclear>
> - Session name: <name | Unclear>
> - Session ID: <id | Unclear>
>
> ```
> claude --resume <session-id>
> claude --resume "<session-name>"   # only if a name is set
> ```
> Session transcript: https://claude.ai/code/session_<id>
```

The transcript URL is also written to the Project's `Link` property so it is queryable.

---

## Step 2 — Resolve create vs. link (deterministic rule)

Apply in order; the first match wins so identical inputs always take the same branch:

1. **Explicit Notion Project URL** present in the conversation → **link** that page.
2. Else query the Projects data source and normalize candidate names + the conversation's topic string
   (lowercase, trim, collapse internal whitespace):
   - **Exactly one** normalized-name match → **link** it.
   - **Multiple** matches, or only a **weak/partial** match → **create new**; list the near-match
     candidates (name + `https://app.notion.com/p/<hex-id>` URL) in the Step 4 comment for traceability.
   - **Zero** matches → **create new**.

Never link on a guess — ambiguity always resolves to create-new-with-candidates-noted.

---

## Step 3a — Create path

**Read first:** query the Projects data source (confirm it's reachable) before creating.

**Template selection (deterministic):** call `mcp__notion__API-list-data-source-templates` on the Projects
data source. Infer the conversation nature as a single lowercase keyword (e.g. `research`, `engineering`,
`design`, `planning`). If exactly one template name contains that keyword → create the page from that
template, then fill the sections below into it. Otherwise → use the built-in body below. If listing
templates fails, fall back to the built-in body (do not block).

**Body order (top → bottom) — matches NOTION.md "Project Page Structure":**
1. The **Origin / Session** callout from Step 1.
2. `## Problem Statement / Goal` — 1–2 sentences summarized from the conversation if there is enough
   content (summarization of present data is allowed); otherwise the literal placeholder
   `_Unclear — to be filled in._`.
3. `## Notes` — working context, if any; omit the section if empty.
4. `## General next steps` — concrete next steps if inferable, else a single placeholder bullet
   `- [ ] _To be determined._`. This section is always last.

**Properties:**
- `Name`: the session name; else a concise inferred title from the topic; else `Session <session-id-or-date>`.
- `Status`: `next-up` (fixed).
- `Link`: the transcript URL (omit if no session ID).
- `Area of Focus`: link **only** an exact existing match (default "Work" on a work machine); else leave blank.
- `Tags`: link **only** exact existing Tag pages. **Never auto-create Tags** — leave blank rather than pollute.
- `Week`: link the current active Week — query the Weeks data source for the row whose `Active` formula is
  true, then link it (Projects related to a Week appear in weekly goals). Skill default; skip if no active
  Week is found. To disable, remove this line.

Create via `mcp__notion__API-post-page` with `parent: { data_source_id: "e751bb01-362f-498f-b2b4-aa2e55f081f8" }`.
All relation properties are passed as JSON-array strings of full `https://app.notion.com/p/<hex-id>` URLs
(a bare ID silently fails to link — see daily-debrief and NOTION.md §3).

---

## Step 3b — Link path

1. **Read before write** (NOTION.md §5): `mcp__notion__API-retrieve-page-markdown` for the page body **and**
   `mcp__notion__API-retrieve-a-comment { block_id: <page_id> }` for the running comment thread.
2. **Idempotency (session-ID keyed):** if this session ID already appears anywhere in the page body or
   comments, do **not** re-add the Origin block — skip straight to Step 4. This is what keeps re-runs from
   duplicating metadata.
3. Otherwise, fill only what's missing, in place, without overwriting existing content:
   - If the page has no Origin block, append it (via `API-update-page-markdown`, append-only).
   - If the `Link` property is empty, set it to the transcript URL (`API-patch-page`).
   - Do not touch `Status`, `Problem Statement`, or `General next steps` on the link path unless Zach
     explicitly asks — those are the human's.

---

## Step 4 — Timestamped status comment (every run)

Always post one top-level comment via `mcp__notion__API-create-a-comment { parent: { page_id }, rich_text: [...] }`,
whether the run created or linked the Project. Comment body, in order:

```
<local timestamp> — <one line: "Created from <AI system> session" or "Linked <AI system> session">

claude --resume <session-id>
Session transcript: https://claude.ai/code/session_<id>

<optional: near-match candidates that were NOT linked, each with its Notion URL>
```

Read the existing thread first (already done on the link path) so the comment doesn't repeat prior logs.
If no session ID is available, omit the resume/transcript lines rather than fabricate them.

---

## Determinism & no-fabrication rules

- Fixed field order in the Origin block; fixed `next-up` status; `Problem Statement / Goal` first and
  `General next steps` last, always.
- Create-vs-link and template selection are rule-based (Steps 2 and 3a) — identical inputs, identical branch.
- Idempotent on session ID: no duplicate Origin blocks or redundant comments across re-runs.
- Link only exact existing Tags / Areas of Focus; never auto-create them.
- Never invent model, session ID, name, or AI system — read from context or write `Unclear` and omit the
  resume command.

---

## Failure handling

- Read before every write (NOTION.md §3). If a read fails, retry once, then proceed only if safe.
- If a Notion write fails, surface the error **and** the full content that would have been written, so Zach
  can paste it manually. Never silently drop the sync (mirror daily-debrief).
- Notion writes need no permission prompt — "act, then notify" (NOTION.md §4).

## Tone

Executive, terse. No emojis, no em dashes. State what was created or linked and give the Notion URL.
