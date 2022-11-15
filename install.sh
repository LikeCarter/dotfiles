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
GIT_COMMITTER_NAME="$AUTHOR_NAME"
git config --global user.name "$AUTHOR_NAME"
GIT_AUTHOR_EMAIL="$EMAIL"
GIT_COMMITTER_EMAIL="$EMAIL"
git config --global user.email "$EMAIL"
EOF

git config --global --add --bool push.autoSetupRemote true

# In case computer is lost
fancy_echo "Enter your contact email if this computer is lost:"
read LOST_EMAIL
fancy_echo "Enter your phone if this computer is lost:"
read LOST_NUMBER

sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "If found, please contact $LOST_EMAIL or $LOST_NUMBER"

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
# brew install wget

# Install GnuPG to enable PGP-signing commits.
brew install gpg2 gnupg pinentry-mac       
echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
echo 'use-agent' > ~/.gnupg/gpg.conf
chmod 700 ~/.gnupg
killall gpg-agent
git config --global commit.gpgsign true
git config --global tag.gpgSign true

# Install more recent versions of some macOS tools.
brew install grep
brew install openssh
brew install git


# Install my workflow tools
brew install aws-vault
brew install go
brew install htop
brew install fd
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
# brew install google-chrome
brew install iterm2
brew install visual-studio-code
brew install slack
brew install spotify

# Install optional packages
# brew install docker

# Update xcode
xcode-select --install

# Install asdf
brew install asdf
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc

fancy_echo "Installing via asdf: python, ruby, and nodejs..."

# Install asdf plugins
asdf plugin add python
asdf install python 3.9.15
asdf global python 3.9.15
asdf plugin add ruby
asdf install ruby latest
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest

asdf plugin-add poetry https://github.com/asdf-community/asdf-poetry.git
asdf install poetry latest
# Make compatible with asdf.
poetry config virtualenvs.prefer-active-python true

asdf reshim

# Setup python
pip install --upgrade pip

# Install pdm
# chown -R $(whoami) ~/.local
# brew install pdm

# To automate mac app store installs
brew install mas

# Install tailscale
mas install 1475387142

# Install magnet
# mas install 441258766

# Setup pnpm
npm i -g pnpm

# Remove outdated versions from the cellar.
brew cleanup

# Fonts
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono

# TouchID to sudo
echo -e "auth sufficient pam_tid.so\n$(cat /etc/pam.d/sudo)" | sudo tee /etc/pam.d/sudo

# Setup aws-vault
fancy_echo "Create your first aws-vault:"
read $awsvaultname
aws-vault add $awsvaultname

open -a iTerm .


# ----------------------------------------------------------
# ----Disables signing in as Guest from the login screen----
# ----------------------------------------------------------
echo '--- Disables signing in as Guest from the login screen'
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------Disables Guest access to file shares over AF-------
# ----------------------------------------------------------
echo '--- Disables Guest access to file shares over AF'
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------Disables Guest access to file shares over SMB-------
# ----------------------------------------------------------
echo '--- Disables Guest access to file shares over SMB'
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO
# ----------------------------------------------------------


# ----------------------------------------------------------
# -Disable remote login (incoming SSH and SFTP connections)-
# ----------------------------------------------------------
echo '--- Disable remote login (incoming SSH and SFTP connections)'
echo 'yes' | sudo systemsetup -setremotelogin off
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------Disable insecure TFTP service---------------
# ----------------------------------------------------------
echo '--- Disable insecure TFTP service'
sudo launchctl disable 'system/com.apple.tftpd'
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------Disable Bonjour multicast advertising-----------
# ----------------------------------------------------------
echo '--- Disable Bonjour multicast advertising'
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------Disable insecure telnet protocol-------------
# ----------------------------------------------------------
echo '--- Disable insecure telnet protocol'
sudo launchctl disable system/com.apple.telnetd
# ----------------------------------------------------------


# ----------------------------------------------------------
# --Disable sharing of local printers with other computers--
# ----------------------------------------------------------
echo '--- Disable sharing of local printers with other computers'
cupsctl --no-share-printers
# ----------------------------------------------------------


# ----------------------------------------------------------
# -Disable printing from any address including the Internet-
# ----------------------------------------------------------
echo '--- Disable printing from any address including the Internet'
cupsctl --no-remote-any
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------Disable remote printer administration-----------
# ----------------------------------------------------------
echo '--- Disable remote printer administration'
cupsctl --no-remote-admin
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Enable application firewall----------------
# ----------------------------------------------------------
echo '--- Enable application firewall'
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true
defaults write com.apple.security.firewall EnableFirewall -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------------Turn on firewall logging-----------------
# ----------------------------------------------------------
echo '--- Turn on firewall logging'
/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------------Turn on stealth mode-------------------
# ----------------------------------------------------------
echo '--- Turn on stealth mode'
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
defaults write com.apple.security.firewall EnableStealthMode -bool true
# ----------------------------------------------------------


# Prevent automatically allowing incoming connections to signed apps
echo '--- Prevent automatically allowing incoming connections to signed apps'
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false
# ----------------------------------------------------------


# Prevent automatically allowing incoming connections to downloaded signed apps
echo '--- Prevent automatically allowing incoming connections to downloaded signed apps'
sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false
# ----------------------------------------------------------

# Prevent automatically allowing incoming connections to downloaded signed apps
echo '--- Allow TouchID for Sudo'
echo -e "auth sufficient pam_tid.so\n$(cat /etc/pam.d/sudo)" | sudo tee /etc/pam.d/sudo
# ----------------------------------------------------------

# ----------------------------------------------------------
# ---------Disable Internet based spell correction----------
# ----------------------------------------------------------
echo '--- Disable Internet based spell correction'
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false
# ----------------------------------------------------------

# ----------------------------------------------------------
# ---------Deactivate the Remote Management Service---------
# ----------------------------------------------------------
echo '--- Deactivate the Remote Management Service'
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop
# ----------------------------------------------------------
