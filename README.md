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

### Vim Configuration

To set up Vim, start by installing Pathogen, a runtime path manager, and then proceed to clone your preferred Vim plugins:

```bash
# Install Pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Clone Vim plugins
git clone https://github.com/preservim/nerdtree.git ~/.vim/bundle/nerdtree
git clone https://github.com/flazz/vim-colorschemes.git ~/.vim/bundle/colorschemes
git clone https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim
```

#### Vim Plugins

Ensure the following plugins are installed:
- **Pathogen** - For managing your runtime path.
- **NERDTree** - A file system explorer for the Vim editor.
- **Color Schemes** - Enhance your Vim interface with various color schemes.
- **CtrlP** - Full path fuzzy file, buffer, mru, tag, etc., finder for Vim.
- Additional recommended plugins:
  - **vim-rails**
  - **vim-fugitive**
  - **vim-easymotion**

### Secure Environment Variables

Sensitive environment variables should be stored outside of this repository. Create a `.zshenv_private` file in your home directory:

```bash
touch $HOME/.zshenv_private
```

Then, add your sensitive environment variables to this file. The `.zshrc` configuration will automatically source this file if it exists, keeping your sensitive data secure.

