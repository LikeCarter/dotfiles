#!/usr/bin/env bash

# Install my shell
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo chsh -s $(which zsh) $(whoami)

# Install command-line tools using Homebrew.
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install `wget` with IRI support.
brew install wget --with-iri

# Install GnuPG to enable PGP-signing commits.
brew install gnupg
brew install pinentry-mac
echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
killall gpg-agent


# Install more recent versions of some macOS tools.
brew install grep
brew install openssh
brew install git

# Setup git config
cp .gitconfig ~/.gitconfig

# Update xcode
xcode-select —-install

# Install my workflow tools
brew install pyenv
brew install zsh
brew install nvm
brew install aws-vault
brew install go

# Install chamber of secrets
go get github.com/segmentio/chamber

# Setup aws-vault
aws-vault add <name>

pyenv install 3.9
nvm install 16
npm i -g yarn

# Remove outdated versions from the cellar.
brew cleanup
