# .dotfiles

My go-to repository for setting up a development environment with ease. This repository includes configurations for Vim, iTerm, Git, PostgreSQL, Tmux, and Zsh.

## Setup

Clone the repository to your local machine to get started:

```bash
git clone https://github.com/zjromani/.dotfiles.git ~/.dotfiles
```

### Sym Links with Stow

**THIS WILL NOT WORK WITH CURRENT SETTINGS. When stow was used, it was looking for ~/git folder, not ~/.dotfiles. This will need to be updated to reflect the correct path.**

GNU Stow is a symlink farm manager which makes it easy to manage your dotfiles by keeping them version-controlled in a single directory and symlinked into place. Here's how to use it:


```bash
cd ~/.dotfiles 

# Use Stow to symlink dotfiles, adopting any existing files
stow --adopt -v --dotfiles -t ~/.config/ dot-config
stow psqlrc
stow vimrc
stow gitconfig
stow tmux
stow zsh
```

### iTerm Configuration

iTerm settings do not work well with symbolic links. Instead, manually point iTerm to load the configuration settings from this repository:

> Open iTerm -> Preferences -> Profiles -> Other Actions... (next to the profile name) -> Load JSON Profile... -> Navigate to `$HOME/git/.dotfiles/iterm_profile` and select the JSON profile.


### Secure Environment Variables

Sensitive environment variables should be stored outside of this repository. Create a `.zshenv_private` file in your home directory:

```bash
touch $HOME/.zshenv_private
```

Then, add your sensitive environment variables to this file. The `.zshrc` configuration will automatically source this file if it exists, keeping your sensitive data secure.

