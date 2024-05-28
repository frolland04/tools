HISTSIZE=30000
HISTFILESIZE=90000

alias ls='ls --color=never'
alias ll='ls -alF --color=never'
alias h='history | fzf'

alias dc='docker container ls --all'
alias di='docker image ls'
alias dn='docker network ls'
alias dv='docker volume ls'
alias dr='docker image ls | grep "<none>" | tr -s " *" " " | cut -d " " -f 3 | xargs -n 1 docker image rm'
alias dp='docker builder prune'
alias dpa='docker builder prune --all'

alias glo='git log -20 --oneline'
alias gs='git status'
alias gc='git config --list'
alias gce='git config user.name "Frédéric ROLLAND" && git config user.email "frederic.rolland@smile.fr"'
alias gcf='git config user.name "Frédéric ROLLAND" && git config user.email "frederic.rolland@free.fr"'

alias upd='sudo apt-get update && sudo apt-get upgrade && sudo apt clean'
alias updd='sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade && sudo apt clean'

export GIT_ROOT=/home/${USER}/git
export GIT_FRD=${GIT_ROOT}/FRD
export GIT_ECS=${GIT_ROOT}/ECS

export GIT_GHB=${GIT_FRD}/ghb
export GIT_GLB=${GIT_FRD}/glb

export DISPLAY=:0

if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source $HOME/.bash-git-prompt/gitprompt.sh
fi

export HTTP_PROXY="http://localhost:3142"

