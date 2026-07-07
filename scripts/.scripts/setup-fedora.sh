#!/usr/bin/env bash

set -euo pipefail

reboot_is_needed=false

function install_base() {
  echo "Installing base packages..."

  sudo dnf upgrade -y

  # fuse-libs is needed for AppImage to work correctly
  sudo dnf install fuse-libs tmux zsh git delta fzf the_silver_searcher \
    zoxide pass nodejs rust -y
}

function install_neovim() {
  if command -v nvim &> /dev/null; then
    return
  fi

  sudo dnf -y install ninja-build cmake gcc make gettext curl glibc-gconv-extra git

  (
    git clone --depth=1 https://github.com/neovim/neovim /tmp/neovim
    cd /tmp/neovim
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    cd /
    rm -rf /tmp/neovim
  )
}

function install_snap() {
  if command -v snap &> /dev/null; then
    return
  fi

  echo "Installing snap..."

  sudo dnf install snapd -y
  sudo ln -sf /var/lib/snapd/snap /snap
  sudo systemctl enable --now snapd.socket

  export PATH="/var/lib/snapd/snap/bin:$PATH"

  reboot_is_needed=true
}

function install_gui() {
  echo "Installing GUI apps..."

  sudo snap install obsidian --classic
  sudo snap install ghostty --classic
}

function install_docker() {
  if command -v docker &> /dev/null; then
    return
  fi

  echo "Installing docker..."

  sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
}

function install_agents() {
  echo "Installing agents..."

  if ! command -v agy &> /dev/null; then
    curl -fsSL https://antigravity.google/cli/install.sh | bash
    agy plugin install https://github.com/obra/superpowers
  fi

  if ! command -v opencode &> /dev/null; then
    curl -fsSL https://opencode.ai/install | bash
  fi
}

function install_tailscale() {
  echo "Installing tailscale..."

  if command -v tailscale &> /dev/null; then
    return
  fi

  curl -fsSL https://tailscale.com/install.sh | sh
}

function setup_shell() {
  echo "Setting up shell..."

  local target_shell
  target_shell=$(which zsh)

  if [ "$SHELL" != "$target_shell" ]; then
    sudo chsh -s "$target_shell" "$USER"
    reboot_is_needed=true
  fi
}

install_base
install_neovim
install_snap
install_gui
install_docker
install_agents
install_tailscale
setup_shell

if [ "$reboot_is_needed" = true ]; then
  echo "--------------------------------------------------------"
  echo "System configuration changes require a reboot or logout."
  echo "--------------------------------------------------------"

  read -p "Would you like to reboot now? [y/N]: " -r response

  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Rebooting system..."
    sudo reboot
  else
    echo "Please log out or reboot manually to apply all changes."
  fi
fi

