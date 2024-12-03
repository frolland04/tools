#!/bin/bash

set -eu

VER='14.2.0'
GCC_VER="gcc-${VER}"
apt -y install build-essential libmpfr-dev libgmp3-dev libmpc-dev
wget http://ftp.gnu.org/gnu/gcc/${GCC_VER}/${GCC_VER}.tar.gz
tar -zxf ${GCC_VER}.tar.gz
cd ${GCC_VER}

SPECS='x86_64-linux-gnu'
./configure -v \
    --build=${SPECS} \
    --host=${SPECS} \
    --target=${SPECS} \
    --prefix=/usr/local/${GCC_VER} \
    --enable-checking=release \
    --enable-languages=c,c++ \
    --disable-multilib \
    --program-suffix=-${VER}

make -j 2
make install

update-alternatives --install /usr/bin/g++ g++ /usr/local/gcc-14.1.0/bin/g++14.1.0 14
update-alternatives --install /usr/bin/gcc gcc /usr/local/gcc-14.1.0/bin/gcc14.1.0 14
