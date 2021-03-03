HISTSIZE=10000
HISTFILESIZE=20000

alias ls='ls --color=never'
alias ll='ls -alF --color=never'

alias dc='sudo docker container ls --all'
alias di='sudo docker image ls --all'
alias dn='sudo docker network ls'
alias dv='sudo docker volume ls'

alias gh='git log -20 --decorate --graph --pretty=format'\'':%C(yellow)%h%Creset%C(auto)%d%Creset - %C(bold blue)%an%Creset (%C(green)%ar%Creset) - %s'\'''
alias ghh='git log -20 --decorate --all --graph --pretty=format'\'':%C(yellow)%h%Creset%C(auto)%d%Creset - %C(bold blue)%an%Creset (%C(green)%ar%Creset) - %s'\'''
alias ghhh='git log --decorate --all --graph --pretty=format'\'':%C(yellow)%h%Creset%C(auto)%d%Creset - %C(bold blue)%an%Creset (%C(green)%ar%Creset) - %s'\'''
alias gs='git status'
