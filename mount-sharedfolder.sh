#!/bin/bash

VBoxControl sharedfolder list
mkdir -p /mnt/vbox/cpp
mount -o 'uid=1000,gid=1000' -t vboxsf cpp /mnt/vbox/cpp
