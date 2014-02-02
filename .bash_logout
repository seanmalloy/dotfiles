# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy
if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

# lock ssh-agent, only when not in tmux session
if [ -z "$TMUX" ]; then
    EXISTING_SSH_AGENT_PID="$(ps -ef | grep 'ssh-agent -s' | grep ^$USER | grep -v grep | awk '{print $2}')"
    if [ -n "$EXISTING_SSH_AGENT_PID" ]; then
        if [ -n "$SSH_AGENT_PID" ]; then
            ssh-add -x
            while [ "$?" -ne 0 ]; do
                ssh-add -x
            done
        fi
    fi
fi

