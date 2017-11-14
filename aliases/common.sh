#!/bin/zsh

alias vim="nvim"
# Git aliases
alias gvend="git add vendor glide.* && git commit -m 'update Glide vendors'"
alias gh="xdg-open \`git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//'\`"
alias sha="git rev-parse HEAD | xclip -selection clipboard"

# Shell Aliases
alias dotconfig="vim ${DOTFILE}"
alias h="history"
alias hg="history | grep -i"
alias pg="ps aux | grep -i"
alias render="xrandr --output DP-1 --mode 2560x1440 --panning 3840x2160+3840+1440 --scale 1.5x1.5 --right-of eDP-1 && xrandr --output DP-1 --mode 2560x1440 --panning 3840x2160+3840+0 --scale 1.5x1.5 --right-of eDP-1"
alias mux="tmuxinator"

# Docker
alias docker-rmid="docker images --quiet --filter=dangling=true | xargs docker rmi -"
alias dkc="docker-compose"

# Applications
alias stream='mkchromecast --encoder-backend ffmpeg --alsa-device hw:0,1 --name Bureau -b 320 --control'
alias agv='ag --ignore=vendor/'
# Go
alias godocs='godoc -http=":6060"'
alias guv="glide update -v"

alias k="kubectl"

