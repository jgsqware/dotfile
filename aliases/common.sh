#!/bin/zsh

alias vim="nvim"
# Git aliases
alias gvend="git add vendor  Gopkg.* && git commit -m 'update vendors'"
alias ggvend="git add vendor glide.* && git commit -m 'update Glide vendors'"
alias gh="xdg-open \`git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//'\`"
alias sha_copy="git rev-parse HEAD | xclip -selection clipboard"
alias sha="git rev-parse HEAD"
alias gacsm="gaa && gcsm "

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
alias gbtv="go build && go test ./... && go vet"

alias k="kubectl"
alias g="kubectl -n giantswarm"
#alias helm="docker run --rm -v ~/.ssh:/root/.ssh -v `pwd`:/data -w /data -v ~/.helm:/root/.helm -v ~/.kube:/root/.kube -v /home/jgsqware/.config/opsctl/:/home/jgsqware/.config/opsctl/ -v /home/jgsqware/.minikube:/home/jgsqware/.minikube lachlanevenson/k8s-helm:v2.6.1"
alias hd="helm_2.6.2 del"
alias hs="helm_2.6.2 status"
alias hi="helm_2.6.2 install"
alias hu="helm_2.6.2 upgrade"

alias openvpn="sudo openvpn --config $KB_DOTFILE/jgsqware.ovpn --script-security 2"

function logwork() {
    if [[ ! -d ~/logwork/ ]]; then 
	mkdir ~/logwork
    fi 

    if [[ ! -f ~/logwork/$(date +%y%m%d).md ]]; then
        cp ~/logwork/logwork_template.md ~/logwork/$(date +%y%m%d).md
    fi

    nvim ~/logwork/$(date +%y%m%d).md   
}

function yesterday() {
    nvim ~/logwork/$(date --date yesterday +%y%m%d).md
}

alias tips="nvim ~/logwork/tips.md"

function stips() {
    ag "$1" ~/logwork/tips.md
}
