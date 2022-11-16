#!/bin/bash

set -aeu -o pipefail

# --------------------------------------------------------------
# Ce script écrit une image disque sur une carte SD (ou autre).
#
# Usage: ddx <device> <image>
#
# <device> Nom du fichier 'block-device' de la carte SD insérée
# (ex: '/dev/sdb')
# <image>  Nom du fichier image à inscrire
# (ex: 'raspbian.bin')
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

# On attend deux arguments
if [ $# -ne 2 ] ; then
    echo ""
    echo "Usage: $0 <device> <image>"
    echo ""
    echo "Example:"
    echo "$0 /dev/sdb image.bin"
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

# $2 : Est-ce un nom de fichier?
if [ ! -f "$2" ] ; then
    echo ""
    echo "$2"
    echo "Huh? This is NOT a file! Aborting."
    echo ""
    exit -5
else
    IN=$2
fi

INPUT_FILE=$IN

echo ""
echo "Going to WRITE '$INPUT_FILE' to '$OUTPUT_DEV'. Is it correct? (Y/N)"
read RESP

if [ "$RESP" == "Y" -o "$RESP" == "y" ] ; then
    echo ""
    echo "----------------------------------"
    echo "             WRITING              "
    echo "----------------------------------"
    echo ""

    (pv -n $INPUT_FILE | dd of=$OUTPUT_DEV bs=64M oflag=dsync) 2>&1 | dialog --gauge "Running dd ..." 10 70 0

    echo "Sync'ing.)"
    sync
fi

cd $SAVED_DIR

echo "FINISHED."

