
### variables
export EDITOR="vim"
export PATH="$PATH:$HOME/.scripts"

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
source "$HOME/.zsh.d/prompts/prompt2"

### aliases
source "$HOME/.zsh.d/aliases"

### key bindings
source "$HOME/.zsh.d/key_bindings"

### plugins
source "$HOME/.zsh.d/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# import init scripts from .zshrc.local
zsh_local=".zsh.local"
if [ -d "$zsh_local" ]; then
  for file in $(ls -Av1 "$zsh_local"); do
    source "$zsh_local/$file"
  done
fi
