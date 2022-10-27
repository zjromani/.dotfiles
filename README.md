# .dotfiles

## Setup

`~/git clone https://github.com/zjromani/.dotfiles.git`

### Sym Links

```bash
ln -s $HOME/.dotfiles/psqlrc $HOME/.psqlrc

ln -s $HOME/.dotfiles/vimrc $HOME/.vimrc
```

## Iterm

Iterm setting dont seem to work with sym links. Instead, you can manually point the config setting to this repo locally

```
Open iterm -> setting -> preferences -> √ load settings from folder -> $HOME/.dotfiles/iterm_profile
```

### Vim Config

```bash
# install pathogen first
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

git clone https://github.com/preservim/nerdtree.git ~/.vim/bundle/nerdtree
git clone https://github.com/flazz/vim-colorschemes.git ~/.vim/bundle/colorschemes
git clone https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim
```

- Install
  - pathogen
  - [color schemes](https://github.com/flazz/vim-colorschemes)
  - nerdtree
  - ctrl-p
  - vim-rails
  - vim-fugitive
  - vim-easymotion
