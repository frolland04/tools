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

export GIT_GHB='/mnt/d/frolland/git/ghb'
export GIT_GLB='/mnt/d/frolland/git/glb'
export IMX6_B2QT='/home/test/git/PSA/embedded-linux/system/embedded/Toradex_Apalis_iMX6'

export DISPLAY=192.168.0.24:0
