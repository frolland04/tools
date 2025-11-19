#!/bin/bash

dpkg --add-architecture i386
apt update && \
apt install --assume-yes    \
    cabextract              \
    fluid-soundfont-gs      \
    libasound2-plugins:i386 \
    libdbus-1-3:i386        \
    libsdl2-2.0-0:i386      \
    libsqlite3-0:i386       \
    mesa-utils              \
    python3-lxml            \
    python3-magic           \
    python3-setproctitle    \
    rar                     \
    unrar                   \
    vulkan-tools            \
    wine32                  \
    wine64                  \
    wine64-preloader        \
    wine64-tools            \
    winetricks

# then adds Bottle, Steam, Lutris, etc.
# Enjoy !
