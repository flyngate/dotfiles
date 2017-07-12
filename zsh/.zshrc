
### shell variables
export EDITOR="vim"
export PATH="$PATH:$HOME/.scripts"

### constants
__zsh_prompt="$HOME/.zsh.d/prompts/prompt2"
__zsh_aliases="$HOME/.zsh.d/aliases"
__zsh_key_bindings="$HOME/.zsh.d/key_bindings"
__zsh_functions="$HOME/.zsh.d/functions"
__zsh_local="$HOME/.zsh.local"

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
