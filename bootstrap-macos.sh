#!/bin/bash

set -e

xcode-select --install
sudo xcodebuild -license

echo "Installing homebrew..." && \
  /bin/bash -c "$(curl -fssl https://raw.githubusercontent.com/homebrew/install/head/install.sh)"

echo "Installing tools..." && \
  /opt/homebrew/bin/brew install tmux fzf nvim the_silver_searcher ripgrep fzf fd nvm node yarn speedtest-cli && \
  # /opt/homebrew/bin/brew install coreutils zsh
  /opt/homebrew/opt/fzf/install && \
  . /opt/homebrew/opt/nvm/nvm.sh && \
  nvm install --lts

echo "Installing casks" && \
  brew install --cask google-chrome iterm2 telegram-desktop notion spotify raycast vlc visual-studio-code transmission

echo "Installing neovim plugins" && \
  # pip3 install neovim && \
  nvim --headless "+Lazy! install" +qa
