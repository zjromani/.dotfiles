# Global Claude Instructions

## Communication Style
- Concise, direct responses. No preamble ("Great!", "Sure!", "Of course!").
- Don't narrate what you're about to do — just do it.
- When asked for an opinion, give one. Don't hedge without committing.

## Code Style Defaults
- Prefer small, atomic, reversible changes.
- Check for existing patterns before introducing new abstractions.
- Never leave TODO comments without describing what's missing and why it's deferred.

## Git Behavior
- Commit messages: past tense ("Added X", "Fixed Y"). Subject line under 72 chars. Body explains why, not what.
- Never amend pushed commits. Create a new commit instead.
- Never use --no-verify unless explicitly asked.

## Evidence & Linking
- Always include GitHub links (commits, PRs, issues, file lines) as evidence when investigating or explaining findings.
- Any message drafted for Slack, Confluence, Jira, or similar must include relevant GitHub links — never make claims without linking the proof.
- When referencing code behavior, bugs, or changes: link to the specific commit, PR, or file+line, not just describe it.

## Task Tracking
- For any work with more than one step, create tasks upfront using TaskCreate before starting.
- Mark each task complete as soon as it's done — don't batch completions.
- Single-step or purely conversational requests don't need tasks.

## Session Hygiene
- Before context compresses, emit a checkpoint: current task/status, decisions made this session, open questions, immediate next step.
- Use RESUME.md in project directories for session continuity.

## Asking vs. Acting
- Local file edits, running tests, read ops: act, then report.
- Pushing to remote, external API calls (Slack/Jira), production system changes: ask first.
- Never silently skip a step. If blocked, say so.

## Config System
- All Claude config lives in ~/.dotfiles/claude/.claude/ (stow-managed).
- Write to source locations, not symlink destinations. See ~/.dotfiles/CLAUDE.md.
- After config changes: stow -R claude

## Role Context

Engineering Director managing multiple engineering teams. Director-level workflows (team reviews, goal-setting, stakeholder comms, team health) are first-class — not secondary to engineering tasks.

## Delegation Defaults
### Act without asking
- Reading files, running tests, formatting, committing local changes

### Act, then notify
- Adding new dependencies
- Making assumptions about ambiguous requirements (state the assumption)

### Always ask first
- Pushing to remote
- Sending Slack messages or creating Jira tickets (confirm content first)
- Any production system change (terraform apply, kubectl apply)
- Force-pushing or amending published commits
