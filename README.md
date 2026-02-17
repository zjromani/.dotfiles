# .dotfiles

Personal dotfiles managed with GNU Stow and automated with Ansible. Includes configurations for Neovim, iTerm2, Git, PostgreSQL, Tmux, Claude, and Zsh.

## Quick Start

### New Machine Setup

```bash
# Clone dotfiles
git clone https://github.com/zjromani/.dotfiles.git ~/.dotfiles

# Clone and run ansible playbook (handles everything)
git clone <your-ansible-repo-url> ~/me/ansible
cd ~/me/ansible
ansible-playbook local.yml
```

The Ansible playbook will:
- Install all required tools (brew, git, zsh, tmux, neovim, etc.)
- Install fonts (JetBrainsMono Nerd Font)
- Install tmux plugins (catppuccin theme)
- Stow all dotfile packages
- Configure iTerm2 to load preferences from dotfiles
- Set up zsh with your configuration

### Manual Stow (if not using Ansible)

If you prefer to stow packages manually:

```bash
cd ~/.dotfiles
stow nvim
stow zsh
stow tmux
stow cursor
stow iterm2
stow git
stow psql
```

## Syncing Across Machines

When you update dotfiles on one machine and want to sync to others:

```bash
# On other machines, run the update playbook
cd ~/me/ansible
ansible-playbook update.yml
```

This will:
1. Pull latest dotfiles from git
2. Re-stow all packages (updates symlinks)
3. Update tmux plugins
4. Sync iTerm2 configuration
5. Reload configurations

### Manual Sync (without Ansible)

```bash
# Pull changes
cd ~/.dotfiles && git pull origin master

# Re-stow affected packages
stow -R tmux nvim zsh cursor iterm2

# Reload configs
exec $SHELL                    # zsh
tmux source-file ~/.tmux.conf  # tmux (or prefix + r)
# iTerm2 will auto-reload from ~/.config/iterm2/
```

## Adding New Packages

Stow packages are managed via `packages.yml`. To add a new package:

1. Create the package directory (e.g., `alacritty/`)
2. Add it to `packages.yml`:
   ```yaml
   stow_packages:
     - alacritty
   ```
3. Commit and push
4. Run `ansible-playbook update.yml` on other machines

The install script and Ansible automation both read from this manifest, ensuring they stay in sync.

## Configuration Details

### iTerm2

iTerm2 preferences are stored in `iterm2/.config/iterm2/com.googlecode.iterm2.plist` and automatically synced via symlink. When you change settings in iTerm2 (like font selection), the changes are written to this file and can be committed to git.

No manual import/export needed - iTerm2 is configured to load preferences from `~/.config/iterm2/`.

### Tmux

Tmux configuration includes:
- Catppuccin Mocha theme
- Requires JetBrainsMono Nerd Font for icons
- Custom key bindings (prefix + v/s for splits, prefix + r to reload)

### Neovim

Managed with Packer. After stowing, run `:PackerSync` in nvim to install plugins.

### Secure Environment Variables

Sensitive environment variables should be stored outside of this repository. Create a `.zshenv_private` file in your home directory:

```bash
touch $HOME/.zshenv_private
```

Then, add your sensitive environment variables to this file. The `.zshrc` configuration will automatically source this file if it exists, keeping your sensitive data secure.

## Dependency Management

External dependencies (plugins, themes) not tracked in this repo:

- **Tmux Plugins**: `~/.config/tmux/plugins/catppuccin/` - Installed via git by Ansible
- **Neovim Plugins**: `~/.local/share/nvim/site/pack/packer/` - Managed by Packer
- **Fonts**: JetBrainsMono Nerd Font - Installed via Homebrew by Ansible

When adding new dependencies, update `~/me/ansible` to automate installation.

