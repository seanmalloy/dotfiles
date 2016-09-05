TMUX_DIR=$HOME/.tmux.d
export TMUX_TMPDIR=$HOME/.tmux.d/sockets
if [ ! -d "$TMUX_TMPDIR" ]; then
    mkdir -p $TMUX_TMPDIR
    chmod 700 $TMUX_DIR
    chmod 700 $TMUX_TMPDIR
fi
export TMUX_SOCKET=$USER

