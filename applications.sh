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
  brew install --cask docker
  brew install docker
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

# Function to install NextDNS
install_nextdns() {
  mas install 1464122853
}

# Function to set default application and system preferences
set_default_preferences() {
  for f in ./preferences/*.sh; do
    echo "$f"
    bash "$f"
  done
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

read -p "Install NextDNS? [y/N] " ANSWER
if [[ $ANSWER = "y" ]]; then
  install_nextdns
fi

read -p "Set default application and system preferences? [y/N] " ANSWER
if [[ $ANSWER = "y" ]]; then
  set_default_preferences
fi

read -p "Install interactive rebase tool? [y/N] " ANSWER
if [[ $ANSWER = "y" ]]; then
  install_interactive_rebase_tool
fi

read -p "Do you want to setup 1Password git signing? [y/N] " ANSWER
if [[ $ANSWER = "y" ]]; then
  setup_1password_git_signing
fi

# Remove outdated versions from the cellar.
brew cleanup
