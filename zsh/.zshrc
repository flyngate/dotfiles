### shell variables
export EDITOR="vim"
export PATH="$PATH:$HOME/.scripts"
export LANG=en_US
export TERM="screen-256color"

export FZF_DEFAULT_COMMAND="ag -g ''"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

### constants
__zsh_prompt="$HOME/.zsh.d/prompts/prompt2"
__zsh_aliases="$HOME/.zsh.d/aliases"
__zsh_key_bindings="$HOME/.zsh.d/key_bindings"
__zsh_functions="$HOME/.zsh.d/functions"
__zsh_local="$HOME/.zsh.local"

### enable vi mode
bindkey -v

### discover platform
platform="unknown"
case $(uname) in
  Darwin)  platform="macos" ;;
  Linux)   platform="linux" ;;
  FreeBSD) platform="freebsd" ;;
esac

### completion
fpath=($HOME/.zsh.d/completion $fpath)
autoload -U compinit promptinit colors
compinit
promptinit
colors
zstyle ':completion:*' menu select

### disable flow control
stty -ixon

### nvm

# defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once if .bashrc gets sourced multiple times
# by checking whether __init_nvm is a function.
if [ -s "$HOME/.nvm/nvm.sh" ] && [ -z "$(command -v __init_nvm)" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'webpack')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    . "$NVM_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
    function __init_nvm() {}
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi

# this loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

### fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

### prompt
source $__zsh_prompt

### aliases
source $__zsh_aliases

### key bindings
source $__zsh_key_bindings

### functions
__zsh__init_functions() {
  local name
  fpath=($__zsh_functions $fpath)
  for name in $(ls $__zsh_functions); do
    autoload $name
  done
}
__zsh__init_functions

### plugins
source "$HOME/.zsh.d/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

BASE16_SHELL="$HOME/.zsh.d/plugins/base16-shell"
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && { eval "$($BASE16_SHELL/profile_helper.sh)" }

### import all scripts from .zshrc.local
if [ -d "$__zsh_local" ]; then
  for file in $(ls -Av1 "$__zsh_local"); do
    source "$__zsh_local/$file"
  done
fi
