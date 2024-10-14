### environment variables
export EDITOR="vim"
export PATH="$HOME/.scripts:/opt/homebrew/bin:/usr/sbin:$PATH"
export LANG=en_US.UTF-8
# export TERM="screen-256color"
export TERM="xterm-256color"
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
  . "$HOME/.zsh.d/prompts/prompt2"
  . "$HOME/.zsh.d/aliases"
  . "$HOME/.zsh.d/key_bindings"

  local ZSH_LOCAL="$HOME/.zsh.local"

  [ -f "$ZSH_LOCAL" ] && source "$ZSH_LOCAL"

  if [ -d "$ZSH_LOCAL" ]; then
    for file in $(ls -Av1 "$ZSH_LOCAL"); do
      source "$ZSH_LOCAL/$file"
    done
  fi

  ### plugins
  source "$HOME/.zsh.d/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  source "$HOME/.zsh.d/plugins/zsh-nvm-lazy-load.plugin.zsh"

  local BASE16_SHELL="$HOME/.zsh.d/plugins/base16-shell"
  [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && { eval "$($BASE16_SHELL/profile_helper.sh)" }

  ### z
  # source "$HOME/.zsh.d/bin/z.sh"

  ### zoxide
  type zoxide > /dev/null && eval "$(zoxide init zsh)"

  ### fzf
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  ### zk
  export ZK_NOTEBOOK_DIR="$HOME/Documents/notes/zk"
}

zshrc

unfunction zshrc
