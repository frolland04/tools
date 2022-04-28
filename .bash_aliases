HISTSIZE=10000
HISTFILESIZE=20000

alias ls='ls --color=never'
alias ll='ls -alF --color=never'

alias dc='sudo docker container ls --all'
alias di='sudo docker image ls'
alias dn='sudo docker network ls'
alias dv='sudo docker volume ls'

alias glo='git log -20 --oneline'
alias gs='git status'
alias gc='git config --list'
alias gcp='git config user.name "Frédéric ROLLAND" && git config user.email "frederic.rolland@pellenc.com"'
alias gcf='git config user.name "Frédéric ROLLAND" && git config user.email "frederic.rolland@free.fr"'

alias upd='sudo apt-get update && sudo apt-get upgrade'
alias updd='sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade'

export GIT_ROOT='/home/test/git'
export GIT_FRD=$GIT_ROOT'/FRD'
export GIT_PSA=$GIT_ROOT'/PSA'

export GIT_GHB=$GIT_FRD'/ghb'
export GIT_GLB=$GIT_FRD'/glb'
export IMX6_B2QT=$GIT_PSA'/labo/sources/system/embedded/Toradex_Apalis_iMX6'

export DISPLAY=:0

