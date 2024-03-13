### environment variables
export EDITOR="vim"
export PATH="$PATH:$HOME/.scripts"
export LANG=en_US
export TERM="screen-256color"

export FZF_DEFAULT_COMMAND="ag -g ''"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

function zshrc() {
  ### enable vi mode
  bindkey -v

  ### discover platform
  # platform="unknown"
  # case $(uname) in
  #   Darwin)  platform="macos" ;;
  #   Linux)   platform="linux" ;;
  #   FreeBSD) platform="freebsd" ;;
  # esac

  ### completion
  fpath=($HOME/.zsh.d/completion $fpath)
  autoload -U compinit promptinit colors
  compinit
  promptinit
  colors
  zstyle ':completion:*' menu select

  ### disable flow control
  stty -ixon

  # import zsh configuration files
  . $HOME/.zsh.d/prompts/prompt2
  . $HOME/.zsh.d/aliases
  . $HOME/.zsh.d/key_bindings

  ZSH_LOCAL="$HOME/.zsh.local"

  if [ -d "$__zsh_local" ]; then
    for file in $(ls -Av1 "$__zsh_local"); do
      source "$__zsh_local/$file"
    done
  fi

  ZSH_FUNCTIONS="$HOME/.zsh.d/functions"

  local name
  fpath=($ZSH_FUNCTIONS $fpath)
  for name in $(ls $ZSH_FUNCTIONS); do
    autoload $name
  done

  ### plugins
  source "$HOME/.zsh.d/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  source "$HOME/.zsh.d/plugins/zsh-nvm-lazy-load.plugin.zsh"

  BASE16_SHELL="$HOME/.zsh.d/plugins/base16-shell"
  [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && { eval "$($BASE16_SHELL/profile_helper.sh)" }

  ### z
  source "$HOME/.zsh.d/bin/z.sh"

  ### fzf
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

zshrc

unfunction zshrc
