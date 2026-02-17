# Dotfiles

Personal dotfiles managed with GNU Stow. Each top-level directory is a stow package.

## Structure

```
nvim/     -> ~/.config/nvim
zsh/      -> ~/.zshrc
claude/   -> ~/.claude
cursor/   -> ~/.cursor
tmux/     -> ~/.tmux.conf
iterm2/   -> ~/.config/iterm2
git/      -> ~/.gitconfig
psql/     -> ~/.psqlrc
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
- **External dependencies** (plugins, themes) should be documented in this file
- **When adding external dependencies**: Update ansible playbook to automate installation

## Multi-Machine Synchronization

When dotfiles are updated on one machine, sync to others:

1. **Pull and re-stow**
   ```bash
   cd ~/.dotfiles && git pull origin master
   # Re-stow affected packages
   stow -R tmux nvim zsh claude  # or specific packages
   ```

2. **Install/update dependencies** (not tracked in repo)
   - Tmux catppuccin: `git clone https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin`
   - Nvim plugins: `nvim +PackerSync`

3. **Reload configs**
   ```bash
   exec $SHELL                    # zsh
   tmux source-file ~/.tmux.conf  # tmux
   ```

### Dependency Management

External dependencies (plugins, themes) not tracked in this repo:

- **Starship**: `brew install starship` - Cross-shell prompt
- **Tmux Plugins**: `~/.config/tmux/plugins/catppuccin/` - Install via git clone
- **Neovim Plugins**: `~/.local/share/nvim/site/pack/packer/` - Managed by Packer (Catppuccin theme + lualine)
- **Nerd Font**: JetBrains Mono Nerd Font - Set in iTerm2 (Settings > Profiles > Text > Font)
- **When adding dependencies**: Update `~/me/ansible` to automate installation

## Before Committing

When making changes that affect multiple machines:

1. Test locally first
2. Document any new external dependencies
3. Update Ansible tasks for new dependencies
4. Consider: Will this work on fresh installs?

## Claude Config

The `claude/` package provides shared Claude Code configuration:
- `settings.json` - global permissions and env vars
- `skills/` - reusable workflows (`/commit`, `/pr`, `/review`)
- `agents/` - custom subagents (`software-architect`, `build-validator`, `research`)

Both work and personal accounts use these via symlink.

The `cursor/` package provides shared Cursor configuration:
- `skills/` - reusable Cursor agent skills in `~/.cursor/skills/`
- Current skills include `software-design-architect` and `elia-go-faster-review`
- Keep Cursor skills in dotfiles at `cursor/.cursor/skills/` (not in home directly)

## Claude Instructions

When working in this repo, always make config changes to the stow-able source locations:

| Config Type | Write to (this repo) | NOT to |
|-------------|---------------------|--------|
| Claude agents | `claude/.claude/agents/` | `~/.claude/agents/` |
| Claude skills | `claude/.claude/skills/` | `~/.claude/skills/` |
| Claude settings | `claude/.claude/settings.json` | `~/.claude/settings.json` |
| Cursor skills | `cursor/.cursor/skills/` | `~/.cursor/skills/` |
| Neovim config | `nvim/.config/nvim/` | `~/.config/nvim/` |
| Zsh config | `zsh/.zshrc` | `~/.zshrc` |
| Tmux config | `tmux/.tmux.conf` | `~/.tmux.conf` |
| iTerm2 config | `iterm2/.config/iterm2/` | `~/.config/iterm2/` |

After changes, run `stow -R <package>` to update symlinks.
