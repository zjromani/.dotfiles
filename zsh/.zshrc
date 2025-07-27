if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

export HOMEBREW_PREFIX="$(brew --prefix)"

DISABLE_MAGIC_FUNCTIONS=true

# If you come from bash you might have to change your $PATH.
#export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy/mm/dd"

#zsh-autosuggestions
plugins=(git)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

alias vimrc="nvim ~/.vimrc"
alias jsontidy="pbpaste | jq '.' | pbcopy"
alias vim="nvim"
alias k="kubectl"
alias ja="jira-add"
alias je="jira-add-epic"
alias jb="jira-add-bug"
alias js="jira-add-shield"
alias jc="jira-add-corrective-action"

alias unfuck-turbo="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +"
alias zrc="nvim ~/.zshrc"
alias pghe="psql he_api"
alias sourcez="source ~/.zshrc"
alias rpid="lsof -wni tcp:3000"
alias he_dev="osascript ~/.dotfiles/iterm_scripts/he_dev.scpt"
alias he_debug="osascript ~/.dotfiles/iterm_scripts/he_debug.scpt"
alias dots="~/.dotfiles"
alias t="bundle exec rspec"
alias sp="spring rspec"
alias h="heroku"
#alias rprodsql="heroku pg:psql postgresql-clear-51558 --app he-api"
alias guards="bundle exec guard -G Guardfile.spring"
#alias wprodsql="heroku pg:psql postgresql-parallel-53332 --app he-public-api"
#alias rstagesql="heroku pg:psql postgresql-adjacent-00545 --app he-api-staging"
#alias wstagesql="heroku pg:psql postgresql-horizontal-38842 --app he-api-staging"
#alias wsandsql="heroku pg:psql postgresql-fitted-33271 --app he-public-api-sandbox"
alias hrailsc='h run rails console --app he-api'
alias rs='rails s'
alias rc='rails c'
alias glog='git log --oneline --decorate --graph --since="3 weeks ago" --date=relative --pretty=format:"%C(yellow)%h %C(cyan)(%ar) %C(green)%an %C(auto)%d %C(reset)%s %C(magenta)https://github.com/HotelEngine/engine-booking-api/commit/%H%C(reset)"'
alias gpr='git pull-request -o'
alias grec='git branch --sort=committerdate'
alias topo='top -o mem'
alias rdb='SCHEMA=db/structure-base.sql RAILS_ENV=test rails db:drop db:create db:structure:load'
alias dev_tail="tail -f log/development.log"
alias prod_tail="heroku logs -a he-api --tail"
alias stage_tail="h logs -a he-api-staging --tail"
alias rake='noglob rake'
alias desk='~/Desktop/'
#alias ever='code /Users/$HOME/Desktop/ever'
#alias note='mvim /Users/$HOME/Desktop/ever/general.md'
alias gcm='gco main'
alias gsw='git-pull-switch'

# Alchemists: https://www.alchemists.io/projects/dotfiles/#_aliases
alias glt='git for-each-ref --sort=taggerdate --color --format="%(color:yellow)%(refname:short)%(color:reset)|%(taggerdate:short)|%(color:blue)%(color:bold)%(*authorname)%(color:reset)|%(subject)" refs/tags | column -s"|" -t'
alias gtagv='git tag --verify'
alias ruba="git ls-files -m | xargs ls -1 2>/dev/null | grep '\.rb$' | xargs rubocop -a"
alias cpymsg='cat .git/COMMIT_EDITMSG | grep --invert-match "^\#.*" | pbcopy'

alias tf="terraform"

# Load sensitive environment variables if the file exists
if [[ -f $HOME/.zshenv_private ]]; then
  source $HOME/.zshenv_private
fi

# BIND KEYS FOR CUSTOM SCRIPTS
bindkey -s "^g" "git-branch-switch\n"
bindkey -s "^f" "tmux-sessionizer\n"

fzf-history-widget() {
  local selected
  selected=$(fc -l 1 | awk '{$1=""; print substr($0,2)}' | tac | awk '!seen[$0]++' | fzf) || return
  zle kill-whole-line
  LBUFFER=$selected
  zle redisplay
}
zle -N fzf-history-widget
bindkey '^R' fzf-history-widget

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/Applications/IntelliJ IDEA.app/Contents/MacOS:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# This auto loads NVM if a .nvmrc file is in the present dir
autoload -U add-zsh-hook
load-nvmrc() {
  [[ -a .nvmrc ]] || return
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$PATH:$HOME/.cargo/bin"

export PATH="/usr/local/opt/python@3.12/bin:$PATH"

# add .dotfile scripts to path
export PATH="$PATH:$HOME/.dotfiles/bin/scripts"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$PATH:/Users/zachromani/.dotfiles/bin"
