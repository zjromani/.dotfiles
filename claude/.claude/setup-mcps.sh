#!/bin/bash
# Run once on a new machine to register user-scoped MCP servers.
# Requires ~/.zsh_env_private to have NOTION_API_KEY set before running.

set -e

# Source secrets
if [ -f ~/.zshenv_private ]; then
  source ~/.zshenv_private
fi

mcp_add() {
  local name=$1; shift
  if claude mcp list 2>/dev/null | grep -q "^${name}:"; then
    echo "MCP ${name} already registered, skipping."
  else
    claude mcp add "$@"
  fi
}

# Krisp — HTTP MCP, no API key (uses OAuth stored in ~/.claude.json)
mcp_add krisp --scope user --transport http krisp https://mcp.krisp.ai/mcp

# Notion — HTTP MCP with bearer auth
if [ -z "$NOTION_API_KEY" ]; then
  echo "Error: NOTION_API_KEY not set. Add it to ~/.zshenv_private and re-run."
  exit 1
fi
mcp_add notion --scope user --transport http \
  --header "Authorization: Bearer ${NOTION_API_KEY}" \
  -- notion https://api.notion.com/v1/mcp

# Executive Circle — HTTP MCP, token from env (optional — skip if not set)
if [ -n "$EXEC_CIRCLE_TOKEN" ]; then
  mcp_add executive-circle --scope user --transport http \
    "executive-circle" "https://www.contentmasterpro.limited/api/mcp/subscriber/${EXEC_CIRCLE_TOKEN}"
else
  echo "Skipping executive-circle MCP: EXEC_CIRCLE_TOKEN not set."
fi
