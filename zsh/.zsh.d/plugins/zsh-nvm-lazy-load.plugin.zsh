#!/usr/bin/env zsh

# based on https://github.com/undg/zsh-nvm-lazy-load

load-nvm() {
  export NVM_DIR="$HOME/.nvm"
  local NVM_ROOT_DIR="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/nvm"

  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [[ -o interactive ]] && [ -s "$NVM_ROOT_DIR/etc/bash_completion.d/nvm" ] && . "$NVM_ROOT_DIR/etc/bash_completion.d/nvm"

  function load-nvm {}
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

npx() {
  unset -f npx
  load-nvm
  npx "$@"
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
