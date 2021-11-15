# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$(tty);

# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY=~/.node_history;
# Allow 32³ entries; the default is 1000.
export NODE_REPL_HISTORY_SIZE='32768';
# Use sloppy mode by default, matching web browsers.
export NODE_REPL_MODE='sloppy';

DISABLE_AUTO_UPDATE="true"
export UPDATE_ZSH_DAYS=13
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh

# Set paths
export GOPATH=~/go
export PATH=$HOME/bin:/usr/local/bin:$GOPATH/bin:/opt/homebrew/sbin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH

# Setup the nvm package
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source /opt/homebrew/opt/nvm/nvm.sh

# Setup the pyenv package
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='nano'
fi

alias jog='grep -v "jog" ~/.zsh_history_ext | grep -a --color=never "${PWD}   " | cut -f1 -d"⋮" | tail'
alias zshconfig="nano ~/.zshrc"

# Log bash history.
function zshaddhistory() {
        echo "${1%%$'\n'}|${PWD}   " >> ~/.zsh_history_ext
}

# Add a bash function that colourizes piped JSON input. Prerequisite is python package pygments.
function json_colour() {
    echo "$1" | pygmentize -l json
}

# Add the rest of my configs
source ~/dotfiles/.extra
source ~/dotfiles/.functions
source ~/dotfiles/.aliases

# Create git signing key
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
git config --global user.signingkey 3AA5C34371567BD2
git config --global commit.gpgsign true
