export LANG=en_US.UTF-8

DISABLE_AUTO_UPDATE="true"
export UPDATE_ZSH_DAYS=13
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh

export GOPATH=~/go
export PATH=$HOME/bin:/usr/local/bin:$GOPATH/bin:/opt/homebrew/sbin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source /opt/homebrew/opt/nvm/nvm.sh

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
