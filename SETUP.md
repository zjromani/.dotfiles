# Setup

Configuration that must exist in `~/.zshenv_private` (not tracked in this repo).

## Required Environment Variables

```bash
# Jira
export JIRA_URL="https://yourcompany.atlassian.net"
export WORK_EMAIL="you@yourcompany.com"
export JIRA_API_TOKEN="your-jira-api-token"
export JIRA_PROJECT_KEY="YOUR-PROJECT"          # default: BOOK
export JIRA_TEAM_ID="your-team-uuid"

# Jira — additional teams (required for sapi-release-notes-last-seven-days)
export JIRA_BOOKING_TEAM_ID="..."
export JIRA_CONTENT_TEAM_ID="..."               # also required for jira-add-content
export JIRA_BLUE_TEAM_ID="..."
export JIRA_GREEN_TEAM_ID="..."
export JIRA_PRICING_TEAM_ID="..."
export JIRA_PRICING_TEAM_ID_2="..."
export JIRA_GREEN_TEAM_ASSIGNEES="accountId1,accountId2"

# Jira — optional overrides
export JIRA_READY_FOR_DEV_TRANSITION_ID="171"   # default: 171

# Notion
export NOTION_PROJECT_SECRET="your-notion-token"
export NOTION_DATABASE_ID="your-db-id"
export NOTION_PROJECT_DATABASE_ID="your-project-db-id"
export NOTION_AREA_OF_FOCUS_ID="your-area-id"

# GitHub
export GITHUB_REPO_URL="https://github.com/YourOrg/your-repo"
```

## Git Identity

Set per-machine (not tracked in dotfiles):

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```
