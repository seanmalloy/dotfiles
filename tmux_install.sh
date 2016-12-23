#!/bin/bash

# Statically compiles the tmux binary.

# exit on error
set -e

which gcc  2> /dev/null
which g++  2> /dev/null
which wget 2> /dev/null
which make 2> /dev/null

TMUX_VERSION=$1
LIBEVENT_VERSION="2.0.22"

if [[ -z $TMUX_VERSION ]]; then
    TMUX_VERSION="2.3"
fi

TMUX_MINOR_VERSION=""
if [[ $TMUX_VERSION = "1.9" ]]; then
    TMUX_MINOR_VERSION="a"
fi

CURRENT_DIR="$(pwd)"
declare -r TMUX_BUILD_DIR="$CURRENT_DIR/tmp/tmux_build"
rm -rf $TMUX_BUILD_DIR
mkdir -p $TMUX_BUILD_DIR

declare -r TMUX_INSTALL_DIR="$CURRENT_DIR/tech"
if [[ ! -d $TMUX_INSTALL_DIR ]]; then
    mkdir -p $TMUX_INSTALL_DIR
fi

# download source files for tmux, libevent, and ncurses
cd $TMUX_BUILD_DIR
wget -O tmux-${TMUX_VERSION}.tar.gz https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}${TMUX_MINOR_VERSION}/tmux-${TMUX_VERSION}${TMUX_MINOR_VERSION}.tar.gz
wget https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VERSION}-stable/libevent-${LIBEVENT_VERSION}-stable.tar.gz
wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz

# extract files, configure, and compile

############
# libevent #
############
tar xvzf libevent-${LIBEVENT_VERSION}-stable.tar.gz
cd libevent-${LIBEVENT_VERSION}-stable
./configure --prefix=$TMUX_INSTALL_DIR --disable-shared
make
make install
cd ..

############
# ncurses  #
############
tar xvzf ncurses-5.9.tar.gz
cd ncurses-5.9
./configure --prefix=$TMUX_INSTALL_DIR
make
make install
cd ..

############
# tmux     #
############
tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}${TMUX_MINOR_VERSION}
./configure CFLAGS="-I$TMUX_INSTALL_DIR/include -I$TMUX_INSTALL_DIR/include/ncurses" LDFLAGS="-L$TMUX_INSTALL_DIR/lib -L$TMUX_INSTALL_DIR/include/ncurses -L$TMUX_INSTALL_DIR/include"
CPPFLAGS="-I$TMUX_INSTALL_DIR/include -I$TMUX_INSTALL_DIR/include/ncurses" LDFLAGS="-static -L$TMUX_INSTALL_DIR/include -L$TMUX_INSTALL_DIR/include/ncurses -L$TMUX_INSTALL_DIR/lib" make

echo ""
echo "tmux binary instaled at $(pwd)/tmux"

