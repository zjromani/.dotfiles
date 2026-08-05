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

**Projects database:** `aeed7f6e-20c3-4f80-8bf0-b1e555003360` (data source id `e751bb01-362f-498f-b2b4-aa2e55f081f8`)
**Areas of Focus data source:** `7e49eef0-a274-45f1-b2b3-e678ef004ac4`
**Weeks data source:** `7dd17d1f-1cf3-4281-8f86-96f4f14db33b`
**Tags data source:** `32ff8ed6-2b1b-49c9-b7cb-c542a69541d3`

Canonical tool names are the `mcp__notion__API-*` set (per NOTION.md §3). On a work machine with no MCP,
use the equivalent REST endpoints from NOTION.md §3.

**Known issue — data-source endpoints are unusable:** `API-query-data-source` and
`API-retrieve-a-data-source` both fail with `400 invalid_request_url` for every data source ID tested
(Projects, Tags), even though the IDs themselves are valid. Confirmed via `API-retrieve-a-database`, which
works and reports back the same data-source IDs recorded above. This is a client-side malformed-request
error (not an auth/permissions response), so it points at the tool wrapper's handling of the newer
multi-source endpoint shape rather than the Notion integration's grants. Until it's fixed, use the
**database-id path** everywhere below instead of the data-source path:
- Read/verify a database: `API-retrieve-a-database { database_id }`.
- Query/match existing pages: there is no working query-by-database tool — use `API-post-search { query }`
  (title search) and filter the results client-side to `parent.database_id == "aeed7f6e-..."`. `API-post-search`
  responses can be very large (property schemas are verbose); if a call reports a huge result, save it to a
  file and grep for the title/id fields rather than reading it inline.
- Create a page: `API-post-page` with `parent: { database_id: "aeed7f6e-20c3-4f80-8bf0-b1e555003360" }`
  (NOT `data_source_id` — that parent shape depends on the same broken code path).
- `API-list-data-source-templates` also takes a data-source id and is unverified under this bug; if it
  fails, fall back to the built-in body per Step 3a without blocking.

---

## Step 1 — Capture session metadata (never fabricate)

Collect the origin payload. This is what makes the Project resumable and traceable back to how the
session started. Each field is read from context or explicitly marked `Unclear` — never invented.

| Field | Source | If unavailable |
|---|---|---|
| **AI system** | The harness in use — `Claude Code`, `Cursor`, etc. | `Unclear` |
| **model** | Environment/system context (e.g. `claude-opus-4-8`, `Cursor Grok 4.5`) | `Unclear` |
| **conversation / session name** | The session `-n/--name` if one was set | `Unclear` |
| **session ID** | Claude: transcript URL `https://claude.ai/code/session_<id>` → `<id>`. Cursor: agent transcript UUID from the current conversation's transcript path (e.g. `…/agent-transcripts/<uuid>/<uuid>.jsonl` → `<uuid>`). | `Unclear` — and omit the resume/transcript lines entirely (NOTION.md §6: omit rather than fabricate) |
| **resume command** | Claude only: `claude --resume <session-id>` (+ `claude --resume "<name>"` when a name is set) | omit if no Claude session ID |
| **transcript link** | Claude only: `Session transcript: https://claude.ai/code/session_<id>` | omit if no Claude session ID |

Build the **Origin / Session** block once per sync run, in this fixed field order. **Do not use a
blockquote (`>`) and do not nest a fenced code block inside anything** — this MCP server's
markdown→block converter turns each `>`-prefixed line into its own separate quote block instead of one
multi-line callout, and mangles fenced code nested inside one (confirmed: renders as a stack of
one-line quotes plus stray backtick lines). Use a plain bold header line, a plain bullet list, and
inline code (single backticks) for the resume commands instead:

```
**Origin / Session**
- AI system: <Claude Code | Cursor | Unclear>
- Model: <model | Unclear>
- Session name: <name | Unclear>
- Session ID: <id | Unclear>
- Resume: `claude --resume <session-id>` (or `claude --resume "<session-name>"` when a name is set)
- Session transcript: https://claude.ai/code/session_<id>
```

Omit the Resume and Session transcript bullets when the AI system is not Claude Code, or when no
session ID is available. For Cursor, still include AI system / Model / Session name / Session ID
(using the agent transcript UUID when known).

**Always record the current session.** Every sync run must write this Origin block for *this*
conversation — create path puts it at the top of a new page; link path appends it even when earlier
sessions (other AI systems or prior chats) already have Origin blocks on the page. Multiple Origin
blocks stacked at the top are expected and correct. A page that started in Claude Code and later
continues in Cursor should carry both Origin blocks so either session remains discoverable from Notion.

On create, the Claude transcript URL (when present) is also written to the Project's `Link` property
so it is queryable. On link, only fill `Link` if it is empty — never overwrite an existing transcript.

---

## Step 1b — Capture source links (every run, never skip)

Every external resource link that was pasted into the conversation as context, or that was explicitly
fetched as primary source material, gets synced to the page — not just summarized around. This includes
Slack permalinks, Google Drive/Docs/Sheets/Slides links, Jira/Linear/Confluence links, Figma links, or any
other URL Zach shared or the agent fetched to do the work. Do not include incidental links that only appear
*inside* fetched content (e.g. a hyperlink quoted from within a doc) — only the top-level sources the
conversation was actually built on.

Render as a `## Source Links` section, one bullet per link, in the order they appeared in the conversation:

```
## Source Links
- <short label> — <url>
```

**Idempotency is per-URL, not per-session-ID:** on every sync (create or link), diff the links gathered
this run against what's already in the `## Source Links` section (if the section doesn't exist yet, create
it) and append only the URLs not already present. Source Links and Origin blocks are independent
idempotency checks — always run both.

Position: after `## Problem Statement / Goal`, before `## Notes` (see updated body order in Step 3a).

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

**Read first:** `API-retrieve-a-database { database_id: "aeed7f6e-20c3-4f80-8bf0-b1e555003360" }` (confirm
reachable) before creating.

**Template selection (deterministic):** call `mcp__notion__API-list-data-source-templates` on the Projects
data source ID. Infer the conversation nature as a single lowercase keyword (e.g. `research`, `engineering`,
`design`, `planning`). If exactly one template name contains that keyword → create the page from that
template, then fill the sections below into it. Otherwise → use the built-in body below. If listing
templates fails (including the known data-source bug above), fall back to the built-in body (do not block).

**Body order (top → bottom) — matches NOTION.md "Project Page Structure":**
1. The **Origin / Session** block from Step 1 (plain bold header + bullets, no blockquote).
2. `## Problem Statement / Goal` — 1–2 sentences summarized from the conversation if there is enough
   content (summarization of present data is allowed); otherwise the literal placeholder
   `_Unclear — to be filled in._`.
3. `## Source Links` from Step 1b — omit the section only if there were genuinely no source links this run.
4. `## Notes` — working context, if any; omit the section if empty.
5. `## General next steps` — concrete next steps if inferable, else a single placeholder bullet
   `- [ ] _To be determined._`. This section is always last.

**Properties:**
- `Name`: the session name; else a concise inferred title from the topic; else `Session <session-id-or-date>`.
- `Status`: `next-up` (fixed).
- `Link`: the transcript URL (omit if no session ID).
- `Area of Focus`: link **only** an exact existing match (default "Work" on a work machine); else leave blank.
- `Tags`: link **only** exact existing Tag pages. **Never auto-create Tags** — leave blank rather than pollute.
- `Week`: link the current active Week — find the row whose `Active` formula is true (subject to the same
  data-source query bug above; use `API-post-search` filtered to the Weeks database if a direct query
  fails), then link it (Projects related to a Week appear in weekly goals). Skill default; skip if no
  active Week is found. To disable, remove this line.

Create via `mcp__notion__API-post-page` with `parent: { database_id: "aeed7f6e-20c3-4f80-8bf0-b1e555003360" }`.
All relation properties are passed as JSON-array strings of full `https://app.notion.com/p/<hex-id>` URLs
(a bare ID silently fails to link — see daily-debrief and NOTION.md §3).

---

## Step 3b — Link path

1. **Read before write** (NOTION.md §5): `mcp__notion__API-retrieve-page-markdown` for the page body **and**
   `mcp__notion__API-retrieve-a-comment { block_id: <page_id> }` for the running comment thread.
2. **Always append this session's Origin block** (session-ID keyed idempotency only):
   - If this run's session ID is known **and** already appears anywhere in the page body or comments,
     do **not** re-add the Origin block (same session re-sync).
   - Otherwise **always append** a new Origin block for the current AI session — even when Origin
     blocks from other sessions/AI systems already exist. Do not treat "page already has an Origin
     block" as a reason to skip.
   - **Placement:** insert the new Origin block immediately after the last existing Origin block
     (header + its bullets), and before `## Problem Statement / Goal`. If there is no Origin block
     yet, insert it at the top of the page body. Via REST: `PATCH /blocks/{page_id}/children` with
     `after` set to the last Origin bullet's block id (or omit `after` / use the first content block
     as anchor when inserting at top). Via MCP: `API-update-page-markdown` append-only only works if
     it can target that position; otherwise use the blocks API.
   - If session ID is `Unclear`, still append once per sync run, but include enough of the Origin
     fields (AI system, model, local timestamp in the Step 4 comment) that a duplicate is obvious on
     a same-day re-run; do not invent an ID.
3. **Source Links (per-URL keyed, every run, regardless of the Origin check above):** collect every source
   link per Step 1b and diff against the page body. Append any URL not already present to `## Source Links`
   (create the section, right after `## Problem Statement / Goal`, if it doesn't exist yet).
4. Fill in what's missing, in place, without overwriting existing content:
   - If the `Link` property is empty and this run has a Claude transcript URL, set it
     (`API-patch-page`). Never overwrite a non-empty `Link`.
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

**Known issue — comment API returns 403 (integration capability, not an MCP bug):** `API-create-a-comment`
(and `API-retrieve-a-comment`) can return `403 restricted_resource: Insufficient permissions for this
endpoint`. This is a Notion API authorization response, not a transport/tool bug — it means the Notion
integration behind these tools has not been granted comment read/insert capability (a toggle on the
integration itself in Notion's settings, separate from content read/update). That capability is granted
per-integration, not per-database, so treat this as failing everywhere, not just on the Projects database.
If comment creation 403s, do not block or drop the log — append the same comment body as a paragraph under
`## Notes` in the page instead (via `API-update-page-markdown`, `update_content`), and say so in the note.
If no session ID is available, omit the resume/transcript lines rather than fabricate them.

---

## Determinism & no-fabrication rules

- Fixed field order in the Origin block; fixed `next-up` status; `Problem Statement / Goal` first and
  `General next steps` last, always. Origin blocks stack at the top (one per distinct session).
- Create-vs-link and template selection are rule-based (Steps 2 and 3a) — identical inputs, identical branch.
- **Always append the current session's Origin** on create and on link. Idempotent only on the same
  session ID: re-running sync for the *same* conversation must not duplicate that Origin; a different
  AI system or different conversation must add a new Origin block even if others already exist.
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
