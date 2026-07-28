#!/usr/bin/env bash
# PreToolUse hook (Bash matcher) — blocks the highest-consequence git actions
# that CLAUDE.md marks as "never" so they cannot run under auto mode.
#
# Blocks: force-push (except --force-with-lease), push to main/master,
#         and --no-verify on commit/push.
# Exception: ~/.dotfiles pushes straight to master by convention (no PR
#   workflow there), so the main/main-master block is skipped in that repo.
# Advisory only (NOT blocked here, since it can't be distinguished safely):
#   amending already-pushed commits — a local `git commit --amend` is fine.
#
# Fails OPEN: any parse issue, non-git, or read-only git command is allowed,
# so a bug here can never wedge every Bash call.
set -uo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
TOPLEVEL=$(git rev-parse --show-toplevel 2>/dev/null)
IS_DOTFILES_REPO=false
[ -n "$TOPLEVEL" ] && [ "$TOPLEVEL" = "$DOTFILES_DIR" ] && IS_DOTFILES_REPO=true

INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

# Nothing to inspect -> allow.
[ -z "$CMD" ] && exit 0

# Only inspect commands that actually push or commit.
case "$CMD" in
  *"git push"*|*"git commit"*) : ;;
  *) exit 0 ;;
esac

deny() {
  jq -n --arg reason "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

# 1. Force-push in any form except the safer --force-with-lease.
if printf '%s' "$CMD" | grep -Eq 'git[[:space:]]+push'; then
  if printf '%s' "$CMD" | grep -Eq -- '--force([^-]|$)' \
     || printf '%s' "$CMD" | grep -Eq '(^|[[:space:]])-f([[:space:]]|$)'; then
    deny "Blocked: force-push is a CLAUDE.md 'never' rule. Use --force-with-lease, or ask the user to run it explicitly."
  fi
fi

# 2. Push directly to main/master (matches 'origin main', 'origin/main', 'HEAD:main', trailing 'main', etc.).
#    Skipped in ~/.dotfiles, which pushes straight to master by convention.
if [ "$IS_DOTFILES_REPO" = false ] && printf '%s' "$CMD" | grep -Eq 'git[[:space:]]+push'; then
  if printf '%s' "$CMD" | grep -Eq '(^|[[:space:]]|:|/)(main|master)([[:space:]]|$)'; then
    deny "Blocked: pushing to main/master is a CLAUDE.md 'never' rule — use a feature branch + PR, or ask the user to run it explicitly."
  fi
fi

# 3. --no-verify on commit or push.
if printf '%s' "$CMD" | grep -Eq -- '--no-verify'; then
  deny "Blocked: --no-verify is disallowed unless explicitly requested (CLAUDE.md). Re-run only if the user explicitly asks."
fi

exit 0
