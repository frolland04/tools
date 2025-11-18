#!/bin/bash

KEYFILE="oracle_vbox.asc"
wget https://www.virtualbox.org/download/${KEYFILE} && \
apt-key add ${KEYFILE} && \
rm ${KEYFILE} && \
add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -c | awk '{print $2}') contrib" && \
apt update && \
apt install virtualbox-7.1
