#!/usr/bin/env bash

# Update MacOS software tools
softwareupdate --all --install --force

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

fancy_echo "Enter your desired computer name, typically <finitial><lastname><machine>: i.e. csprigingsm2:"
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

# In case computer is lost
fancy_echo "Enter your contact email if this computer is lost:"
read LOST_EMAIL
fancy_echo "Enter your phone if this computer is lost:"
read LOST_NUMBER

sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "If found, please contact $LOST_EMAIL or $LOST_NUMBER"

# Enable filevault encryption
sudo fdesetup enable

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

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

# Install GnuPG to enable PGP-signing commits.
brew install gnupg
brew install pinentry-mac
echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
killall gpg-agent

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
# Install file extension modifier
brew install duti

# Modify extensions
chmod +x duti.sh
source duti.sh

# Setup git config
cp .gitconfig ~/.gitconfig
git config --global credential.helper osxkeychain

# Update xcode
xcode-select --install

# Install asdf
brew install asdf
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc

fancy_echo "Installing via asdf: python, ruby, and nodejs..."

# Install asdf plugins
asdf plugin add python
asdf install python 3.11
asdf global python 3.11
asdf plugin add ruby
asdf install ruby latest
asdf plugin add nodejs
asdf install nodejs 18
asdf global nodejs 18

asdf reshim

# Setup pnpm
npm i -g pnpm

# Remove outdated versions from the cellar.
brew cleanup

# Fonts
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono

# TouchID to sudo
echo -e "auth sufficient pam_tid.so\n$(cat /etc/pam.d/sudo)" | sudo tee /etc/pam.d/sudo

brew install --cask 1password/tap/1password-cli
brew install --cask 1password
brew install google-chrome
brew install iterm2
brew install visual-studio-code
brew install slack
brew install spotify
brew install docker

# To automate mac app store installs
brew install mas
# Install tailscale
mas install 1475387142
# Install magnet
mas install 441258766

gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
git config --global user.signingkey xxxxxxxxxxxxxxxx
git config --global commit.gpgsign true
git config --global tag.gpgSign true
git config --global push.autoSetupRemote true

open -a iTerm .
