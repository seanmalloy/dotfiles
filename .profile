# Sean Malloy's .profile

# Exec into newer bash on Mac OSX
os_type="$(uname -s)"
if [ "$os_type" = "Darwin" ]; then
    case $- in
        *i*)
        # Interactive session. Try switching to newer bash
        NEW_BASH="$HOME/tech/brew/bin/bash"
        if [ "$BASH" != "$NEW_BASH" ]; then
            bash=$(command -v $NEW_BASH)
            if [ -x "$bash" ]; then
                export SHELL="$bash"
                exec "$bash"
            fi
        fi
    esac
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	source "$HOME/.bashrc"
    fi
fi

if [ $OS_TYPE == "Linux" ]; then
    # Fedora 27 GNOME login freezes so skip it
    if ! [[ $OS_VERSION =~ ^Fedora || $OS_VERSION =~ ^RedHat ]]; then
        # Start ssh-agent if agent is not running and not in tmux
        if [ -z "$SSH_AGENT_PID" -a -z "$TMUX" ]; then
            EXISTING_SSH_AGENT_PID="$(ps -ef | grep 'ssh-agent -s' | grep ^$USER | grep -v grep | awk '{print $2}')"
            SSH_AGENT_FILE="$HOME/.ssh/agent"
            if [ -z "$EXISTING_SSH_AGENT_PID" ]; then
                # Existing ssh-agent not running, start one
                ssh-agent -s >| $SSH_AGENT_FILE
                source $SSH_AGENT_FILE
                ssh-add
            else
                # Existing ssh-agent running, connect to it
                if [ -f "$SSH_AGENT_FILE" ]; then
                    source $SSH_AGENT_FILE
                    ssh-add -X
                    while [ "$?" -ne 0 ]; do
                        ssh-add -X
                    done
                else
                    echo "ERROR: cannot connect to ssh-agent $EXISTING_SSH_AGENT_PID"
                fi
            fi
        fi
    fi
fi

