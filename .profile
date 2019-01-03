# Sean Malloy's .profile

# if running bash
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

if [ $OS_TYPE == "Linux" ]; then
    # Fedora 27 GNOME login freezes so skip it
    if [ ! $OS_VERSION =~ ^Fedora ]; then
        # Start ssh-agent if agent is not running and not in tmux
        if [ -z "$SSH_AGENT_PID" -a -z "$TMUX" ]; then
            EXISTING_SSH_AGENT_PID="$(ps -ef | grep 'ssh-agent -s' | grep ^$USER | grep -v grep | awk '{print $2}')"
            SSH_AGENT_FILE="$HOME/.ssh/agent"
            if [ -z "$EXISTING_SSH_AGENT_PID" ]; then
                # Existing ssh-agent not running, start one
                ssh-agent -s >| $SSH_AGENT_FILE
                . $SSH_AGENT_FILE
                ssh-add
            else
                # Existing ssh-agent running, connect to it
                if [ -f "$SSH_AGENT_FILE" ]; then
                    . $SSH_AGENT_FILE
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

# Udate my local locate DB if not running in tmux
if [ $OS_TYPE == "Linux" ]; then
    if [[ -z "$TMUX" ]]; then
        build_locate_db &
    fi
fi
