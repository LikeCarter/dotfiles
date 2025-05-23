# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Increase Bash history size.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$(tty);

# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY=~/.node_history;
export NODE_REPL_HISTORY_SIZE='32768';
# Use sloppy mode by default, matching web browsers.
export NODE_REPL_MODE='sloppy';

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

# Log bash history.
function zshaddhistory() {
        echo "${1%%$'\n'}|${PWD}   " >> ~/.zsh_history_ext
}

# Add a bash function that colourizes piped JSON input. Prerequisite is python package pygments.
function json_colour() {
    echo "$1" | pygmentize -l json
}

# Add the rest of configs
source ~/dotfiles/.functions
source ~/dotfiles/.aliases

DISABLE_AUTO_UPDATE="true"
ZSH_HIGHLIGHT_MAXLENGTH=512
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

plugins=(git ruby zsh-bat zsh-autosuggestions you-should-use zsh-syntax-highlighting)

export UPDATE_ZSH_DAYS=13
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh
source $(brew --prefix asdf)/libexec/asdf.sh

# You can use the OP_BIOMETRIC_UNLOCK environment variable to temporarily toggle the 1Password CLI and 1Password app integration on or off.
OP_BIOMETRIC_UNLOCK_ENABLED=true

[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

bindkey "^b" backward-word
bindkey "^f" forward-word
