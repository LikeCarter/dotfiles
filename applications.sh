#!/bin/bash

# Function to install default applications
install_default_apps() {
  brew install --cask 1password/tap/1password-cli
  brew install --cask 1password
  brew install google-chrome
  brew install iterm2
  brew install visual-studio-code
  brew install slack
  brew install spotify
  brew install orbstack
  brew install neovim
  brew install gh
}

# Function to install Magnet (application window resizing)
install_magnet() {
  mas install 441258766
}

# Function to install Tailscale
install_tailscale() {
  mas install 1475387142
}

# Function to install the interactive rebase tool for Git
install_interactive_rebase_tool() {
  brew install git-interactive-rebase-tool
  git config --global sequence.editor interactive-rebase-tool
}

# Function to setup 1Password git signing
setup_1password_git_signing() {
  git config --global commit.gpgsign true
  git config --global tag.gpgSign true
  echo "Please finish setup in the 1Password application."
}

# Main script

brew install mas

read -p "Install default apps (1password, chrome, iterm2, vscode, slack, spotify, docker)? [y/N] " ANSWER
if [[ $ANSWER = "y" ]]; then
  install_default_apps
fi

read -p "Install Magnet (application window resizing)? [y/N] " ANSWER
if [[ $ANSWER = "y" ]]; then
  install_magnet
fi

read -p "Install Tailscale? [y/N] " ANSWER
if [[ $ANSWER = "y" ]]; then
  install_tailscale
fi

read -p "Install interactive rebase tool? [y/N] " ANSWER
if [[ $ANSWER = "y" ]]; then
  install_interactive_rebase_tool
fi

read -p "Do you want to setup 1Password git signing? [y/N] " ANSWER
if [[ $ANSWER = "y" ]]; then
  setup_1password_git_signing
fi

brew cleanup
