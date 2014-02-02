TMUX_DIR=$HOME/.tmux.d
export TMPDIR=$HOME/.tmux.d/sockets
if [ ! -d "$TMPDIR" ]; then
    mkdir -p $TMPDIR
    chmod 700 $TMUX_DIR
    chmod 700 $TMPDIR
fi
export TMUX_SOCKET=$USER

