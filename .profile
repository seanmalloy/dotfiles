# Sean Malloy's .profile

# if running bash
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

if [ -z "$SSH_AGENT_PID" ]; then
    eval $(ssh-agent -s)
    ssh-add
fi
