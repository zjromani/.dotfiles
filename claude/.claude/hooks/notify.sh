#!/usr/bin/env bash
# Notification hook — sends macOS notification with tmux window number.
# Usage: notify.sh "Claude finished" | notify.sh "Claude needs input"

MSG="${1:-Claude finished}"

WIN=$(tmux display-message -p -t "$TMUX_PANE" '#I' 2>/dev/null)
SESSION=$(tmux display-message -p -t "$TMUX_PANE" '#S / #W' 2>/dev/null || echo 'terminal')

printf '\a'
osascript -e "display notification \"[$WIN] $MSG\" with title \"Claude Code\" subtitle \"$SESSION\""
