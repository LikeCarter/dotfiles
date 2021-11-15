sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

sudo chsh -s $(which zsh) $(whoami)

echo $0

xcode-select —-install

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update

brew install pyenv
brew install zsh
brew install nvm

pyenv install 3.9
nvm install 16

npm i -g yarn
