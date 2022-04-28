#!/bin/bash

# **** Aide à l'utilisation ****
function usage() {
    echo "Usage: "$1" <ID_GROUPE_RACINE> <PRIVATE_TOKEN_API>"
}

# **** Lister les ID des sous-groupes d'un groupe (donné par son ID) : ****
function get_subgroups_id() {
    echo "$(curl -s --header "PRIVATE-TOKEN: $PRIVATE_TOKEN_API" "https://gitlab.com/api/v4/groups/$1/subgroups?per_page=100" | jq -r ".[].id")"
}

# **** Récupérer le nom d'un groupe (donné par son ID) : ****
function get_groupname() {
    echo "$(curl -s --header "PRIVATE-TOKEN: $PRIVATE_TOKEN_API" "https://gitlab.com/api/v4/groups/$1" | jq -r ".name")"
}

# **** Récupérer les URLs des dépots d'un groupe (donné par son ID) : ****
function get_repo_https() {
    echo "$(curl -s --header "PRIVATE-TOKEN: $PRIVATE_TOKEN_API" "https://gitlab.com/api/v4/groups/$1?per_page=100" | jq -r ".projects[].http_url_to_repo")"
}

# **** Descends dans l'arbre des groupes et affiche les éléments rencontrés : ***
function process_group() {
    echo "$1"
    local sg=$(get_subgroups_id $1)
    local g=""

    for g in $sg
    do echo $(process_group $g)
    done
}


if [ $# -ne 2 ] ; then
    usage "$0"
    exit -1
fi

PRIVATE_TOKEN_API="$2"

ROOT_GITLAB_GROUP_ID="$1"

echo "Get Gitlab repo list for group '$ROOT_GITLAB_GROUP_ID' using token '$PRIVATE_TOKEN_API' ..."

echo "Root group name is '"$(get_groupname $ROOT_GITLAB_GROUP_ID)"'"

GITLAB_GROUPS_ID="$(process_group $ROOT_GITLAB_GROUP_ID)"

echo $GITLAB_GROUPS_ID

OUTPUT_FILE="gitlab-urls.txt"

echo "" > /tmp/$OUTPUT_FILE

for i in $GITLAB_GROUPS_ID ; do echo "Group name : '"$(get_groupname $i)"'" ; echo $(get_repo_https $i) | tee --append /tmp/$OUTPUT_FILE ; done

echo "******** Repo URL list ********"

cat /tmp/$OUTPUT_FILE | tr -s " " "\n" | sed '/^$/d' | tee $OUTPUT_FILE

echo ">>>>>>>>>>> Result file is : '"$OUTPUT_FILE"'"

echo "end."


