#!/bin/bash

# Function to install zsh and related configurations
# Install zsh and related configurations
echo "Installing zsh ..."
# Prevent Oh My Zsh installer from exiting the script
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
# Change default shell to zsh (this doesn't exit the script, just changes the default for future sessions)
sudo chsh -s "$(which zsh)" "$(whoami)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/fdellwing/zsh-bat.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-bat
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
cp ./.zshrc ~/.zshrc

# Update macOS software tools
softwareupdate --all --install --force

# Set computer name and configure git
echo "Enter your desired computer name, <finitial><lastname><machine>: i.e. flastnamem4:"
read COMPUTER_NAME
sudo scutil --set ComputerName "$COMPUTER_NAME"
sudo scutil --set HostName "$COMPUTER_NAME"
sudo scutil --set LocalHostName "$COMPUTER_NAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"

# Configure contact message if computer is lost
echo "Enter your contact email if this computer is lost:"
read LOST_EMAIL
echo "Enter your phone if this computer is lost:"
read LOST_NUMBER
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "If found, contact $LOST_EMAIL or $LOST_NUMBER"

# Install command-line tools using Homebrew
echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew update && brew upgrade
BREW_PREFIX=$(brew --prefix)
sudo chown -R $(whoami) $(brew --prefix)/*
brew install coreutils moreutils findutils gnu-sed gnupg pinentry-mac grep openssh exa git aws-vault go htop fd awscli terraform duti mas gh
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Other configurations
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
asdf plugin add pnpm
asdf install pnpm latest
asdf reshim

# Remove outdated versions from the cellar
brew cleanup

./system.sh

read -p "Setup application baseline? [y/N] " ANSWER
if [[ $ANSWER = "y" ]]; then
  ./applications.sh
fi

echo "Setup complete!"

