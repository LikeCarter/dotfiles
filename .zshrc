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

# Initialize homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Paths and go
export GOPATH=~/go
export PATH=$HOME/bin:/usr/local/bin:$GOPATH/bin:/opt/homebrew/sbin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH

# Paths and sed
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

# Paths and vscode
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"

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
source ~/dotfiles/.functions
source ~/dotfiles/.aliases
source ~/dotfiles/.chamber

# This should always be last
ZSH_HIGHLIGHT_MAXLENGTH=512
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
plugins=(git ruby zsh-syntax-highlighting)
