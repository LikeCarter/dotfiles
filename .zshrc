export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="robbyrussell"

export GOPATH=~/go
export PATH=$HOME/bin:/usr/local/bin:$GOPATH/bin:/opt/homebrew/sbin:$PATH

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
