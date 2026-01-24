# Dotfiles

Personal dotfiles managed with GNU Stow. Each top-level directory is a stow package.

## Structure

```
nvim/     -> ~/.config/nvim
zsh/      -> ~/.zshrc
claude/   -> ~/.claude
tmux/     -> ~/.tmux.conf (if exists)
```

## Usage

```bash
# Install a package
cd ~/.dotfiles && stow nvim

# Remove a package
cd ~/.dotfiles && stow -D nvim

# Reinstall (useful after changes)
cd ~/.dotfiles && stow -R nvim
```

## Conventions

- Each package mirrors the home directory structure
- Use `.config/` subdirectory for XDG-compliant apps
- Keep secrets in `~/.zshenv_private` (not tracked)

## Claude Config

The `claude/` package provides shared Claude Code configuration:
- `settings.json` - global permissions and env vars
- `skills/` - reusable workflows (`/commit`, `/pr`, `/review`)
- `agents/` - custom subagents (`software-architect`, `build-validator`, `research`)

Both work and personal accounts use these via symlink.

## Claude Instructions

When working in this repo, always make config changes to the stow-able source locations:

| Config Type | Write to (this repo) | NOT to |
|-------------|---------------------|--------|
| Claude agents | `claude/.claude/agents/` | `~/.claude/agents/` |
| Claude skills | `claude/.claude/skills/` | `~/.claude/skills/` |
| Claude settings | `claude/.claude/settings.json` | `~/.claude/settings.json` |
| Neovim config | `nvim/.config/nvim/` | `~/.config/nvim/` |
| Zsh config | `zsh/.zshrc` | `~/.zshrc` |

After changes, run `stow -R <package>` to update symlinks.
