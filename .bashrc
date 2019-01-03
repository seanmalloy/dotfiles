# Sean Malloy's .bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# source global bash configuration
if [[ -f /etc/bashrc ]]; then
    . /etc/bashrc
fi

# set OS type and version
OS_TYPE="$(uname -s)" # Linux or Darwin
if [[ -f /etc/centos-release ]]; then
    OS_VERSION="RedHat$(awk '{print $4}' /etc/centos-release | awk -F. '{print $1}')"
elif [[ -f /etc/fedora-release ]]; then
    OS_VERSION="Fedora$(awk '{print $3}' /etc/fedora-release)"
elif [[ -f /etc/redhat-release ]]; then
    OS_VERSION="RedHat$(awk '{print $7}' /etc/redhat-release | awk -F. '{print $1}')"
elif [[ -f /etc/debian_version ]]; then
    OS_VERSION="Debian"
else
    OS_VERSION=""
fi

# Additional Bash Include Directory
export BASH_INCLUDE_DIR=$HOME/.bash_files

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable Colors
if [ -x /usr/bin/dircolors ]; then
    test -r $HOME/.dircolors && eval "$(dircolors -b $HOME/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -F'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Set Shell Options
set -o vi
set -o noclobber

export TECH_DIR=$HOME/tech         # top level dir for locally installed software
export BIN_DIR=$TECH_DIR/bin       # directory for scripts, binaries, etc.
export MAN_DIR=$TECH_DIR/share/man # directory for man pages
export PROJ_DIR=$HOME/projects     # directory for code projects
export VISUAL=nvim                 # neovim is my editor
export EDITOR=nvim                 # neovim is my editor
export HOSTNAME=$(hostname -s)     # Short hostname of this computer

# Go Lang Variables
export GOROOT=$TECH_DIR/go
export GOPATH=$PROJ_DIR/go

# Generic Aliases
alias ll='ls -l'
alias la='ls -A'
alias ltr='ls -ltr'
alias vi='nvim'
alias c='clear'
alias h='history'
alias j='jobs -l'
alias mkdir='mkdir -p'
alias df='df -h'
alias bin='cd $BIN_DIR'
alias tech='cd $TECH_DIR'
alias cd..='cd ..'
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../../..'

# Puppet Aliases
alias p='puppet'
alias pd='puppet describe'
alias pr='puppet resource'

# Set PATH
export PATH=/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games:/usr/local/MacGPG2/bin
for DIR in $GOROOT/bin $GOPATH/bin $HOME/.vim/bin $BIN_DIR $TECH_DIR/usr/local/bin; do
    if [[ -d $DIR ]]; then
        if [[ ! $PATH =~ $DIR ]]; then
            PATH=$DIR:$PATH
        fi
    fi
done

# Mac OSX Specific PATH
if [[ $OS_TYPE == "Darwin" ]]; then
    for DIR in $TECH_DIR/brew/bin $TECH_DIR/nvim-osx64/bin $TECH_DIR/brew/opt/gnu-tar/libexec/gnubin $TECH_DIR/brew/opt/coreutils/libexec/gnubin $TECH_DIR/brew/opt/findutils/libexec/gnubin $TECH_DIR/brew/opt/gnu-sed/libexec/gnubin $TECH_DIR/brew/opt/grep/libexec/gnubin; do
        if [[ -d $DIR ]]; then
            if [[ ! $PATH =~ $DIR ]]; then
                PATH=$DIR:$PATH
            fi
        fi
    done
fi

# TODO: set MANPATH for OSX
#
# $TECH_DIR/brew/opt/*/libexec/gnuman
# $TECH_DIR/brew/opt/gnu-tar/libexec/gnuman
# $TECH_DIR/brew/opt/coreutils/libexec/gnuman
# $TECH_DIR/brew/opt/findutils/libexec/gnuman
# $TECH_DIR/brew/opt/gnu-sed/libexec/gnuman
# $TECH_DIR/brew/opt/grep/libexec/gnuman
if [[ -n $MANPATH ]]; then
    export MANPATH=$MAN_DIR:$MANPATH
else
    export MANPATH=$MAN_DIR: # trailing : is required
fi

#### Git Setup ###
if [[ $OS_TYPE == "Darwin" ]]; then
    . /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
fi

eval "$(hub alias -s)"
if [ -f "$BASH_INCLUDE_DIR/hub-completion.bash" ]; then
    # Enable Hub Autocomplete
    . $BASH_INCLUDE_DIR/hub-completion.bash
fi

# From https://github.com/magicmonty/bash-git-prompt
if [ -f "$BASH_INCLUDE_DIR/bash-git-prompt/gitprompt.sh" ]; then
    # Add Git Magic to Prompt
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_FETCH_REMOTE_STATUS=1
    GIT_PROMPT_UNTRACKED_FILES=all
    GIT_PROMPT_SHOW_UPSTREAM=1
    . $BASH_INCLUDE_DIR/bash-git-prompt/gitprompt.sh
fi

### SSH Setup ##
SSH_DIR=$HOME/.ssh
SSH_SOCKET_DIR=$SSH_DIR/sockets
if [ ! -d "$SSH_SOCKET_DIR" ]; then
    mkdir -p $SSH_SOCKET_DIR
    chmod 700 $SSH_DIR
    chmod 700 $SSH_SOCKET_DIR
fi

### TMUX Setup ###
export TMUX_INCLUDE_FILE="$BASH_INCLUDE_DIR/tmux.bash"
. $TMUX_INCLUDE_FILE
alias tmux='tmux -L $TMUX_SOCKET'

### Tmuxinator Setup ###
export TMUXINATOR_INCLUDE_FILE="$BASH_INCLUDE_DIR/tmuxinator.bash"
. $TMUXINATOR_INCLUDE_FILE

# Enable ag auto complete
if [ -f "$BASH_INCLUDE_DIR/ag.bashcomp.sh" ]; then
    . $BASH_INCLUDE_DIR/ag.bashcomp.sh
fi

# Enable ripgrep Autocomplete
if [ -f "$BASH_INCLUDE_DIR/rg.bash-completion" ]; then
    . $BASH_INCLUDE_DIR/rg.bash-completion
fi

### FZF Setup ###
export FZF_INCLUDE_FILE="$BASH_INCLUDE_DIR/fzf.bash"
export FZF_DEFAULT_OPTS='-m -x'
. $FZF_INCLUDE_FILE

### Set Bash Prompt ###
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
NO_COLOR="\[\033[0m\]"
PS1="\u@\h$ "

### Shell Functions ###

# Create new puppet module
pmg() {
    local PUPPET_MODULE_NAME="$1"
    local PUPPET_MODULE_AUTHOR="seanmalloy"
    local PUPPET_MODULE_FULL_NAME="${PUPPET_MODULE_AUTHOR}-${PUPPET_MODULE_NAME}"

    if [[ -z $PUPPET_MODULE_NAME ]]; then
        echo "ERROR: must sepcify puppet module name!!!"
        return 1
    fi

    if [[ -e $PUPPET_MODULE_FULL_NAME ]]; then
        echo "ERROR: file $PUPPET_MODULE_FULL_NAME already exists!!!"
        return 1
    fi

    puppet module generate --skip-interview ${PUPPET_MODULE_FULL_NAME}
    if [[ $? -ne 0 ]]; then
        echo "ERROR: command 'puppet module generate ${PUPPET_MODULE_FULL_NAME}' failed!!!"
        return 1
    fi

    cd $PUPPET_MODULE_FULL_NAME
    git init .
}

# Dynamically start tmux sessions
proj() {
    if [[ -z $PROJ_DIR ]]; then
        echo "ERROR: PROJ_DIR environment variable not set"
        return 1
    fi
    local BASE_DIR=$PROJ_DIR

    if [[ ! -d $BASE_DIR ]]; then
        mkdir $BASE_DIR
    fi

    if [[ -z $1 ]]; then
        local DIR=$(locate --database $HOME/mlocate.db '.git' | grep "^$PROJ_DIR" | grep '.git$' | sed s'/\/\.git//' | fzf +m)
    else
        local DIR=$(locate --database $HOME/mlocate.db '.git' | grep "^$BASE_DIR" | grep '.git$' | sed s'/\/\.git//' | fzf +m -q $1 -1)
    fi
    local SESSION=$(echo $DIR | awk -F / '{print $NF}')

    tmux has-session -t $SESSION
    if [[ $? -ne 0 ]]; then
        # create new session
        mux start dynamic -n $SESSION workspace=$DIR
    else
        # attach existing session
        tmux attach -t $SESSION
    fi
}

# fuzzy find RPM packages
fzpkg() {
    repoquery -a --qf "%{name}.%{arch}" | fzf
}

# Build a locate database for my home dir
build_locate_db() {
    touch $HOME/.updatadb.lock
    flock --nonblock $HOME/.updatedb.lock updatedb --require-visibility no --database-root $HOME --output $HOME/mlocate.db
    local UPDATE_DB_RET_CODE=$?
    if [[ -e $HOME/mlocate.db ]]; then
        chmod 600 $HOME/mlocate.db
    fi
    return $UPDATE_DB_RET_CODE
}


### Custom Key Bindings ###

# CTRL-P: fzf RPM packages
bind '"\C-p":"$(fzpkg)\n"'

### Source Site Specific Config ###
export BASH_SITE_FILE="$HOME/.site_env"
if [[ ! -e $BASH_SITE_FILE ]]; then
    touch $BASH_SITE_FILE
fi
. $BASH_SITE_FILE

