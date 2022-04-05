#!/bin/bash

GITLAB_URL_FILE="gitlab-urls.txt"

# **** Aide à l'utilisation ****
function usage() {
    echo "Usage: "$1" <COMMANDE>"
    echo "<COMMANDE>=clone|pull|status"
    echo "Nécessite la présence d'un fichier '"$GITLAB_URL_FILE"'"
}

if [ $# -ne 1 ] ; then
    usage "$0"
    exit -1
fi

OPERATION="$1"

if [ "$OPERATION" == "clone" ] ; then
    
    echo "*** CLONE ***"

    for REPO_URL in `cat $GITLAB_URL_FILE`
    
    do echo "***************** $REPO_URL *****************"
    
    CURRENT_DIR=`echo $REPO_URL | sed s%https://gitlab.com/%%g | sed s%.git$%%g`
    
    echo $CURRENT_DIR
    
    echo "*** MKDIR ***"
    
    mkdir -pv $CURRENT_DIR
    
    echo "*** GIT ***"
    
    git clone $REPO_URL $CURRENT_DIR
    
    done
fi

if [ "$OPERATION" == "pull" ] ; then
    
    echo "*** CLONE ***"

    for REPO_URL in `cat $GITLAB_URL_FILE`
    
    do echo "***************** $REPO_URL *****************"
    
    CURRENT_DIR=`echo $REPO_URL | sed s%https://gitlab.com/%%g | sed s%.git$%%g`
    
    (cd $CURRENT_DIR && git pull)
    
    done
fi

if [ "$OPERATION" == "status" ] ; then
    
    echo "*** CLONE ***"

    for REPO_URL in `cat $GITLAB_URL_FILE`
    
    do echo ""
    
    CURRENT_DIR=`echo $REPO_URL | sed s%https://gitlab.com/%%g | sed s%.git$%%g`
    
    echo "************* $CURRENT_DIR *************"
    
    (cd $CURRENT_DIR && git status --short)
    
    done
fi

echo "end."
