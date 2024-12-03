#!/bin/bash

set -eu

VER='14.2.0'
GCC_VER="gcc-${VER}"
apt -y install build-essential libmpfr-dev libgmp3-dev libmpc-dev
wget http://ftp.gnu.org/gnu/gcc/${GCC_VER}/${GCC_VER}.tar.gz
tar -zxf ${GCC_VER}.tar.gz
cd ${GCC_VER}

SPECS='x86_64-linux-gnu'
PREFIX='/usr/local'
./configure -v \
    --build=${SPECS} \
    --host=${SPECS} \
    --target=${SPECS} \
    --prefix=${PREFIX}/${GCC_VER} \
    --enable-checking=release \
    --enable-languages=c,c++ \
    --disable-multilib \
    --program-suffix=-${VER}

make -j 2
make install
update-alternatives --install /usr/bin/g++ g++ ${PREFIX}/${GCC_VER}/bin/g++-${VER} 14
update-alternatives --install /usr/bin/cpp cpp ${PREFIX}/${GCC_VER}/bin/cpp-${VER} 14
update-alternatives --install /usr/bin/c++ c++ ${PREFIX}/${GCC_VER}/bin/c++-${VER} 14
update-alternatives --install /usr/bin/gcc gcc ${PREFIX}/${GCC_VER}/bin/gcc-${VER} 14
