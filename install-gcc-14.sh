#!/bin/bash

set -eu

VER='14.2.0'
GCC_VER="gcc-${VER}"
apt -y install build-essential libmpfr-dev libgmp3-dev libmpc-dev
if [ ! -f "${GCC_VER}.tar.gz" ] ; then
    wget http://ftp.gnu.org/gnu/gcc/${GCC_VER}/${GCC_VER}.tar.gz
fi
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

set -x

update-alternatives --install /usr/bin/g++-${VER} g++ ${PREFIX}/${GCC_VER}/bin/g++-${VER} 14
update-alternatives --install /usr/bin/gcc-${VER} gcc ${PREFIX}/${GCC_VER}/bin/gcc-${VER} 14
