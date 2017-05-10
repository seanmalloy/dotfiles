#!/bin/bash

# Statically compiles the tmux binary

# Installed this RPM package on CentOS 7
#
# yum install glibc-static libstdc++-static

set -e
set -u

which gcc  2> /dev/null
which g++  2> /dev/null
which wget 2> /dev/null
which make 2> /dev/null

CURRENT_DIR="$(pwd)"
declare -r TMUX_BUILD_DIR="$CURRENT_DIR/tmp/tmux_build"
rm -rf $TMUX_BUILD_DIR
mkdir -p $TMUX_BUILD_DIR

declare -r TMUX_INSTALL_DIR="$CURRENT_DIR/tech"
if [[ ! -d $TMUX_INSTALL_DIR ]]; then
    mkdir -p $TMUX_INSTALL_DIR
fi
cd $TMUX_BUILD_DIR

############
# libevent #
############
LIBEVENT_VERSION="2.0.22"
wget https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VERSION}-stable/libevent-${LIBEVENT_VERSION}-stable.tar.gz
tar xvzf libevent-${LIBEVENT_VERSION}-stable.tar.gz
cd libevent-${LIBEVENT_VERSION}-stable
CFLAGS="-fPIC" LDFLAGS="-static" ./configure --prefix=$TMUX_BUILD_DIR/libevent --disable-shared --enable-static
make
make install
cd ..

############
# ncurses  #
############
NCURSES_VERSION="5.9"
wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz
tar xvzf ncurses-${NCURSES_VERSION}.tar.gz
cd ncurses-${NCURSES_VERSION}
CXXFLAGS="-fPIC" CFLAGS="-fPIC" LDFLAGS="-static" ./configure --prefix=$TMUX_BUILD_DIR/ncurses --disable-shared --enable-static
make
make install
cd ..

############
# tmux     #
############
TMUX_VERSION="2.3"
wget https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}
CFLAGS="-fPIC" \
    CPPFLAGS="-I${TMUX_BUILD_DIR}/libevent/include -I${TMUX_BUILD_DIR}/ncurses/include/ncurses" \
    LDFLAGS="-static" \
    LIBEVENT_LIBS="-L${TMUX_BUILD_DIR}/libevent/lib -llibevent"         \
    LIBEVENT_CFLAGS="-I${TMUX_BUILD_DIR}/libevent/include"              \
    LIBNCURSES_LIBS="-L${TMUX_BUILD_DIR}/ncurses/lib -lncurses -ltinfo" \
    LIBNCURSES_CFLAGS="-I${TMUX_BUILD_DIR}/ncurses/include/ncurses"     \
./configure --enable-static
make
#strep $(pwd)/tmux

echo ""
echo "tmux binary instaled at $(pwd)/tmux"

