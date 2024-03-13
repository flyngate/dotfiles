#!/usr/bin/env zsh

# Based on https://github.com/undg/zsh-nvm-lazy-load
# NVM_DIR should be set globally at this point

# Create wrappers around common nvm consumers.
# nvm, node, yarn and npm will load nvm.sh on their first invocation,
# posing no start up time penalty for the shells that aren't going to use them at all.
# There is only single time penalty for one shell.

load-nvm() {
  local fallback_nvm_dir="$HOME/.nvm"
  local nvm_dir=${$NVM_DIR:-$fallback_nvm_dir}

  [ -s "$nvm_dir/nvm.sh" ] && . "$nvm_dir/nvm.sh"
  [ -s "$nvm_dir/bash_completion.d/nvm" ] && . "$nvm_dir/bash_completion.d/nvm"
  [ -s "$nvm_dir/etc/bash_completion.d/nvm" ] && . "$nvm_dir/etc/bash_completion.d/nvm"
}

nvm() {
  unset -f nvm
  load-nvm
  nvm "$@"
}

node() {
  unset -f node
  load-nvm
  node "$@"
}

npm() {
  unset -f npm
  load-nvm
  npm "$@"
}

pnpm() {
  unset -f pnpm
  load-nvm
  pnpm "$@"
}

yarn() {
  unset -f yarn
  load-nvm
  yarn "$@"
}
