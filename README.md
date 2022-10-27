# .dotfiles

## Setup

`~/git clone https://github.com/zjromani/.dotfiles.git`

### Sym Links

```bash
ln -s /Users/zachromani/.dotfiles/psqlrc /Users/zachromani/.psqlrc

ln -s /Users/zachromani/.dotfiles/vimrc /Users/zachromani/.vimrc

ln -s /Users/zachromani/.dotfiles/iterm_profile /Users/zachromani/iterm_profile
```

## Iterm

After you `ln` iterm_profile:

```
Open iterm -> setting -> preferences -> √ load settings from folder -> select home directory
```

### Vim Config

- Install
  - pathogen
  - [color schemes](https://github.com/flazz/vim-colorschemes)
  - nerdtree
  - ctrl-p
  - vim-rails
  - vim-fugitive
  - vim-easymotion
