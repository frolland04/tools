#!/usr/bin/env bash

CMAKE_DISTRIB_PREFIX="/usr"
CMAKE_VERSION="3.27.3"
CMAKE_ARCHIVE_NAME="cmake-${CMAKE_VERSION}.tar.gz"
CMAKE_SOURCES="cmake-${CMAKE_VERSION}"

apt-get install -y libssl-dev && \
wget "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${CMAKE_ARCHIVE_NAME}" && \
tar zxvf ${CMAKE_ARCHIVE_NAME} && \
cd ${CMAKE_SOURCES} && \
mkdir build && \
cd build/ && \
cmake -G Ninja -B . -S .. -DCMAKE_INSTALL_PREFIX=${CMAKE_DISTRIB_PREFIX} && \
cmake --build . && \
cmake --install . && \
cd ../.. && \
rm -rf ${CMAKE_ARCHIVE_NAME} ${CMAKE_SOURCES}