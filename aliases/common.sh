#!/bin/zsh

alias vim="nvim"

alias wifi="nmcli radio wifi"
# Git aliases
alias gvend="git add vendor  Gopkg.* && git commit -m 'update vendors'"
alias ggvend="git add vendor glide.* && git commit -m 'update Glide vendors'"
alias gh="xdg-open \`git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//'\` &>/dev/null"
alias sha_copy="git rev-parse HEAD | xclip -selection clipboard"
alias sha="git rev-parse HEAD"
alias gacsm="gaa && gcsm "
alias gpr="git pull -r"

# Shell Aliases
alias dotconfig="vim ${DOTFILE}"
alias h="history"
alias hg="history | grep -i"
alias pg="ps aux | grep -i"
alias render="xrandr --output DP-1 --mode 2560x1440 --panning 3840x2160+3840+1440 --scale 1.5x1.5 --right-of eDP-1 && xrandr --output DP-1 --mode 2560x1440 --panning 3840x2160+3840+0 --scale 1.5x1.5 --right-of eDP-1"
alias mux="tmuxinator"
alias pr="sudo pacman -Rs"

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
alias kns="kubens"
alias kctx="kubectx"
alias kb="kubectl run -ti busybox --image=yauritux/busybox-curl --rm -- sh"
alias kmaster="kubectl get nodes -l node-role.kubernetes.io/master -o yaml | yq -r '.items[0].metadata.labels.ip'"
alias hd="helm del"
alias hs="helm status"
alias hi="helm install"
alias hu="helm upgrade"

function install_tiller() {
    kubectl create -f ~/go/src/github.com/jgsqware/notes/tiller-rbac/tiller-clusterrolebinding.yaml
    helm init --service-account tiller
}

function clone() {
    git clone git@github.com:jgsqware/${1}.git ~/go/src/github.com/jgsqware/${1}
}

function kcns() {
  local cur_ctx=$(kubectl config current-context)
  ns="$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${cur_ctx}\")].context.namespace}")"
  if [[ -z "${ns}" ]]; then
    echo "default"
  else
    echo "${ns}"
  fi
}

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

alias notes="nvim ~/go/src/github.com/jgsqware/notes/$(date +%Y)/$(date +%m).md"
