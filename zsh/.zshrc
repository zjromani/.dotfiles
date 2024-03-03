# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
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

# I'm using "Fig terminal" instead of zsh auto suggestions
# zsh-autosuggestions
plugins=(git)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

alias vimrc="nvim ~/.vimrc"
alias jsontidy="pbpaste | jq '.' | pbcopy"
alias vim="nvim"
alias k="kubectl"

alias unfuck-turbo="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +"
alias zrc="nvim ~/.zshrc"
alias pghe="psql he_api"
alias sourcez="source ~/.zshrc"
alias rpid="lsof -wni tcp:3000"
alias he_dev="osascript ~/.dotfiles/iterm_scripts/he_dev.scpt"
alias he_debug="osascript ~/.dotfiles/iterm_scripts/he_debug.scpt"
alias a="~/work/he-api"
alias r="~/work/he-relay"
alias m="~/work/microservices"
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

# Alchemists: https://www.alchemists.io/projects/dotfiles/#_aliases
alias glt='git for-each-ref --sort=taggerdate --color --format="%(color:yellow)%(refname:short)%(color:reset)|%(taggerdate:short)|%(color:blue)%(color:bold)%(*authorname)%(color:reset)|%(subject)" refs/tags | column -s"|" -t'
alias gtagv='git tag --verify'
alias ruba="git ls-files -m | xargs ls -1 2>/dev/null | grep '\.rb$' | xargs rubocop -a"
alias cpymsg='cat .git/COMMIT_EDITMSG | grep --invert-match "^\#.*" | pbcopy'

export HE_DB_USERNAME=$USER
export HE_DB_DEVELOPMENT=he_api

# export DATABASE_URL=he_api
export HE_DB_TEST=he_api_test
export CLOUDAMQP_URL=amqp://localhost
export ALLOWED_CORS_DOMAINS="localhost:,he-members-staging-br-"
export RACK_ENV=development
export RAILS_EAGER_LOAD_TEST=false

# FOR NODE TEST public-api
export CLOUDAMQP_URL=amqp://localhost
export NODE_ENV=development

bindkey -s ^g "git-branch-switch\n"
bindkey -s ^f "tmux-sessionizer\n"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
