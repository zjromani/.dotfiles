---
name: daily-debrief
description: End-of-day executive debrief for Zach. Pulls all meetings from the current day via Krisp MCP, synthesizes them into a structured briefing, and saves it as a new page in the Notion Resources database with a "daily_debrief" tag. Use this skill whenever Zach asks for a "daily debrief", "end of day summary", "EOD recap", "debrief my day", "what happened today", or any similar request to summarize the current day's meetings for his own record. Always trigger when Zach wants a structured daily recap. Requires Krisp and Notion MCPs.
---
# Daily Debrief Skill
Generates a structured end-of-day debrief by pulling all of today's meetings from Krisp and writing it as a new page in Zach's Notion Resources database.
---
## Step 1 — Anchor the date
Call `Krisp:date_time` with timezone `America/Denver` to get today's date and day of week.
**Monday exception:** If today is Monday, expand scope to cover Friday + Saturday + Sunday + Monday. Friday's meetings must be included with the same depth as Monday's — do not thin-summarize them.
For all other days: current calendar day only.
---
## Step 2 — Gather meeting data
Run these Krisp calls (can be parallel):
1. `Krisp:list_activities` — enumerate all activities in scope
2. `Krisp:search_meetings` — get all meetings in scope
3. For each meeting: `Krisp:get_multiple_documents` — pull full transcript/summary/notes
4. `Krisp:list_action_items` — pull all action items in scope (mine and others)
5. `Krisp:list_upcoming_meetings` — what's on calendar tomorrow (for Section 5)
If scope returns zero meetings: still write the Notion page — body should say "No meetings recorded in scope" and include only Section 5 (tomorrow prep).
---
## Step 3 — Write the debrief
Structure the content as Notion-flavored Markdown with these sections in this exact order:
### Section 1: TL;DR
3-5 bullets. Decisions made, blockers raised, direction changes. If nothing critical: say so plainly.
### Section 2: Meetings
Chronological order across the full scope.
**Monday only:** Group under day headers (## Friday / ## Monday).
For each meeting:
- **Title + time + attendees**
- What it was about (1 sentence)
- Key points discussed (3-6 bullets — substance, not topic labels)
- Decisions made (explicit list, or "None")
- Action items from this meeting (owner + deadline if mentioned)
- My takeaway (1-2 sentences: what this means for me as director)
### Section 3: My Action Items
Consolidated checklist across all meetings. Group by urgency: Today / This Week / Later. Include source meeting in parentheses.
Monday only: flag any Friday action items due over the weekend or first thing Monday as highest priority.
### Section 4: Patterns and Flags
Most important section. Look across ALL meetings together:
- **Recurring themes** — same topic in multiple meetings? Same person blocked twice?
- **Tensions or disagreements** — who and what specifically
- **Risks or red flags** — things that sounded small but could compound
- **Org/people signals** — anyone burned out, frustrated, disengaged, or unusually energized. Names that kept coming up.
- **Decisions I'm avoiding** — places where a decision was needed but got punted
- **Threads across days** (Mondays only) — Friday items that resurfaced or should have been picked up today but weren't
If the day was clean: "No patterns of note." That's a valid output.

Also query the Executive Circle MCP for relevant articles and guides on the patterns surfaced. Include a subsection on how to move forward as a modern AI-development engineering org, drawing from those resources.
### Section 5: Tomorrow Prep
Cross-reference today's action items and decisions with tomorrow's upcoming meetings. For each meeting tomorrow:
- What from today is relevant?
- What should I walk in already knowing or having decided?
- Any prep to do tonight?
### Section 6: One Question
End with a single sharp question to sit with tonight. Something the conversations surfaced that hasn't been answered yet. Specific and uncomfortable — not generic.
---
## Step 4 — Write to Notion
**Target:** Resources database, data source `collection://069c35d1-ea27-492b-a54f-373b02af84b3`
**Title format:** `Daily Debrief — YYYY-MM-DD` (today's date in America/Denver, ISO format)
**Tag:** The page must be linked to the `daily_debrief` tag in the Tags relation.
### Tag handling
Search for an existing `daily_debrief` tag page in the Tags data source (`collection://32ff8ed6-2b1b-49c9-b7cb-c542a69541d3`) first using `Notion:notion-search`.
- If found: construct the full page URL as `https://app.notion.com/p/<url>` where `<url>` is the `url` field from the search result (a bare hex ID, e.g. `3438018f8f7b81cd884eef1f45393485`). Never use the bare ID directly — always prepend the prefix.
- If not found: create it via `Notion:notion-create-pages` under the Tags data source with `Name: "daily_debrief"`, then construct its URL the same way from the `url` field of the returned page object.
### Page creation call
Use `Notion:notion-create-pages` with:
```
parent: { data_source_id: "069c35d1-ea27-492b-a54f-373b02af84b3" }
pages: [{
  properties: {
    "Name": "Daily Debrief — YYYY-MM-DD",
    "Tags": "[\"https://app.notion.com/p/<tag_page_id>\"]"
  },
  content: "<full debrief in Notion Markdown>"
}]
```
The Tags property is a relation. Always pass it as a JSON array string with a full URL in the format `https://app.notion.com/p/<hex-id>`. A bare ID without the prefix will silently create the page without the relation linked.
---
## Step 5 — Confirm
After the Notion page is created, confirm to Zach with:
- The page title
- A direct link to the new Notion page (from the returned `url`)
---
## Failure handling
- If Krisp returns errors: retry once. If still failing, write the Notion page anyway. Explain in the body that Krisp data was unavailable and what failed. Still create the page with the correct title.
- If Notion write fails: surface the error to Zach with the full debrief content so he can paste it manually.
- Never silently drop the debrief.
---
## Tone
Executive brief, not a transcript dump. Direct, substantive, no filler. No cheerleading. No emojis. No em dashes. If something was a waste of time, say so plainly. Quote people when the specific phrase matters. Otherwise paraphrase tightly.
