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

No `NOTION_API_KEY` is set there, so no MCP server is registered. Use a personal integration token (all requests need `Authorization: Bearer $NOTION_API_KEY` + `Notion-Version: 2022-06-28`) directly against `https://api.notion.com/v1`. Full endpoint inventory (all cursor-paginated where they list things):

| Resource | Endpoints |
|---|---|
| Pages | `GET/POST /pages`, `PATCH /pages/{id}`, `GET /pages/{id}/properties/{property_id}` |
| Databases / data sources | `GET /databases/{id}`, `POST /data_sources/{id}/query`, `PATCH /data_sources/{id}` |
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

## 6. Example Prompts

- "Mark the car inspection project done and log a resource note under Auto." → read Project page → update `Status` to `done` → append a Resource linked to the `Auto` Area of Focus. (MCP: `API-patch-page` + `API-post-page`; REST: `PATCH /pages/{id}` + `POST /pages`)
- "What's on this week's goals that's still not-started?" → query current Week's `Project Goals` relation, filter Projects by `Status` in `{next-up, waiting-for}`. (MCP: `API-query-data-source`; REST: `POST /data_sources/{id}/query`)
- "Add a new Agenda item for my 1:1 with [Audience] about Q3 planning." → search Audiences for `[Audience]` → create Agenda row linked to it. (MCP: `API-post-search` + `API-post-page`; REST: `POST /data_sources/{agendas_id}/query` search + `POST /pages`)
- "Create a Resource under the 'Golf' tag linking this article." → search Tags for `Golf` (create if absent) → read Resources data source → append new Resource row linking the Tag. (MCP: `API-post-search` + `API-post-page`; REST: search query + `POST /pages`)
- Given `https://app.notion.com/p/<project-id>`, "keep working on this" → read the page + comment thread first → do the work → log progress as a comment before ending. (MCP: `API-retrieve-page-markdown` + `API-retrieve-a-comment` + `API-create-a-comment`; REST: `GET /pages/{id}` + `GET /comments?block_id={id}` + `POST /comments`)
