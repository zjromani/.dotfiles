# Notion Constitution

Single source of truth for how AI agents understand and operate on Zach's Notion workspace. Loaded on every machine via the global `CLAUDE.md` reference — read this before any Notion read/write.

## 1. Overview

This document defines the structure of Zach's Notion databases and the rules AI agents must follow when querying or updating them, so Notion remains the single source of truth and no agent — on any machine, in any session — silently clobbers existing data.

## 2. Database Schema

**Time** (`fbfbe24e-db66-4a24-9782-28d6d919f5f6`) — parent wiki page holding two child databases. Used for quarters, weeks, and years; **weeks are the primary unit for active weekly goals.**

- **Quarters** (`d5b1c6c2-6bf5-4df5-b83d-2f5adf407efb`, data source `a6dfcab7-a3e4-4484-a383-80e6345f8131`)
  - `Quarters` (title), `Time Span` (date), `Active` (formula: is today within span), `Quarter Goals` (relation → Projects; synced as `Quarter` on Projects), `Work Notes` (rich text)
- **Weeks** (`5e5f9517-e7e1-4d28-bee5-8fab01e96b3e`, data source `7dd17d1f-1cf3-4281-8f86-96f4f14db33b`)
  - `Weeks` (title), `Time Span` (date), `Active` (formula), `Project Goals` (relation → Projects; synced as `Week` on Projects), `Habits` / `Nutrition` / `Fitness` (star-rating selects), `Goals √` (rollup — % of linked Projects done), `Grade` (A–F select), `Rating Number` / `Rating Star` (formulas derived from Grade/Habits/Nutrition), `Notes`, `Work Notes`

**Home** — top-level landing page. Not a queryable database; no schema.

**Agendas** (`184cb18f-55d6-4c4d-8865-bb39fabb38a4`) — items tied to an audience that Zach needs to discuss.
- `Description` (title), `Audience` (relation → Audiences), `Type` (select: hit / miss / waiting / recurring), `Delivered` (checkbox)

**Areas of Focus** (`1c5cfb8c-7a31-429e-9dcd-8d5b7ba31e53`, data source `7e49eef0-a274-45f1-b2b3-e678ef004ac4`) — groupings of work, projects, and resources (e.g. "Work", "Finance", "Travel").
- `Title` (title), `Quadrat` (Eisenhower select: I Urgent&Important … IV Not Important&Not Urgent), `Projects` (relation), `Tags` (relation), `Related to Resources (Areas of Focus)` (relation → Resources)
- When working from work machine, always use the "Work" relationship when creating resources/projects

**Projects** (`aeed7f6e-20c3-4f80-8bf0-b1e555003360`, data source `e751bb01-362f-498f-b2b4-aa2e55f081f8`) — the places where work happens.
- `Name` (title)
- `Status` (status, grouped To-do / In progress / Complete: `some-day-maybe`, `next-up`, `waiting-for`, `in-progress`, `scheduled`, `delegated`, `done`, `missed`, `won't-do`)
- Relations: `Area of Focus`, `Quarter`, `Week`, `Tags`, `Resources`, `Audience`, `Sub-items` / `Initiative` (self, parent-child), `Blocked by` / `Blocking` (self)
- `Due` (date), `Urgent` (checkbox), `Importance` (select: high/med/low), `Priority` (formula), `Until` (formula, emoji urgency indicator), `Active` (rollup from Week)
- `Linear` (url), `Link` (url), `Points` (select), `Stars` (select), `Notes` (rich text)
- Projects are used for weekly goals when related to a week

**Resources** (`6092281c-2b5d-4d16-9dd3-020315e74a8d`, data source `069c35d1-ea27-492b-a54f-373b02af84b3`) — linked to projects or stand-alone references supporting an area of focus.
- `Name` (title), `Description` (rich text), `Project` / `Area of Focus` / `Tags` / `Audiences` (relations), `Link` (url), `File` (files), `Archived` (checkbox)

**Tags** (`c989c058-7ea3-404e-bbe6-0741579bb007`, data source `32ff8ed6-2b1b-49c9-b7cb-c542a69541d3`) — flexible long-term highlights not tied to a specific project (e.g. "Golf", "My Car"). Car-maintenance items surface via a Tag's `Projects` / `Areas of Focus` relations, not a dedicated property.
- `Name` (title), `Projects` (relation), `Areas of Focus` (relation), `Related to Resources (Tags)` (relation → Resources), `Favorite` (checkbox), `Resource Count` / `Project Count` (rollups), `Total Count` (formula)

**Audiences** (`64440b6a-da45-48e0-8e0d-7a19bcc4117c`, data source `b4f46865-90a0-4ffd-98cc-1944e81ea48d`) who or where the conversation takes place. Can be a single person, group, or meeting.
- `Name` (title), `Type` (select: person / team / vendor / recurring-meeting), `Tags` (relation), `Date`, `Info` (rich text), `Related to Resources (Audiences)` (relation), `archived` (checkbox)

### Relationships

```
Quarters ──< Projects >── Weeks
                │
   ┌────────────┼────────────┬───────────┐
   ▼            ▼            ▼           ▼
Areas of     Resources    Tags        Audiences
 Focus  ◄──────┴──────────►│◄──────────►│
   │                        │            │
   └──── shared cross-links via Tags ────┘
                                          ▲
                                       Agendas
```

Projects sit at the center: linked to a Quarter and a Week (time), an Area of Focus, Tags, Resources, and an Audience. Resources link back to Project / Area of Focus / Tags / Audiences. Tags are the cross-cutting hub — a car-maintenance Project surfaces under the "My Car" Tag even without a direct field for it. Agendas link only to Audiences.

### Project Page Structure (body convention)

Every Project page follows the same top-to-bottom body shape so any session — human or agent — can read
it the same way:

1. **Problem Statement / Goal comes first.** A Project always opens with what it's trying to solve or
   achieve (`## Problem Statement / Goal`), high-level, a few sentences. If unknown, use the literal
   placeholder `_Unclear — to be filled in._` rather than inventing one.
2. Body / working notes in the middle.
3. **`## General next steps` comes last.** Every Project ends with this section — the running list of what
   to do next. If empty, a single placeholder bullet.

A newly created Project defaults to **`Status: next-up`**. Agent-created pages additionally carry an
Origin / Session block at the very top (see §6). Mechanics of how a conversation becomes a Project live in
the `notion-sync` skill; this section defines only the required shape.

## 3. API Interaction Model

**Standing rule — always read before writing, prefer append over replace.**
Retrieve the current page or block children before any write. Never blind-overwrite page content. Add new blocks/children to preserve what's already there; only overwrite a *property* in place when the property is explicitly meant to be replaced (e.g. `Status`, `Due`, a checkbox). This applies identically on both paths below.

### Personal machine — Notion MCP available

Registered per `claude/.claude/setup-mcps.sh` as an HTTP MCP server (`https://api.notion.com/v1/mcp`, `Authorization: Bearer $NOTION_API_KEY`, sourced from `~/.zshenv_private`). Use the connected `mcp__notion__*` tools:

```
# Find a database/page by title
API-post-search { query: "Projects", filter: { property: "object", value: "data_source" } }

# Query rows in a data source
API-query-data-source { data_source_id: "e751bb01-362f-498f-b2b4-aa2e55f081f8", filter: {...} }

# Read before writing
API-retrieve-a-page { page_id }
API-retrieve-page-markdown { page_id }

# Append/update after reading
API-update-page-markdown { page_id, ... }   # append content
API-patch-page { page_id, properties: { "Status": {...} } }   # property update
```

### Work machine — no MCP, raw REST

No `NOTION_API_KEY` is set there, so no MCP server is registered. Use a personal integration token (all requests need `Authorization: Bearer $NOTION_API_KEY` + a `Notion-Version` header) directly against `https://api.notion.com/v1`.

**Version header matters.** `/data_sources/*` endpoints require `Notion-Version: 2025-09-03` — under `2022-06-28` they fail with `400 invalid_request_url` (verified 2026-07-26). Everything else in the table below works under either. Default to `2025-09-03`.

Full endpoint inventory (all cursor-paginated where they list things):

| Resource | Endpoints |
|---|---|
| Pages | `GET/POST /pages`, `PATCH /pages/{id}`, `GET /pages/{id}/properties/{property_id}` |
| Databases / data sources | `GET /databases/{id}`, `PATCH /databases/{id}` (database-level attrs, e.g. `icon` — see Section 8), `POST /data_sources/{id}/query`, `PATCH /data_sources/{id}` |
| Blocks | `GET /blocks/{id}`, `GET /blocks/{id}/children`, `PATCH /blocks/{id}/children` (append), `PATCH /blocks/{id}`, `DELETE /blocks/{id}` |
| Comments | `GET /comments?block_id={id}`, `POST /comments` — works on **both pages and blocks** |
| Search | `POST /search` |
| Users | `GET /users`, `GET /users/{id}`, `GET /users/me` |

```bash
# Query a data source
curl -X POST https://api.notion.com/v1/data_sources/e751bb01-362f-498f-b2b4-aa2e55f081f8/query \
  -H "Authorization: Bearer $NOTION_API_KEY" \
  -H "Notion-Version: 2022-06-28" -H "Content-Type: application/json" \
  -d '{"filter": {...}}'

# Read before writing
curl https://api.notion.com/v1/pages/{page_id} -H "Authorization: Bearer $NOTION_API_KEY" -H "Notion-Version: 2022-06-28"
curl https://api.notion.com/v1/blocks/{page_id}/children -H "Authorization: Bearer $NOTION_API_KEY" -H "Notion-Version: 2022-06-28"

# Append after reading (never PUT/replace)
curl -X PATCH https://api.notion.com/v1/blocks/{page_id}/children \
  -H "Authorization: Bearer $NOTION_API_KEY" -H "Notion-Version: 2022-06-28" -H "Content-Type: application/json" \
  -d '{"children": [{"paragraph": {"rich_text": [{"text": {"content": "..."}}]}}]}'
```

### Comments — for long-running project updates

Comments are the right tool for incremental status updates on a Project/Resource that runs over weeks — they append to a chronological thread without touching page body content, so no read-modify-write of the body is needed.

- **Read:** MCP `API-retrieve-a-comment { block_id: <page_or_block_id> }`; REST `GET /comments?block_id={id}`. Returns the thread in ascending chronological order.
- **Write:** MCP `API-create-a-comment { parent: { page_id }, rich_text: [...] }`; REST `POST /comments` with the same body shape (`parent: {page_id}` or `{block_id}`).
- Comments attach to a page or any block within it. There is no reply/resolve endpoint — every write starts a new top-level comment (or continues a thread via `discussion_id` if the API returns one from a prior read).
- Still read the existing thread before posting, so an update doesn't repeat what's already logged.

### Worked pattern: relation-linking and page creation

Follow the convention already proven in `claude/.claude/skills/daily-debrief/SKILL.md`:
1. Search for an existing related entity (e.g. a Tag) by name first.
2. If found, build its full page URL as `https://app.notion.com/p/<hex-id>` (never pass a bare ID into a relation property — it silently fails to link).
3. If not found, create the entity first, then link it the same way.
4. Only after resolving relations, create/append the target page's content.

## 4. Automation Rules

- Conversational requests ("mark X done", "add this under Auto") sync to Notion automatically. **Notion writes do not require a permission prompt** — they follow the global CLAUDE.md "act, then notify" posture, not "always ask first."
- Every write is preceded by a read of the target page or data source (Section 3's standing rule).
- New page content defaults to appended blocks; property fields (`Status`, `Due`, relations, checkboxes) are the only fields updated in place.
- Relation linking always searches for an existing Tag/Area/Audience/entity before creating a new one — never duplicate.
- If a write fails, surface the error and the content that would have been written rather than silently dropping it.
- **Working on a Project always ends with a top-level status comment on that Project page** (current state + next step) — see Section 5.

## 5. Notion Link = Source of Truth (Session Continuity)

When a task hands you a Notion page URL (a Project, Resource, etc.), treat that page as the authoritative, resumable state for the work — not this conversation.

- **On pickup:** read the full page (`API-retrieve-page-markdown` / `GET /pages/{id}` + `/blocks/{id}/children`) *and* its comment thread (`API-retrieve-a-comment` / `GET /comments?block_id={id}`) before doing anything else. The comment thread is the running log of prior sessions' progress and decisions.
- **While working:** log meaningful progress, decisions, or blockers as a comment on the page, not buried only in chat — that's what makes it pickable-up from a different session later.
- **Always, at the end of any work on a Project:** post a top-level comment with the current status and next step — not just on handoff/pause. This is unconditional, not a judgment call, so a future session (or you, next week) can always resume from the page alone.
- This is in addition to, not instead of, normal property updates (`Status`, `Due`) — properties track state, comments track narrative history.

## 6. Linking Standard — Always Link Back to Origin

**Constitutional rule: every Notion write must carry enough links that the user can navigate back to where the work started, without depending on this conversation still existing.** This applies on top of — not instead of — the global `CLAUDE.md` "Evidence & Linking" rule, specialized for Notion.

Any time content is added to Notion (appended page blocks, a comment, a Resource note) as a result of AI-assisted work, include:

1. **External references.** If the content is derived from or discusses an external source — a GitHub commit/PR/issue, a Slack thread, a doc, an article, an email — link the actual URL inline, next to the claim it supports. Never summarize a source without linking it.
2. **Claude Code session — resume command + transcript link, always both.** Any Notion page or comment written during a Claude Code CLI session gets, at the top of the page (or top of the comment for incremental updates), a fenced code block with the literal resume command:

   ```
   claude --resume <session-id>
   ```

   If the session was given a display name (`-n/--name`), also show the name form, since `--resume` accepts either a session ID directly or a search term that opens the `/resume` picker filtered to it:

   ```
   claude --resume "<session-name>"   # opens the /resume picker filtered to this name
   ```

   Directly below, add the transcript link using the same ID already emitted in git commit trailers (`Claude-Session:` footer): `Session transcript: https://claude.ai/code/session_<id>`.

   These two are complementary, not redundant: the resume command re-enters the live CLI conversation from any terminal; the transcript link opens a read-only browser view. Neither depends on the terminal multiplexer (tmux, screen, or otherwise) still being alive — the resume command works from a brand-new shell on the same machine, and the transcript link works from any device. If no session ID is available in the current context, omit rather than fabricate one.

   **Do not substitute** `claude-cli://` links or `--remote-control` links for this purpose — verified against this machine's Claude Code install on 2026-07-23: `claude-cli://<path>?q=<prompt>` is a real registered scheme, but it starts a *new* session pre-filled with a prompt and cannot target a past session's UUID, and the installed handler app bundle looked incomplete when tested (declares an executable that isn't present in the bundle). `--remote-control` is a real flag for live browser/mobile control of a session, but the link only works while that session's process is still running and dies once the terminal closes — same fragility as a raw tmux pane reference, just remote. Both remain fine for other uses (quick-launch runbook links, phone-driven babysitting of an active run) but are not a substitute for the resume command above.
3. **Notion-to-Notion back-references.** If the write is itself a continuation of prior work on another Notion page (a related Project, a source Resource), link that page's URL too, per Section 5's `https://app.notion.com/p/<hex-id>` convention.

Where this lands in existing content:
- **Comments** (Section 3 "Comments" pattern, Section 5 status comments): resume command + transcript link go at the top of the comment body; other links inline where they support a claim.
- **New page content**: resume command + transcript link go at the very top of the page, before any other content; source links inline in the relevant paragraph/bullet.
- **Does not apply** to pure property updates (`Status`, `Due`, checkboxes) with no accompanying narrative — there's nothing to link back to.

### Conversation-origin standard (Projects created/linked from an AI session)

When a Project is created from — or linked to — an AI conversation, record enough about the session's
origin that the work is traceable back to how it started, independent of the chat. In addition to the
resume command + transcript link above, capture these four fields in a top-of-page **Origin / Session**
callout, in this order:

- **AI system** — `Claude Code`, `Cursor`, etc.
- **Model** — e.g. `claude-opus-4-8`.
- **Session name** — the session's `-n/--name`, if one was set.
- **Session ID** — the `<id>` from `https://claude.ai/code/session_<id>`.

Also write the transcript URL into the Project's `Link` property so it's queryable. Any field that can't
be read from context is written `Unclear` — never fabricated (and with no session ID, omit the resume
command per the rule above). The `notion-sync` skill implements this; this section defines the required
payload and placement.

## 7. Example Prompts

- "Mark the car inspection project done and log a resource note under Auto." → read Project page → update `Status` to `done` → append a Resource linked to the `Auto` Area of Focus. (MCP: `API-patch-page` + `API-post-page`; REST: `PATCH /pages/{id}` + `POST /pages`)
- "What's on this week's goals that's still not-started?" → query current Week's `Project Goals` relation, filter Projects by `Status` in `{next-up, waiting-for}`. (MCP: `API-query-data-source`; REST: `POST /data_sources/{id}/query`)
- "Add a new Agenda item for my 1:1 with [Audience] about Q3 planning." → search Audiences for `[Audience]` → create Agenda row linked to it. (MCP: `API-post-search` + `API-post-page`; REST: `POST /data_sources/{agendas_id}/query` search + `POST /pages`)
- "Create a Resource under the 'Golf' tag linking this article." → search Tags for `Golf` (create if absent) → read Resources data source → append new Resource row linking the Tag. (MCP: `API-post-search` + `API-post-page`; REST: search query + `POST /pages`)
- Given `https://app.notion.com/p/<project-id>`, "keep working on this" → read the page + comment thread first → do the work → log progress as a comment before ending. (MCP: `API-retrieve-page-markdown` + `API-retrieve-a-comment` + `API-create-a-comment`; REST: `GET /pages/{id}` + `GET /comments?block_id={id}` + `POST /comments`)

## 8. Visual Icon Policy

Every database, top-level page, and page template gets an emoji icon. Notion's native icon library *does* read back over the API — a database using one returns `"icon": {"type": "icon", "icon": {"name": "briefcase", "color": "gray"}}` on `GET` — but only the `emoji`, `external`, `file`, and `custom_emoji` icon types are documented as writable, and writing an `{"type": "icon", ...}` payload has not been tested here. Use emoji until that's verified. One emoji per functional category, reused consistently:

| Category | Emoji | Sub-items / templates |
|---|---|---|
| Time (parent wiki page) | ⏳ | — |
| Quarters | 📆 | — |
| Weeks | 🗓️ | — |
| Home (top-level page) | 🏠 | — |
| Work (Area of Focus) | 💼 | — |
| Agendas | 🗒️ | — |
| Areas of Focus | 🧭 | — |
| Projects | 🚀 | Initiative 🏔️, Milestone 🏁, Travel ✈️, Study 📘, Tech Study 💻, Weekly Goal 🎯, Repeating Task 🔁 |
| Resources | 🗂️ | Interview 🎙️, Tech Design 🛠️, Budget 💰 |
| Tags | 🏷️ | — |
| Audiences | 👥 | — |

**Rule for new pages/templates.** Match the closest existing category's emoji before inventing a new one. Sub-items and templates listed in the table use their own emoji; anything not listed inherits the parent category's. If you do invent a new emoji, add its row to this table in the same change.

**Scope.** Containers — databases, top-level pages, page templates — always get an icon.

**Project rows also get icons.** Every Project not in a closed state (`in-progress`, `next-up`, `waiting-for`, `scheduled`, `delegated`) carries an emoji from the Projects palette above. Closed states (`done`, `won't-do`, `missed`) and `some-day-maybe` are left alone — they're the overwhelming bulk of the database and icons there are noise. When a Project moves into a live status, give it an icon then.

Assigning a Project's emoji:

1. **Never overwrite an existing emoji.** Emoji already on a Project are deliberate — as of 2026-07-26 the database carried 106 distinct ones, nearly all used once or twice. Only fill in rows with no icon or with a generic native default (`folder`, `checklist`, `gradebook`, `passport`, `reorder`, `calendar`).
2. **Two native defaults carry real signal** and translate directly: `gradebook` → 📘 Study, `passport` → ✈️ Travel.
3. **Otherwise pick semantically from the palette above** — books → 📘, trips/visas/travel logistics → ✈️, technical/tooling work → 💻, money/reimbursements/accounts → 💰, hiring and interview process → 🎙️, anything scoped to a single week → 🎯.
4. **A Project with sub-items is an Initiative** → 🏔️, unless a stronger category applies (a book with reading sub-items is still 📘).
5. **Everything else gets 🚀.** Don't invent an emoji outside the palette to make a single row more expressive — the palette is what makes the board scannable.

**Rule for agent writes.** When creating a new database, top-level page, or page template, set an icon at creation time using this mapping — don't leave default/no icon. For database-level icons specifically, use the REST `PATCH /databases/{id}` endpoint, not the MCP tool's icon field — on the databases tested it returned success without changing the icon (2026-07-26).

```bash
curl -X PATCH https://api.notion.com/v1/databases/{database_id} \
  -H "Authorization: Bearer $NOTION_API_KEY" \
  -H "Notion-Version: 2022-06-28" -H "Content-Type: application/json" \
  -d '{"icon": {"type": "emoji", "emoji": "🚀"}}'
```

Read the database first (`GET /databases/{id}`) per Section 3's standing rule. After the PATCH, a 200 is *not* confirmation — `GET` again and check `.icon` actually changed before moving on. Several of the emoji above carry a `U+FE0F` variation selector (🗓️ 🗒️ 🏔️ ✈️ 🗂️ 🎙️ 🛠️ 🏷️); multi-codepoint emoji are the likeliest to be normalized or rejected, which is what the read-back catches.
