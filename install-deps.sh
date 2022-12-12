#!/bin/bash

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install core
brew install coreutils fzf tmux nvm node

# install nvim
brew install nvim the_silver_searcher
pip3 install neovim
