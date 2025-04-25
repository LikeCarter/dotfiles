#!/bin/bash

# Function to install zsh and related configurations
setup_development_baseline() {
  # Install zsh and related configurations
  echo "Installing zsh ..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  sudo chsh -s $(which zsh) $(whoami)
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/fdellwing/zsh-bat.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-bat
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
  cp ./.zshrc ~/.zshrc

  # Update macOS software tools
  softwareupdate --all --install --force

  # Set computer name and configure git
  echo "Enter your desired computer name, <finitial><lastname><machine>: i.e. csprigingsm2:"
  read COMPUTER_NAME
  sudo scutil --set ComputerName "$COMPUTER_NAME"
  sudo scutil --set HostName "$COMPUTER_NAME"
  sudo scutil --set LocalHostName "$COMPUTER_NAME"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"

  echo "Enter your email for git contributions:"
  read EMAIL
  echo "Enter your name for git contributions:"
  read AUTHOR_NAME
  cat > .extra << EOF
#!/usr/bin/env bash
GIT_AUTHOR_NAME="$AUTHOR_NAME"
GIT_COMMITTER_NAME="$AUTHOR_NAME"
GIT_AUTHOR_EMAIL="$EMAIL"
GIT_COMMITTER_EMAIL="$EMAIL"
git config --global user.name "$AUTHOR_NAME"
git config --global user.email "$EMAIL"
EOF

  # Configure contact message if computer is lost
  echo "Enter your contact email if this computer is lost:"
  read LOST_EMAIL
  echo "Enter your phone if this computer is lost:"
  read LOST_NUMBER
  sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "If found, please contact $LOST_EMAIL or $LOST_NUMBER"

  # Install command-line tools using Homebrew
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew update
  brew upgrade
  BREW_PREFIX=$(brew --prefix)
  sudo chown -R $(whoami) $(brew --prefix)/*
  brew install coreutils moreutils findutils gnu-sed gnupg pinentry-mac grep openssh exa git aws-vault go htop fd awscli terraform duti mas gh
  ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

  # Other configurations
  cp .gitconfig ~/.gitconfig
  git config --global credential.helper osxkeychain
  git config --global push.autoSetupRemote true

  # Update xcode
  xcode-select --install

  # Install asdf and plugins
  brew install asdf
  echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc
  echo "Installing via asdf: python, ruby, and nodejs..."
  asdf plugin add python
  asdf install python latest
  asdf global python latest
  asdf plugin add latest
  asdf install ruby latest
  asdf plugin add nodejs
  asdf install nodejs lts
  asdf global nodejs lts
  asdf reshim

  # Setup pnpm
  curl -fsSL https://get.pnpm.io/install.sh | sh -

  # Remove outdated versions from the cellar
  brew cleanup
}

# Function to setup application baseline
setup_application_baseline() {
  echo "You may be prompted for your password at certain steps (for sudo)."
  # Run yes/no installers for applications
  ./applications.sh
}

# Function to setup security baseline
setup_security_baseline() {
  ./security.sh
}

# Main script
read -p "Setup development baseline? [y/N] " ANSWER
if [[ $ANSWER = "y" ]]; then
  setup_development_baseline
fi

read -p "Setup application baseline? [y/N] " ANSWER
if [[ $ANSWER = "y" ]]; then
  setup_application_baseline
fi

read -p "Setup security baseline? [y/N] " ANSWER
if [[ $ANSWER = "y" ]]; then
  setup_security_baseline
fi

echo "Setup complete!"
