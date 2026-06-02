#!/bin/bash
# Run once on a new machine to register user-scoped MCP servers.
# Sources ~/.zshenv_private for secrets. Missing secrets produce a warning
# and skip that MCP — they do not abort the script.

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
if [ -n "$NOTION_API_KEY" ]; then
  mcp_add notion --scope user --transport http \
    --header "Authorization: Bearer ${NOTION_API_KEY}" \
    -- notion https://api.notion.com/v1/mcp
else
  echo "Skipping notion MCP: NOTION_API_KEY not set in ~/.zshenv_private."
fi

# Executive Circle — HTTP MCP, token from env
if [ -n "$EXEC_CIRCLE_TOKEN" ]; then
  mcp_add executive-circle --scope user --transport http \
    "executive-circle" "https://www.contentmasterpro.limited/api/mcp/subscriber/${EXEC_CIRCLE_TOKEN}"
else
  echo "Skipping executive-circle MCP: EXEC_CIRCLE_TOKEN not set in ~/.zshenv_private."
fi

# LogRocket members client — HTTP MCP, OAuth token in ~/.claude.json
mcp_add logrocket-members --scope user --transport http \
  logrocket-members https://mcp.logrocket.com/mcp/c8gpr6/members-client

# Salesforce DX — local npx server
mcp_add "Salesforce DX" --scope user -- \
  "Salesforce DX" npx -y @salesforce/mcp --orgs DEFAULT_TARGET_ORG --toolsets orgs,metadata,data,users

# Atlan — HTTP MCP, OAuth (browser re-auth required after)
mcp_add atlan --scope user --transport http \
  atlan https://engine.atlan.com/mcp

# Datadog — HTTP MCP with API key
if [ -n "$DD_API_KEY" ] && [ -n "$DD_APP_KEY" ]; then
  mcp_add datadog-mcp --scope user --transport http \
    --header "DD-API-KEY: ${DD_API_KEY}" \
    --header "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    -- datadog-mcp https://mcp.datadoghq.com/api/unstable/mcp-server/mcp
else
  echo "Skipping datadog-mcp: DD_API_KEY or DD_APP_KEY not set in ~/.zshenv_private."
fi
