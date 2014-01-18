# Sean Malloy's .bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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
export PERLBREW_ROOT=/opt/perl5    # Top level perlbrew directory
export HOSTNAME=$(hostname -s)     # Short hostname of this computer

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

# Set PATH
export PATH=$HOME/.vim/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games:/usr/local/bin

# Source Perlbrew Environment
PERLBREW_ENV_FILE=/opt/perl5/etc/bashrc
if [ -f "$PERLBREW_ENV_FILE" ]; then
    source $PERLBREW_ENV_FILE
fi

# Update PATH
if [ -d "$BIN_DIR" ]; then
    PATH=$BIN_DIR:$PATH
fi
export MANPATH=$MAN_DIR:$MAN_PATH

#### Git Setup ###
if [ -f "$BASH_INCLUDE_DIR/git-completion.bash" ]; then
    # Enable Git Autocomplete
    . $BASH_INCLUDE_DIR/git-completion.bash
fi
if [ -f "$BASH_INCLUDE_DIR/git-prompt.bash" ]; then
    # Add Git Branch To Prompt
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
function attach() {
    local MY_SESSION=$1
    shift

    if [ -z "$TMUX_BIN" ]; then
        return
    fi

    if [ -z "$MY_SESSION" ]; then
        $TMUX_BIN -S $TMUX_SOCKET list-sessions
        return
    fi

    if ! $TMUX_BIN -q -S $TMUX_SOCKET has-session -t $MY_SESSION; then
        # session does not exist, create one
        $TMUX_BIN -S $TMUX_SOCKET new-session -d -n $MY_SESSION -s $MY_SESSION
        $TMUX_BIN -S $TMUX_SOCKET attach -t $MY_SESSION
    else
        if [ -z "$TMUX" ]; then
            local TMUX_CLIENTS=$($TMUX_BIN -S $TMUX_SOCKET list-clients -t $MY_SESSION)
            if [ -z "$TMUX_CLIENTS" ]; then
                $TMUX_BIN -S $TMUX_SOCKET attach -t $MY_SESSION
            fi
        fi
    fi
}

TMUX_BIN=$(which tmux)
if [ -n "$TMUX_BIN" ]; then
    export TMUX_DIR=$HOME/.tmux.d
    export TMUX_SOCKET_DIR=$HOME/.tmux.d/sockets
    if [ ! -d "$TMUX_SOCKET_DIR" ]; then
        mkdir -p $TMUX_SOCKET_DIR
        chmod 700 $TMUX_DIR
        chmod 700 $TMUX_SOCKET_DIR
    fi
    export TMUX_SESSION=$HOSTNAME
    export TMUX_SOCKET=$TMUX_SOCKET_DIR/$TMUX_SESSION
    attach $TMUX_SESSION
fi

### Set Bash Prompt ###
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
NO_COLOR="\[\033[0m\]"
PS1="\u@\h $RED\W$YELLOW\$(__git_ps1)$NO_COLOR$ "

### Shell Functions ###
function proj() {
    if [ -z "$PROJ_DIR" ]; then
        echo "Environment Varialbe PROJ_DIR not set"
        return
    fi

    if [ ! -d "$PROJ_DIR" ]; then
        mkdir -p $PROJ_DIR
    fi

    if [ -z "$1" ]; then
        cd $PROJ_DIR
    else
        if [ -d "$PROJ_DIR/$1" ]; then
            cd $PROJ_DIR/$1
        else
            echo "Project Directory for $1 does not exist"
            return
        fi
    fi
}

