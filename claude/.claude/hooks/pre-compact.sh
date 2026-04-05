#!/usr/bin/env bash
# PreCompact hook — writes a checkpoint to ~/.claude/checkpoints/ before context compression.
# Filename: {label}_{timestamp}.md
# Label priority: /rename session name → tmux session/window → session_id[:8]

set -euo pipefail

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')
SESSION_NAME=$(echo "$INPUT" | jq -r '.session_name // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

TIMESTAMP=$(date '+%Y-%m-%dT%H-%M-%S')
CHECKPOINT_DIR="$HOME/.claude/checkpoints"
mkdir -p "$CHECKPOINT_DIR"

# Resolve label: session_name → tmux → session_id[:8]
if [ -n "$SESSION_NAME" ]; then
  LABEL="$SESSION_NAME"
elif [ -n "$TMUX_PANE" ]; then
  LABEL=$(tmux display-message -p -t "$TMUX_PANE" '#S-#W' 2>/dev/null || echo "")
fi

if [ -z "${LABEL:-}" ]; then
  LABEL="${SESSION_ID:0:8}"
fi

# Sanitize: replace spaces, slashes, colons with dashes
LABEL=$(echo "$LABEL" | tr ' /:' '---')

CHECKPOINT_FILE="$CHECKPOINT_DIR/${LABEL}_${TIMESTAMP}.md"

# Build git snapshot
GIT_STATE=""
if [ -n "$CWD" ] && cd "$CWD" 2>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null)
  GIT_LOG=$(git log --oneline -3 2>/dev/null)
  GIT_STATUS=$(git status --short 2>/dev/null)
  GIT_STATE="Branch: ${BRANCH:-detached HEAD}

Recent commits:
$(echo "$GIT_LOG" | sed 's/^/  /')

Status:
$(echo "$GIT_STATUS" | sed 's/^/  /')"
fi

cat > "$CHECKPOINT_FILE" <<EOF
# Checkpoint ${TIMESTAMP//-/:}
Session: ${SESSION_ID}${SESSION_NAME:+ (name: $SESSION_NAME)}
CWD: ${CWD:-unknown}
Compacted at: $(date '+%Y-%m-%dT%H:%M:%S')

## Git State
${GIT_STATE:-Not a git repository}
EOF

exit 0
