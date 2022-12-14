#!/usr/bin/env bash

# Install zsh first.
# This may exit the current shell, so we run it first, so we don't lose progress.
echo "Installing zsh ..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo chsh -s $(which zsh) $(whoami)
# Install zsh syntax-highlighting.
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# Install zshrc configuration.
cp ./.zshrc ~/.zshrc

# Update MacOS software tools
softwareupdate --all --install --force

# Move dotfiles into correct location, if not already.
mkdir -p ~/dotfiles
cp .functions ~/dotfiles/
cp .aliases ~/dotfiles/

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT
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



# Contact message if computer is lost.
echo "Enter your contact email if this computer is lost:"
read LOST_EMAIL
echo "Enter your phone if this computer is lost:"
read LOST_NUMBER
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "If found, please contact $LOST_EMAIL or $LOST_NUMBER"

# Install command-line tools using Homebrew.
echo "Installing Homebrew..."
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
brew install exa # Modern `ls` replacement.
# Newer version of git.
brew install git
# Install workflow tools.
brew install aws-vault
brew install go
brew install htop
brew install fd
brew install awscli
brew install terraform
# Install file extension modifier.
brew install duti
# Install MacOS App Store CLI.
brew install mas
# Install github cli for easier authentication.
brew install gh

# Setup git config.
cp .gitconfig ~/.gitconfig
git config --global credential.helper osxkeychain
git config --global push.autoSetupRemote true

# Update xcode.
xcode-select --install

# Install asdf.
brew install asdf
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc
# Install asdf plugins.
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

# Setup pnpm.
curl -fsSL https://get.pnpm.io/install.sh | sh -

ANSWER=N
read ANSWER\?"Use JetBrains monospace font? [y/N] "
if [[ $ANSWER = "y" ]]; then
  brew tap homebrew/cask-fonts
  brew install --cask font-jetbrains-mono
fi

ANSWER=N
read ANSWER\?"Install default apps (1password, chrome, etc.)? [y/N] "
if [[ $ANSWER = "y" ]]; then
  brew install --cask 1password/tap/1password-cli
  brew install --cask 1password
  brew install google-chrome
  brew install iterm2
  brew install visual-studio-code
  brew install slack
  brew install spotify
  # Must be installed in this order exactly.
  brew install --cask docker
  brew install docker
  brew install gh
fi

ANSWER=N
read ANSWER\?"Install interactive rebase tool? [y/N] "
if [[ $ANSWER = "y" ]]; then
  brew install git-interactive-rebase-tool
  git config --global sequence.editor interactive-rebase-tool
fi

ANSWER=N
read ANSWER\?"Install Magnet (application window resizing)? [y/N] "
if [[ $ANSWER = "y" ]]; then
  mas install 441258766
fi

ANSWER=N
read ANSWER\?"Install Tailscale (wireguard)? [y/N] "
if [[ $ANSWER = "y" ]]; then
  mas install 1475387142
fi

ANSWER=N
read ANSWER\?"Set default system preferences? [y/N] "
if [[ $ANSWER = "y" ]]; then
  for f in ./preferences/system/*.sh; do
    echo "$f"
    bash "$f"
  done
fi

ANSWER=N
read ANSWER\?"Set default application preferences? [y/N] "
if [[ $ANSWER = "y" ]]; then
  for f in ./preferences/application/*.sh; do
    echo "$f"
    bash "$f"
  done
fi

ANSWER=N
read ANSWER\?"Are you manually setting up 1Password git signing? [y/N] "
if [[ $ANSWER = "y" ]]; then
  git config --global commit.gpgsign true
  git config --global tag.gpgSign true
  echo "Please complete setup by following the manual steps in the README."
fi

# This should be last as it has some awkward security prompts
# that can interrupt the flow.
ANSWER=N
read ANSWER\?"Set security baseline? [y/N] "
if [[ $ANSWER = "y" ]]; then
  for f in ./preferences/security/*.sh; do
    echo "$f"
    bash "$f"
  done
fi

# Remove outdated versions from the cellar.
brew cleanup

./preferences/post.sh
