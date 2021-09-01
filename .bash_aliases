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

alias upd='sudo apt-get update && sudo apt-get upgrade'

export GIT_GHB='/mnt/d/frolland/git/ghb'
export GIT_GLB='/mnt/d/frolland/git/glb'
export DISPLAY=192.168.0.24:0
