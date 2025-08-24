#!/bin/bash
sudo mount -t cifs -o username=test,uid=$(id -u),gid=$(id -g) //192.168.1.199/partage /media/frrol/w10_4790
