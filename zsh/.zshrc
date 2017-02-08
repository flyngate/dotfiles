# init zsh completion and colors
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath=(~/.zsh/completion $fpath)
autoload -U compinit promptinit colors
compinit
promptinit
colors
zstyle ':completion:*' menu select

# find out platform
PLATFORM="unknown"
case $(uname) in
  Darwin)  PLATFORM="osx" ;;
  Linux)   PLATFORM="linux" ;;
  FreeBSD) PLATFORM="freebsd" ;;
esac

# variables
export EDITOR="vim"

# set up prompt
setopt prompt_subst
git_branch() {
  echo `git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`
}
git_prompt() {
  branch=`git_branch`
  if [ "$branch" != "" ]; then
    echo "%{$fg[blue]%}↑ $(git_branch)%{$reset_color%}"
  fi
}
prompt_hello() {
  case `whoami` in
    root ) echo '#' ;;
    *    ) echo '$' ;;
  esac
}
PROMPT=' $(prompt_hello) '
rprompt='$(git_prompt) %{$fg[red]%}%~%{$reset_color%}'
RPROMPT=$rprompt
TRAPWINCH() {
  RPROMPT=''
  sleep 1
  RPROMPT=$rprompt
}


# aliases
if [[ $platform == 'linux' ]]; then
   alias ls='ls --color=auto'
elif [[ $platform == 'freebsd' ]]; then
   alias ls='ls -G'
fi
alias grep="grep --color=auto"
alias df="df -h"
alias la="ls -a"
alias lla="ls -la"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias django="python manage.py"
alias journal="journalctl -b"

# git 'g' alias
function g {
  if [[ $# > 0 ]]; then
    git $@
  else
    git status --short --branch
  fi
}

compdef g=git

function hub {
  [[ "$1" == "clone" ]] && [[ $# -gt 2 ]] &&
    git clone https://github.com/$2/$3 $4 ||
    (echo 2>&1 "hub: syntax error"; exit 1)
}

# setup keys
bindkey "^[[2~" overwrite-mode       # insert
bindkey "^[[3~" delete-char          # delete
bindkey "^[[3$" delete-char          # delete
bindkey "^[[1~" beginning-of-line    # home (console)
bindkey "^[[H~" beginning-of-line    # home (xorg)
bindkey "^[[7~" beginning-of-line    # home (xorg also)
bindkey "^[[7$" beginning-of-line    # home + shift (xorg)
bindkey "^[[4~" end-of-line          # end (console)
bindkey "^[[F~" end-of-line          # end (xorg)
bindkey "^[[8~" end-of-line          # end (xorg also)
bindkey "^[[8$" end-of-line          # end + shift (xorg)
bindkey "^[[5~" up-line-or-history   # page up
bindkey "^[[6~" down-line-or-history # page down
bindkey "^[[c"  forward-char         # right + shift (xorg)
bindkey "^[[d"  backward-char        # left + shift (xorg)
bindkey "^[Od"  emacs-backward-word  # ctrl + left
bindkey "5D"    emacs-backward-word  # ctrl + left
bindkey "^[Oc"  emacs-forward-word   # ctrl + right
bindkey "5C"    emacs-forward-word   # ctrl + right

export WORDCHARS=''

# add ncmpcpp execution by alt+\
if [[ -e `which ncmpcpp` ]]; then
  ncmpcpp_show() { BUFFER="ncmpcpp"; zle accept-line; }
  zle -N ncmpcpp_show
  bindkey '^[\' ncmpcpp_show
fi

# disable flow control
stty -ixon

# fasd
if [[ -e `which fasd` ]]; then
  eval "$(fasd --init auto)"
fi

# extract command
function extract {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2) tar xvjf $1 ;;
      *.tar.gz)  tar xvzf $1 ;;
      *.tar.xz)  tar xvfJ $1 ;;
      *.bz2)     bunzip2 $1  ;;
      *.rar)     unrar x $1  ;;
      *.gz)      gunzip $1   ;;
      *.tar)     tar xvf $1  ;;
      *.tbz2)    tar xvjf $1 ;;
      *.tgz)     tar xvzf $1 ;;
      *.zip)     unzip $1    ;;
      *.7z)      7z x $1     ;;
      *)         echo "'$1' cannot be extracted via extract."; exit 1
    esac
  else
    echo "extract: '$1' is not a valid archive."; exit 1
  fi
}

function conf {
  case $1 in
    zsh)
      vim ~/.zshrc ;;
    xinit)
      vim ~/.xinitrc ;;
    urxvt)
      vim ~/.Xdefaults ;;
    mpd)
      vim ~/.mpd/mpd.conf ;;
    mpdscribble)
      vim ~/.mpdscribble/mpdscribble.conf ;;
    bspwm)
      vim ~/.config/bspwm/bspwmrc ;;
    sxhkd)
      vim ~/.config/sxhkd/sxhkdrc ;;
  esac
}

function update {
  if [[ -e `which pacman` ]]; then
    sudo pacman -Syu
  elif [[ -e `which apt-get` ]]; then
    sudo apt-get update && sudo apt-get upgrade
  fi
}

export PATH="$PATH:$HOME/.scripts"

# import init scripts from .zshrc.d
ZSHDIR=".zshrc.d"
if [ -d "$ZSHDIR" ]; then
  for file in $(ls -Av1 "$ZSHDIR"); do
    source "$ZSHDIR/$file"
  done
fi
