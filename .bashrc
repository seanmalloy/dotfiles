# Sean Malloy's .bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# source global bash configuration
if [[ -f /etc/bashrc ]]; then
    . /etc/bashrc
fi

### Source Site Specific Config ###
export BASH_SITE_FILE="$HOME/.site_env"
if [[ ! -e $BASH_SITE_FILE ]]; then
    touch $BASH_SITE_FILE
fi
. $BASH_SITE_FILE


# set OS type and version
if [[ -n $(which facter 2> /dev/null) ]]; then
    OS_VERSION="$(facter osfamily)" # RedHat, Debian, etc
    OS_VERSION="${OS_VERSION}$(facter operatingsystemmajrelease)"
else
    # no facter ... must check stuff manually :-(
    if [[ -f /etc/centos-release ]]; then
        OS_VERSION="RedHat$(awk '{print $4}' /etc/centos-release | awk -F. '{print $1}')"
    elif [[ -f /etc/redhat-release ]]; then
        OS_VERSION="RedHat$(awk '{print $7}' /etc/redhat-release | awk -F. '{print $1}')"
    elif [[ -f /etc/debian_version ]]; then
        OS_VERSION="Debian"
    else
        OS_VERSION=""
    fi
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
export VISUAL=vim                  # vim is my editor
export EDITOR=vim                  # vim is my editor
export RELEASE_TESTING=1           # For Perl Module Development
export HOSTNAME=$(hostname -s)     # Short hostname of this computer

# Go Lang Variables
export GOROOT=$TECH_DIR/go
export GOPATH=$PROJ_DIR/go

# Generic Aliases
alias ll='ls -l'
alias la='ls -A'
alias ltr='ls -ltr'
alias vi='vim'
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
export PATH=/usr/bin:/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games:/usr/local/bin
for DIR in $GOROOT/bin $GOPATH/bin HOME/.plenv/bin $HOME/.vim/bin $BIN_DIR; do
    if [[ -d $DIR ]]; then
        if [[ ! $PATH =~ $DIR ]]; then
            PATH=$DIR:$PATH
        fi
    fi
done

export MANPATH=$MAN_DIR:$MAN_PATH

### Setup plenv ###
if [[ -n "$(which plenv 2> /dev/null)" ]]; then
    eval "$(plenv init -)"
fi

### Enable RH Software Collections ###
# See RH solution # 527703
if (( $ENABLE_RUBY_SCL )); then
    unset X_SCLS
    if [[ -n "$(which scl 2> /dev/null)" ]]; then
        # Enable Ruby 2.2 or 2.0
        if
            scl -l | grep -q rh-ruby22
        then
            source scl_source enable rh-ruby22
        elif
            scl -l | grep -q ruby200
        then
            source scl_source enable ruby200
        else
            echo "Using system Ruby"
        fi
    fi
fi

#### Git Setup ###
eval "$(hub alias -s)"
if [[ $OS_VERSION != 'RedHat7' ]]; then
    if [ -f "$BASH_INCLUDE_DIR/git-completion.bash" ]; then
        # Enable Git Autocomplete
        . $BASH_INCLUDE_DIR/git-completion.bash
    fi
fi

if [ -f "$BASH_INCLUDE_DIR/hub-completion.bash" ]; then
    # Enable Hub Autocomplete
    . $BASH_INCLUDE_DIR/hub-completion.bash
fi

if [ -f "$BASH_INCLUDE_DIR/git-prompt.bash" ]; then
    # Add Git Branch To Prompt
    export GIT_PS1_SHOWDIRTYSTATE=1
    . $BASH_INCLUDE_DIR/git-prompt.bash
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

# Enable tmux Autocomplete
if [ -f "$BASH_INCLUDE_DIR/tmux-completion.bash" ]; then
    . $BASH_INCLUDE_DIR/tmux-completion.bash
fi

### Tmuxinator Setup ###
export TMUXINATOR_INCLUDE_FILE="$BASH_INCLUDE_DIR/tmuxinator.bash"
. $TMUXINATOR_INCLUDE_FILE

### FZF Setup ###
export FZF_INCLUDE_FILE="$BASH_INCLUDE_DIR/fzf.bash"
export FZF_DEFAULT_OPTS='-m -x'
. $FZF_INCLUDE_FILE

### Set Bash Prompt ###
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
NO_COLOR="\[\033[0m\]"
PS1="\u@\h $RED\W$YELLOW\$(__git_ps1)$NO_COLOR$ "

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

# switch to a project directory
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
        local DIR=$(find $BASE_DIR -maxdepth 1 -type d -print | grep -v "^$BASE_DIR$" | grep -v '.git$' | awk -F / '{print $NF}' | fzf +m)
    else
        local DIR=$(find $BASE_DIR -maxdepth 1 -type d -print | grep -v "^$BASE_DIR$" | grep -v '.git$' | awk -F / '{print $NF}' | fzf +m -q $1 -1)
    fi
    mux start dynamic -n $DIR workspace=$BASE_DIR/$DIR
}

# fuzzy find RPM packages
fzpkg() {
    repoquery -a --qf "%{name}.%{arch}" | fzf
}


### Custom Key Bindings ###

# CTRL-P: fzf RPM packages
bind '"\C-p":"$(fzpkg)\n"'

