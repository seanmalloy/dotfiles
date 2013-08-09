# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ $(whoami) == "root" ]; then
    PS1='\u@\h# '
else
    PS1='\u@\h\$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Enable Colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -F'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Set Shell Options
set -o vi
set -o noclobber

export TECH_DIR=$HOME/tech      # top level dir for locally installed software
export BIN_DIR=$TECH_DIR/bin    # directory for scripts, binaries, etc.
export PROJ_DIR=$HOME/projects  # directory for code projects
export VISUAL=vim               # vim is my editor
export EDITOR=vim               # vim is my editor
export RELEASE_TESTING=1        # For Perl Module Development
export PERLBREW_ROOT=/opt/perl5 # Top level perlbrew directory
export HOSTNAME=$(hostname -s)  # Short hostname of this computer

# Alias Definitions
alias ll='ls -l'
alias la='ls -A'
alias ltr='ls -ltr'
alias vi='vim'
alias tmux='tmux attach'
alias bin='cd $BIN_DIR'
alias proj='cd $PROJ_DIR'
alias tech='cd $TECH_DIR'

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

# SSH Setup
SSH_DIR=$HOME/.ssh
SSH_SOCKET_DIR=$SSH_DIR/sockets
if [ ! -d "$SSH_SOCKET_DIR" ]; then
    mkdir -p $SSH_SOCKET_DIR
    chmod 700 $SSH_DIR
    chmod 700 $SSH_SOCKET_DIR
fi

# TMUX Setup
if [ -n "$(which tmux)" ]; then
    #alias attach='tmux attach -t $HOSTNAME'
    TMUX_DIR=$HOME/.tmux.d
    TMUX_SOCKET_DIR=$HOME/.tmux.d/sockets
    if [ ! -d "$TMUX_SOCKET_DIR" ]; then
        mkdir -p $TMUX_SOCKET_DIR
        chmod 700 $TMUX_DIR
        chmod 700 $TMUX_SOCKET_DIR
    fi

    
    if ! tmux has-session -t ${HOSTNAME} 2>/dev/null; then
        # session does not exist, create one
        #tmux -L $TMUX_SOCKET_DIR new-session -d -s $HOSTNAME
        tmux new-session -d -s $HOSTNAME
    #else
    #    # attach to existing session
    #    attach
    fi
fi

