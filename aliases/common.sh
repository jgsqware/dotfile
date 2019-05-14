#!/bin/zsh

alias vim="nvim"

# Git aliases
alias gvend="git add vendor  Gopkg.* && git commit -m 'update vendors'"
alias ggvend="git add vendor glide.* && git commit -m 'update Glide vendors'"
alias gh="xdg-open \`git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//'\` &>/dev/null"
alias sha_copy="git rev-parse HEAD | xclip -selection clipboard"
alias sha="git rev-parse HEAD"
alias gacsm="gaa && gcsm "
alias gpr="git pull -r"
alias gfp="git fetch --prune"

alias mirror="xrandr --output HDMI1 --auto --same-as eDP1 --auto && xrandr -s 0"
alias projo="xrandr --output HDMI1 --mode 1280x1024 --output eDP1 --mode 1280x1024"

# Shell Aliases
alias dotconfig="vim ${DOTFILE}"
alias h="history"
alias hg="history | grep -i"
alias pg="ps aux | grep -i"
alias pr="sudo pacman -Rs"
alias calc="gcalccmd"

# Docker
alias docker-rmid="docker images --quiet --filter=dangling=true | xargs docker rmi -"
alias dkc="docker-compose"

# Applications
alias stream='mkchromecast --encoder-backend ffmpeg --alsa-device hw:0,1 --name Bureau -b 320 --control'
alias agv='ag --ignore=vendor/'
alias j='jrnl'
alias code="code --enable-proposed-api GitHub.vscode-pull-request-github"
alias reset_time='sudo ntpd -gq'

# Go
alias godocs='godoc -http=":6060"'
alias guv="glide update -v"
alias gbtv="go build && go test ./... && go vet"

alias k="kubectl"
alias kns="kubens"
alias kctx="kubectx"
alias kb="kubectl run -ti busybox --image=yauritux/busybox-curl --rm -- sh"
alias kmaster="kubectl get nodes -l node-role.kubernetes.io/master -o yaml | yq -r '.items[0].metadata.labels.ip'"
alias hd="helm del"
alias hs="helm status"
alias hi="helm install"
alias hu="helm upgrade"


function clone() {
    git clone git@github.com:jgsqware/${1}.git ~/go/src/github.com/jgsqware/${1}
}
