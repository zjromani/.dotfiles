#!/usr/bin/env bash
# SessionStart hook — injects git context + Things3 tasks as system context.
# stdout is injected by Claude Code as a system message Claude sees at session start.

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

echo "## Session Context — $(date '+%Y-%m-%d %H:%M')"
echo ""

# --- Git context ---
if [ -n "$CWD" ] && cd "$CWD" 2>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null)
  echo "### Git"
  echo "Branch: ${BRANCH:-detached HEAD}"
  echo ""
  echo "Recent commits:"
  git log --oneline -5 2>/dev/null | sed 's/^/  /'
  echo ""

  DIRTY=$(git diff --stat HEAD 2>/dev/null)
  if [ -n "$DIRTY" ]; then
    echo "Working tree (dirty):"
    git status --short 2>/dev/null | sed 's/^/  /'
  else
    echo "Working tree: clean"
  fi
  echo ""
fi

# --- Things3 tasks ---
if pgrep -x "Things3" > /dev/null 2>&1; then
  TASKS=$(osascript <<'APPLESCRIPT' 2>/dev/null
tell application "Things3"
  set todayItems to to dos of list "Today"
  set output to ""
  repeat with t in todayItems
    set taskName to name of t
    set output to output & "- " & taskName & "\n"
  end repeat
  return output
end tell
APPLESCRIPT
  )
  if [ -n "$TASKS" ]; then
    echo "### Today's Tasks (Things3)"
    echo "$TASKS"
  fi
fi

exit 0
