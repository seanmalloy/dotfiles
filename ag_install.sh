#!/bin/bash

# Statically compiles the ag binary

# Installed this RPM package on CentOS 7
#
# yum install glibc-static

set -e
set -u

which gcc        2> /dev/null
which g++        2> /dev/null
which wget       2> /dev/null
which make       2> /dev/null
which aclocal    2> /dev/null
which autoconf   2> /dev/null
which autoheader 2> /dev/null
which automake   2> /dev/null

CURRENT_DIR="$(pwd)"
declare -r AG_BUILD_DIR="$CURRENT_DIR/tmp/ag_build"
rm -rf $AG_BUILD_DIR
mkdir -p $AG_BUILD_DIR

declare -r AG_INSTALL_DIR="$CURRENT_DIR/tech"
if [[ ! -d $AG_INSTALL_DIR ]]; then
    mkdir -p $AG_INSTALL_DIR
fi
cd $AG_BUILD_DIR

############
# zlib     #
############
ZLIB_VERSION="1.2.11"
wget http://zlib.net/zlib-${ZLIB_VERSION}.tar.gz
tar zxvf zlib-${ZLIB_VERSION}.tar.gz
cd zlib-${ZLIB_VERSION}
CFLAGS="-fPIC" LDFLAGS="-static" ./configure --static --prefix=$AG_BUILD_DIR/zlib
make
make install
cd ..

############
# pcre     #
############
PCRE_VERSION="8.40"
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PCRE_VERSION}.tar.bz2
tar xvjf pcre-${PCRE_VERSION}.tar.bz2
cd pcre-${PCRE_VERSION}
CFLAGS="-fPIC" LDFLAGS="-static" ./configure \
    --enable-jit \
    --enable-unicode-properties \
    --disable-shared \
    --enable-static \
    --prefix=$AG_BUILD_DIR/pcre
make
make install
cd ..

############
# lzma     #
############
XZ_UTILS_VERSION="5.2.3"
wget https://tukaani.org/xz/xz-${XZ_UTILS_VERSION}.tar.gz
tar xvzf xz-${XZ_UTILS_VERSION}.tar.gz
cd xz-${XZ_UTILS_VERSION}
CFLAGS="-fPIC" LDFLAGS="-static" ./configure --disable-shared --enable-static --prefix=$AG_BUILD_DIR/xz
make
make install
cd ..

############
# ag       #
############
AG_VERSION="1.0.3"
wget https://geoff.greer.fm/ag/releases/the_silver_searcher-${AG_VERSION}.tar.gz
tar xvzf the_silver_searcher-${AG_VERSION}.tar.gz
cd the_silver_searcher-${AG_VERSION}
aclocal
autoconf
autoheader
automake --add-missing
CFLAGS='-fPIC' \
    CPPFLAGS="-I${AG_BUILD_DIR}/pcre/include -I${AG_BUILD_DIR}/xz/include -I${AG_BUILD_DIR}/zlib/include" \
    LDFLAGS="-static -L${AG_BUILD_DIR}/zlib/lib -lz" \
    PCRE_LIBS="-L${AG_BUILD_DIR}/pcre/lib -lpcre"    \
    PCRE_CFLAGS="-I${AG_BUILD_DIR}/pcre/include"     \
    LZMA_LIBS="-L${AG_BUILD_DIR}/xz/lib -llzma"      \
    LZMA_CFLAGS="-I${AG_BUILD_DIR}/xz/include"       \
    ZLIB_LIBS="-L${AG_BUILD_DIR}/zlib/lib -lz"       \
    ZLIB_CFLAGS="-I${AG_BUILD_DIR}/zlib/include"     \
./configure PKG_CONFIG="/bin/true"
make
strip $(pwd)/ag

echo ""
echo "ag binary instaled at $(pwd)/ag"
