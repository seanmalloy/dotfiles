TMUX_DIR=$HOME/.tmux.d
TMUX_SOCKET_DIR=$HOME/.tmux.d/sockets
if [ ! -d "$TMUX_SOCKET_DIR" ]; then
    mkdir -p $TMUX_SOCKET_DIR
    chmod 700 $TMUX_DIR
    chmod 700 $TMUX_SOCKET_DIR
fi
export TMUX_SOCKET=$TMUX_SOCKET_DIR/$USER

