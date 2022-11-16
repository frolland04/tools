#!/bin/bash

set -aeu -o pipefail

# --------------------------------------------------------------
# Ce script efface une carte SD (ou autre).
#
# Usage: dzo <device>
#
# <device> Nom du fichier 'block-device' de la carte SD insérée
# (ex: '/dev/sdb')
# 
# Note: Le script doit être lancé par 'sudo'
# --------------------------------------------------------------

SAVED_DIR=$PWD

# Il faut être SU
CHECK_SU=`id | grep "uid=0(root)" | wc -l || true`

if [ "$CHECK_SU" != "1" ] ; then
    echo ""
    echo "You MUST be SU. Aborting."
    echo ""
    exit -10
fi

# On attend un argument
if [ $# -ne 1 ] ; then
    echo ""
    echo "Usage: $0 <device>"
    echo ""
    echo "Example:"
    echo "$0 /dev/sdb"
    echo ""
    exit -1
fi

# $1 : Est-ce un nom de fichier?
if [ ! -b "$1" ] ; then
    echo ""
    echo "$1"
    echo "Huh? This is NOT a (device) file! Aborting."
    echo ""
    exit -2
else
    DEV=$1
fi

# $1 : Est-ce un block-device de disque?
DEV_IN_LSBLK_PD=`lsblk -pd | grep disk | grep $1 | wc -l || true`

if [ "$DEV_IN_LSBLK_PD" != "1" ] ; then
    echo ""
    echo "$1"
    echo "Huh? This device is NOT a disk block-device! Aborting."
    echo ""
    exit -3
fi

# $1 : Est-il monté?
DEV_IN_MOUNTS=`mount | grep $1 | wc -l || true`

if [ "$DEV_IN_MOUNTS" != "0" ] ; then
    echo ""
    echo "$1"
    echo "This device MUST NOT be mounted! Aborting."
    echo ""
    exit -4
else
    OUTPUT_DEV=$1
    echo "OK."
fi

INPUT_FILE="/dev/zero"

OUTPUT_SIZE=`blockdev --getsize64 $OUTPUT_DEV`

echo ""
echo "Going to ERASE '$OUTPUT_DEV'. Is it correct? (Y/N)"
read RESP

if [ "$RESP" == "Y" -o "$RESP" == "y" ] ; then
    echo ""
    echo "----------------------------------"
    echo "             ERASING              "
    echo "----------------------------------"
    echo ""

    (pv -s $OUTPUT_SIZE -n $INPUT_FILE | dd of=$OUTPUT_DEV bs=64M oflag=dsync) 2>&1 | dialog --gauge "Running dd ..." 10 70 0

    echo "Sync'ing.)"
    sync
fi

cd $SAVED_DIR

echo "FINISHED."

