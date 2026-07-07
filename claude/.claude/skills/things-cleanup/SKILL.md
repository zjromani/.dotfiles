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

## Analyze

Group all todos into four buckets:

**1. Combine candidates** — multiple todos clearly about the same topic (same project, same person, same domain). Show as a cluster.

**2. Project candidates** — single todos that describe multi-step work. Signal words: "set up", "plan", "figure out", "come up with", "get a plan", "create", "build", "research + decide", or anything that can't be done in one sitting. These should become Notion projects with only the first next action left in Things.

**3. Stale / low-signal** — vague ("do the thing"), very old (date in notes > 60 days), or clearly superseded. Flag for deletion or archiving.

**4. Keep as-is** — single clear actions, don't touch unless you see an area reassignment that makes sense.

## Present proposal

Show a numbered list. One proposal per line. Format:

```
COMBINE
  [1] "dryer service" + "call car shop for subaru" + "call for gutters" → consolidate into Phone Calls list (already there — just flag that 3 phone call todos exist)

PROJECT → NOTION
  [2] "figure out golf plan" (.me) → Notion project: "Golf — commit to lessons or Tee Box" (personal area)
  [3] "confluence docs → linear" (.work) → Notion project: "Migrate Confluence team docs to Linear" (work area)

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

## Gotchas

- AppleScript `tag names` returns a list; in the pipe-delimited output it renders as e.g. `.work, .me` — split on comma to get individual tags.
- `create-notion-work-project` opens the new page in Notion app via `open`. The `notion://` URL is printed to stdout — capture it with `$(...)`.
- The Areas of Focus database (`1c5cfb8c-7a31-429e-9dcd-8d5b7ba31e53`) is NOT accessible via the `NOTION_PROJECT_SECRET` integration token — don't try to query it. Only the projects DB (`aeed7f6e-20c3-4f80-8bf0-b1e555003360`) works.
- Things tasks inside Projects (not Areas) are not returned by the AppleScript above. This sweep covers area-level todos only.
