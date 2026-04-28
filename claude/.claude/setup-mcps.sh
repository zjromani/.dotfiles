#!/bin/bash
# Run once on a new machine to register user-scoped MCP servers.
# Requires ~/.zsh_env_private to have NOTION_API_KEY set before running.

set -e

# Source secrets
if [ -f ~/.zshenv_private ]; then
  source ~/.zshenv_private
fi

# Krisp — HTTP MCP, no API key (uses OAuth stored in ~/.claude.json)
claude mcp add --scope user --transport http krisp https://mcp.krisp.ai/mcp

# Notion — HTTP MCP with bearer auth
if [ -z "$NOTION_API_KEY" ]; then
  echo "Error: NOTION_API_KEY not set. Add it to ~/.zshenv_private and re-run."
  exit 1
fi
claude mcp add --scope user --transport http \
  --header "Authorization: Bearer ${NOTION_API_KEY}" \
  -- notion https://api.notion.com/v1/mcp

# Executive Circle — HTTP MCP, token from env
if [ -z "$EXEC_CIRCLE_TOKEN" ]; then
  echo "Error: EXEC_CIRCLE_TOKEN not set. Add it to ~/.zshenv_private and re-run."
  exit 1
fi
claude mcp add --scope user --transport http \
  "executive-circle" "https://www.contentmasterpro.limited/api/mcp/subscriber/${EXEC_CIRCLE_TOKEN}"
