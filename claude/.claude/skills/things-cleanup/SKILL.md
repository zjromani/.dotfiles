---
name: things-cleanup
description: Review all active Things 3 todos and sweep for cleanup — flag items to combine, consolidate multi-step tasks into Notion projects, and remove noise. Interactive: presents findings, waits for confirmation before acting. Use when asked to "clean up todos", "sweep things", "review my tasks", "consolidate things".
---

# Things Cleanup

Interactive sweep of all active Things 3 todos. Reads every area, analyzes for patterns, presents a grouped proposal, then acts only on confirmed items.

## Read todos

```bash
osascript -e '
tell application "Things3"
  set output to ""
  set delim to ":::"
  repeat with a in areas
    set areaName to name of a
    set areaTodos to to dos of a
    if (count of areaTodos) > 0 then
      repeat with t in areaTodos
        set tName to name of t
        set tTags to (tag names of t) as string
        set tNotes to notes of t
        set output to output & areaName & delim & tName & delim & tTags & delim & tNotes & "
"
      end repeat
    end if
  end repeat
  return output
end tell'
```

Returns `:::` delimited rows: `area:::title:::tags:::notes`. Run this first, then analyze.

**Note:** Use `-e '...'` form, not a heredoc piped through another command — the `|` in a heredoc triggers an AppleScript syntax error.

## Check scheduling before flagging same-named todos

Before proposing **any** duplicate/combine on two or more todos that share an exact or near-identical title, check their activation and due dates — a repeating task can legitimately show two open instances at once (the live scheduled one + a stray leftover from before it had notes/links added, or the two adjacent cycles overlapping).

```bash
osascript -e '
tell application "Things3"
  set output to ""
  repeat with a in areas
    repeat with t in (to dos of a)
      if name of t is "EXACT_TASK_NAME" then
        set output to output & "---" & return
        set output to output & "area: " & (name of a) & return
        try
          set output to output & "activation date: " & (activation date of t) & return
        end try
        try
          set output to output & "due date: " & (due date of t) & return
        end try
      end if
    end repeat
  end repeat
  return output
end tell'
```

Rule: if **any** instance has a non-missing activation date or due date, treat the group as a recurring task, not a duplicate. Do not propose deleting either copy — instead note it as "recurring task, verify repeat settings in Things directly" and drop it from the COMBINE bucket entirely. Only propose a delete when **all** instances have no activation date and no due date (a true accidental duplicate).

**This rule is a hard stop, not a factor to weigh.** There is no "DUPLICATES — DELETE" bucket in this skill's proposal format — same-named todos only ever land in COMBINE (if truly undated) or get dropped from the proposal entirely (if any instance is dated). If the scheduling check returns a real date on any instance, do not reason further about which copy "looks" stale or unscheduled — stop and exclude the whole group from the proposal.

## Analyze

Group all todos into four buckets:

**1. Combine candidates** — two patterns:
   - *Same topic* — multiple todos clearly about the same project, person, or domain. Show as a cluster. Before including same-named todos here, run the scheduling check above.
   - *Same action-verb pattern* — multiple single-action todos in the same area/tag that share a verb pattern ("review X", "read X dtd", "watch X video") even when the topics differ, each carrying just one link and requiring only "read this + maybe respond." Signal: 3+ of these sitting in one area. Propose consolidating into **one parent task with a Things checklist** — one checklist line per item, all links preserved in the parent's Notes (one per line, matching the checklist order). Don't do this for todos that already have multi-step notes/history (e.g. a review with back-and-forth follow-up context) — those stay separate since they carry more state than a single line can hold.

**2. Project candidates** — single todos that describe multi-step work. Signal words: "set up", "plan", "figure out", "come up with", "get a plan", "create", "build", "research + decide", or anything that can't be done in one sitting. These should become Notion projects with only the first next action left in Things.

**3. Stale / low-signal** — vague ("do the thing"), very old (date in notes > 60 days), or clearly superseded. Before flagging, run the scheduling check above — a todo with a future activation date is scheduled on purpose and is never stale regardless of how old a date in its notes looks.

**4. Keep as-is** — single clear actions, don't touch unless you see an area reassignment that makes sense.

## Present proposal

Show a numbered list. One proposal per line. Format:

```
COMBINE
  [1] "dryer service" + "call car shop for subaru" + "call for gutters" → consolidate into Phone Calls list (already there — just flag that 3 phone call todos exist)

PROJECT → NOTION
  [2] "figure out golf plan" (.me) → Notion project: "Golf — commit to lessons or Tee Box" (personal area)
  [3] "confluence docs → linear" (.work) → Notion project: "Migrate Confluence team docs to Linear" (work area)

COMBINE → CHECKLIST
  [X] 7 single-link "review X" work todos (tiger team retro, bruce dtd, austin dtd reshop, peter PTD ledger, joao contract dtd, grhaam linear hygiene, neth dtd) → one parent task "Reviews" (.work) with a Things checklist, one line per review, links moved to parent Notes

STALE — DELETE?
  [4] "watch navan video from MK" — Mar 2026, likely stale
  [5] "set staff skip levels to quarterly" — no date, vague

KEEP
  (list briefly, no action needed)
```

**Do not act yet.** Present the full proposal and ask:
> "Confirm each by number (e.g. '1,3,5'), skip any, or give feedback. I'll execute approved items."

## Execute confirmed items

### Create Notion project (`.work`)

```bash
~/.dotfiles/bin/scripts/create-notion-work-project "Project Name"
```

This creates the project in the Weekly Goal Projects database, linked to the work Area of Focus (`c22807a3-242a-4183-b0c0-e6a94d44b83f`), status `in-progress`, importance `med`. Returns a `notion://` URL — add it to the Things task notes.

### Create Notion project (`.me` / personal)

```bash
~/.dotfiles/bin/scripts/create-notion-project "Project Name"
```

No area linked (Areas of Focus DB is not accessible via the integration token). Returns a `notion://` URL.

### Create a consolidated checklist task (combine → checklist)

```bash
osascript -e '
tell application "Things3"
  set newToDo to make new to do with properties {name:"Reviews", tag names:"work"}
  tell newToDo
    make new checklist item with properties {name:"Review tiger team retro notes, get back to Amadeo"}
    make new checklist item with properties {name:"Review Bruce DTD"}
    make new checklist item with properties {name:"Review Austin DTD reshop endpoint"}
    set notes to "Review tiger team retro notes, get back to Amadeo — https://linear.app/... | https://hotelengine.slack.com/...
Review Bruce DTD — https://github.com/HotelEngine/engine-architecture/pull/239
Review Austin DTD reshop endpoint — https://hotelengine.slack.com/..."
  end tell
end tell'
```

Move the parent to the right area afterward if needed (`move newToDo to area "🖥️ Computer"` in the same tell block, or a separate `move` command — Things area assignment via `make new to do with properties` does not reliably accept an `area` key in one step). One checklist line per original todo, in the same order as the Notes links, so they can be matched by position. Once created and verified, mark the original todos complete (see below) — don't delete their content until the consolidated task exists and has the links.

### Update Things task notes with Notion link

```bash
osascript -e '
tell application "Things3"
  repeat with a in areas
    repeat with t in (to dos of a)
      if name of t is "EXACT_TASK_NAME" then
        set notes of t to "notion://..." & return & (notes of t)
        return "updated"
      end if
    end repeat
  end repeat
end tell'
```

Replace `EXACT_TASK_NAME` with the exact task title and `notion://...` with the URL from the create script.

### Delete / complete a stale task

```bash
osascript -e '
tell application "Things3"
  repeat with a in areas
    repeat with t in (to dos of a)
      if name of t is "EXACT_TASK_NAME" then
        set status of t to completed
        return "done"
      end if
    end repeat
  end repeat
end tell'
```

## Constraints

- **Never act without confirmation.** Even if a todo is obviously stale, confirm first.
- **One proposal round.** Present everything at once, not piecemeal.
- **Don't rename tasks.** Only update notes (add Notion link) or mark complete.
- **Work tag `.work` → `create-notion-work-project`.** Everything else (`.me`, untagged) → `create-notion-project`.
- **AI Delegate area** — don't propose cleanup on these unless explicitly asked. They're tracked separately via `ai-delegate` workflow.
- **Waiting For + Follow Ups areas** — flag age but don't auto-delete. These often have context in notes.
- **Never flag same-named todos as duplicates without checking scheduling first** (see "Check scheduling before flagging same-named todos" above). A repeating task can show two open instances at once.
- **When consolidating same-verb-pattern todos into a checklist**, only merge single-link "read/review + respond" items. Keep separate anything with back-and-forth history or multiple links in its notes — that state doesn't compress into one checklist line.

## Gotchas

- AppleScript `tag names` returns a list; in the pipe-delimited output it renders as e.g. `.work, .me` — split on comma to get individual tags.
- `create-notion-work-project` opens the new page in Notion app via `open`. The `notion://` URL is printed to stdout — capture it with `$(...)`.
- Things' AppleScript `due date`/`activation date` return `missing value` when unset, but sometimes surface a sentinel garbage date instead (e.g. `Monday, January 1, 4001`) — treat any date wildly outside a plausible range as "no real date," not a stale-flag signal.
- The Areas of Focus database (`1c5cfb8c-7a31-429e-9dcd-8d5b7ba31e53`) is NOT accessible via the `NOTION_PROJECT_SECRET` integration token — don't try to query it. Only the projects DB (`aeed7f6e-20c3-4f80-8bf0-b1e555003360`) works.
- Things tasks inside Projects (not Areas) are not returned by the AppleScript above. This sweep covers area-level todos only.
