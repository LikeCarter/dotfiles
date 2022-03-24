#!/usr/bin/env bash

# Update MacOS software tools
softwareupdate --all --install --force

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

fancy_echo "Enter your desired computer name:"
read COMPUTER_NAME

sudo scutil --set ComputerName "$COMPUTER_NAME"
sudo scutil --set HostName "$COMPUTER_NAME"
sudo scutil --set LocalHostName "$COMPUTER_NAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"

fancy_echo "Enter your desired email for git contributions:"
read EMAIL
fancy_echo "Enter your desired name for git contributions:"
read AUTHOR_NAME

cat > .extra << EOF
#!/usr/bin/env bash
GIT_AUTHOR_NAME="$AUTHOR_NAME"
GIT_COMMITTER_NAME="\$GIT_AUTHOR_NAME"
git config --global user.name "\$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="$EMAIL"
GIT_COMMITTER_EMAIL="\$GIT_AUTHOR_EMAIL"
git config --global user.email "\$GIT_AUTHOR_EMAIL"
EOF

# In case computer is lost
fancy_echo "Enter your contact email if this computer is lost:"
read LOST_EMAIL

sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "If found, please contact $LOST_EMAIL"

# Enable filevault encryption
sudo fdesetup enable

# Enable the firewall
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Disable Notification Center and remove the menu bar icon
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Show batter percentage
defaults write com.apple.menuextra.battery ShowPercent -bool true

# Show the date in the toolbar
defaults write com.apple.menuextra.clock DateFormat -string 'EEE MMM d  H:mm'

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Disable sound effects when changing volume
defaults write NSGlobalDomain com.apple.sound.beep.feedback -integer 0

# Disable sounds effects for user interface changes
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0

# Set alert volume to 0
defaults write NSGlobalDomain com.apple.sound.beep.volume -float 0.0

# Show volume in the menu bar
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.volume" -int 0

# Show Bluetooth in the menu bar
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.bluetooth" -int 0

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Don't hide files
defaults write com.apple.Finder AppleShowAllFiles true

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Fix key repeat in vs code. I don't use it that often, but this is necessary when I do
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# Speed up window opening by disabling animation
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO

# Reboot systemUIServer and the dock to enable defaults to take effect
killall -KILL Dock
killall -KILL SystemUIServer

# Install my shell
fancy_echo "Installing zsh ..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo chsh -s $(which zsh) $(whoami)

# Install zsh syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install my custom configuration file...
cp ./.zshrc ~/.zshrc

# Install command-line tools using Homebrew.
fancy_echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

echo "Make sure you are running this with sudo:"
sudo chown -R $(whoami) $(brew --prefix)/*

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed

# Install `wget`
brew install wget

# Install GnuPG to enable PGP-signing commits.
brew install gnupg
brew install pinentry-mac
echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
killall gpg-agent

# Install more recent versions of some macOS tools.
brew install grep
brew install openssh
brew install git

brew install pnpm

# Install my workflow tools
brew install aws-vault
brew install go
brew install htop
brew install awscli
brew install terraform
brew install duti # Install file extension modifier

# Modify extensions
chmod +x duti.sh
source duti.sh

# Setup git config
cp .gitconfig ~/.gitconfig
git config --global credential.helper osxkeychain

# Install some of my preferred applications
brew install 1password
brew install google-chrome
brew install iterm2
brew install visual-studio-code
brew install slack
brew install spotify

brew install stats

# brew install lazydocker
# brew install lazygit

# Install optional packages
brew install docker

# Update xcode
xcode-select —-install

# Install asdf
brew install asdf
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc

fancy_echo "Installing via asdf: python, ruby, and nodejs..."

# Install asdf plugins
asdf plugin add python
asdf install python 3.9.4
asdf global python 3.9.4
asdf plugin add ruby
asdf install ruby latest
asdf plugin add nodejs
asdf install nodejs 16.13.2
asdf global nodejs 16.13.2

asdf reshim
pip install --upgrade pip

# Install pdm
chown -R $(whoami) ~/.local
brew install pdm

# To automate mac app store installs
brew install mas

# Install tailscale
mas install 1475387142

# Install magnet
mas install 441258766

# Setup node
npm i -g yarn

# Setup python
pip install --upgrade pip

# Install chamber of secrets
brew install chamber
./chamber.sh

# Remove outdated versions from the cellar.
brew cleanup

# Fonts
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono

# Setup aws-vault
fancy_echo "Create your first aws-vault:"
read $awsvaultname
aws-vault add $awsvaultname

open -a iTerm .
