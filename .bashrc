# Sean Malloy's .bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# source global bash configuration
if [[ -f /etc/bashrc ]]; then
    source /etc/bashrc
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

# Set Shell Options
set -o vi
set -o noclobber

export TECH_DIR=$HOME/tech         # top level dir for locally installed software
export BIN_DIR=$TECH_DIR/bin       # directory for scripts, binaries, etc.
export BREW_DIR=$TECH_DIR/brew     # top level directory for brew on masOS
export MAN_DIR=$TECH_DIR/share/man # directory for man pages
export PROJ_DIR=$HOME/projects     # directory for code projects
export VISUAL=nvim                 # neovim is my editor
export EDITOR=nvim                 # neovim is my editor
export HOSTNAME=$(hostname -s)     # Short hostname of this computer
export PROXY_ENABLED=no            # tracks status of the proxy settings used by shell function p()

# Go Lang Variables
export GOROOT=$TECH_DIR/go
export GOPATH=$PROJ_DIR/go

# Rust Variables
export RUSTUP_HOME=$TECH_DIR/rust/.rustup
export CARGO_HOME=$TECH_DIR/rust/.cargo

# Generic Aliases
if [[ ! $OS_VERSION =~ ^RedHat ]]; then
    # TODO: install bat on RHEL
    alias cat='bat'
fi
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

# Set PATH
export PATH=/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games
for DIR in $GOROOT/bin $GOPATH/bin $HOME/.vim/bin $BIN_DIR $TECH_DIR/usr/local/bin $CARGO_HOME/bin; do
    if [[ -d $DIR ]]; then
        if [[ ! $PATH =~ $DIR ]]; then
            PATH=$DIR:$PATH
        fi
    fi
done

# Mac OSX Specific PATH
if [[ $OS_TYPE == "Darwin" ]]; then
    for DIR in $BREW_DIR/bin $BREW_DIR/opt/gnu-tar/libexec/gnubin $BREW_DIR/opt/coreutils/libexec/gnubin $BREW_DIR/opt/findutils/libexec/gnubin $BREW_DIR/opt/gnu-sed/libexec/gnubin $BREW_DIR/opt/grep/libexec/gnubin; do
        if [[ -d $DIR ]]; then
            if [[ ! $PATH =~ $DIR ]]; then
                PATH=$DIR:$PATH
            fi
        fi
    done
fi

# Source newer bash completions if available
if [[ $OS_TYPE == "Darwin" ]]; then
    # required for kubectl completion
    [[ -r "$BREW_DIR/etc/profile.d/bash_completion.sh" ]] && source "$BREW_DIR/etc/profile.d/bash_completion.sh"
fi

# Source bash completion files insatlled for all brew packages
if [[ $OS_TYPE == "Darwin" ]]; then
    for FILE in $(ls $BREW_DIR/etc/bash_completion.d); do
        source $BREW_DIR/etc/bash_completion.d/$FILE
    done
fi

# Setup pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [ -d $PYENV_ROOT/bin ]; then
    PATH=$PYENV_ROOT/bin:$PATH
fi
if [ -d $PYENV_ROOT/shims ]; then
    PATH=$PYENV_ROOT/shims:$PATH
fi
if which pyenv > /dev/null 2>&1; then
    eval "$(pyenv init -)"
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

# enable colors
if which dircolors > /dev/null 2>&1; then
    test -r $HOME/.dircolors && eval "$(dircolors -b $HOME/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -F'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

### Kubernetes Setup ###
if which kubectl > /dev/null 2>&1; then
    source <(kubectl completion bash)
    alias k='kubectl'
    complete -F __start_kubectl k

    # Setup kubectx
    alias kctx='kubectx'
    if [[ $OS_TYPE = "Linux" ]]; then
        # Bash completion instlled via brew on macOS
        source $BASH_INCLUDE_DIR/kubectx.bash
    fi

    # Setup kubens
    alias kns='kubens'
    if [[ $OS_TYPE = "Linux" ]]; then
        # Bash completion instlled via brew on macOS
        source $BASH_INCLUDE_DIR/kubens.bash
    fi
fi

### OpenShift Setup ###
if which oc > /dev/null 2>&1; then
    source <(oc completion bash)
    alias o='oc'
    complete -F __start_oc o
fi

#### Git Setup ###
if [[ $OS_TYPE == "Darwin" ]]; then
    source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
fi

# Enable gh autocomplete
if which gh > /dev/null 2>&1; then
    eval "$(gh completion -s bash)"
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
source $TMUX_INCLUDE_FILE
alias tmux='tmux -L $TMUX_SOCKET'

### Tmuxinator Setup ###
export TMUXINATOR_INCLUDE_FILE="$BASH_INCLUDE_DIR/tmuxinator.bash"
source $TMUXINATOR_INCLUDE_FILE

### FZF Setup ###
[ -f /usr/share/fzf/shell/key-bindings.bash ] && source /usr/share/fzf/shell/key-bindings.bash
[ -f $HOME/.fzf.bash ] && source $HOME/.fzf.bash
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='-m -x'

### Zoxide Setup ###
if which zoxide > /dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

### RHEL Specific Setup ###
if [[ $OS_VERSION =~ ^RedHat ]]; then
    [ -f $BASH_INCLUDE_DIR/fd.bash ] && source $BASH_INCLUDE_DIR/fd.bash
fi

### Shell Functions ###

# setup powerline-go prompt
_update_ps1() {
    PS1="$(powerline-go -shell-var PROXY_ENABLED -hostname-only-if-ssh -newline -modules="venv,user,host,ssh,cwd,perms,git,kube,jobs,exit,root,shell-var" -error $?)"
}

# Toggle Proxy Settings
p() {
    if [[ $PROXY_ENABLED = "no" ]]; then
        eval "local $(grep LOCAL_PROXY_SERVER $HOME/.dotfiles_answers)"
        http_proxy=$LOCAL_PROXY_SERVER
        HTTP_PROXY=$http_proxy
        https_proxy=$http_proxy
        HTTPS_PROXY=$https_proxy
        export http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
        PROXY_ENABLED=yes
    else
        unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY
        PROXY_ENABLED=no
    fi
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
        local DIR=$(fd --type directory --prune --hidden --color never --glob .git $BASE_DIR | grep '.git$' | sed s'/\/\.git//' | fzf +m)
    else
        local DIR=$(fd --type directory --prune --hidden --color never --glob .git $BASE_DIR | sed s'/\/\.git//' | fzf +m -q $1 -1)
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

### Set Bash Prompt ###
if [ "$TERM" != "linux" ] && which powerline-go > /dev/null 2>&1; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

### Custom Key Bindings ###
bind '"\C-p":"$(fzpkg)\n"' # CTRL-P: fzf RPM packages

### Source Site Specific Config ###
export BASH_SITE_FILE="$HOME/.site_env"
if [[ ! -e $BASH_SITE_FILE ]]; then
    touch $BASH_SITE_FILE
fi
source $BASH_SITE_FILE

