#!/usr/bin/env bash
# PostToolUse hook (Bash matcher) — trims large command output to save context.
# If output exceeds THRESHOLD lines: keep first HEAD_LINES + last TAIL_LINES,
# emit output_override JSON, and save full output to /tmp/claude-last-bash-output.txt.

set -euo pipefail

THRESHOLD=150
HEAD_LINES=50
TAIL_LINES=50
FULL_OUTPUT_PATH="/tmp/claude-last-bash-output.txt"

INPUT=$(cat)
OUTPUT=$(echo "$INPUT" | jq -r '.tool_response.output // empty')

if [ -z "$OUTPUT" ]; then
  exit 0
fi

LINE_COUNT=$(echo "$OUTPUT" | wc -l)

if [ "$LINE_COUNT" -le "$THRESHOLD" ]; then
  exit 0
fi

# Save full output for reference
echo "$OUTPUT" > "$FULL_OUTPUT_PATH"

OMITTED=$(( LINE_COUNT - HEAD_LINES - TAIL_LINES ))
HEAD=$(echo "$OUTPUT" | head -n "$HEAD_LINES")
TAIL=$(echo "$OUTPUT" | tail -n "$TAIL_LINES")

TRIMMED="${HEAD}

... [${OMITTED} lines omitted — run \`cat ${FULL_OUTPUT_PATH}\` to see full output] ...

${TAIL}"

# Emit output_override so Claude sees the trimmed version
jq -n \
  --arg output "$TRIMMED" \
  '{
    "hookSpecificOutput": {
      "hookEventName": "PostToolUse",
      "output_override": $output
    }
  }'

exit 0
