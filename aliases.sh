#!/bin/zsh

alias vim="nvim"
# Git aliases
alias gvend="git add vendor glide.* && git commit -m 'update Glide vendors'"
alias gh="xdg-open \`git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//'\`"
alias sha="git rev-parse HEAD | xclip -selection clipboard"
# Shell Aliases
alias zsh_alias="vim ~/.oh-my-zsh/functions/aliases.sh"
alias zshconfig="vim ~/.zshrc"
alias workspace="cd $WORKSPACE"
alias env_dir="cd $ENV"
alias env_ansible="code $ENV/ansible"
alias h="history"
alias hg="history | grep -i"
alias pg="ps aux | grep -i"
alias ip_wifi="ipconfig getifaddr en0"
alias render="xrandr --output DP-1 --mode 2560x1440 --panning 3840x2160+3840+1440 --scale 1.5x1.5 --right-of eDP-1 && xrandr --output DP-1 --mode 2560x1440 --panning 3840x2160+3840+0 --scale 1.5x1.5 --right-of eDP-1"
alias mux="tmuxinator"

# Docker
alias docker-rmid="docker images --quiet --filter=dangling=true | xargs docker rmi -"
alias dkc="docker-compose"
alias dslack="/home/jgsqware/workspace/apps/docker/slack/run-slack.sh"
# Applications
alias mvn7='docker run --rm -v ~/.m2:/root/.m2 -v $(pwd):/src -v /dev/urandom:/dev/random -w /src -e "MAVEN_OPTS= -XX:+TieredCompilation -XX:TieredStopAtLevel=1" -t maven:3-jdk-7 mvn'
alias mvn8='docker run --rm -v ~/.m2:/root/.m2 -v $(pwd):/src -v /dev/urandom:/dev/random -w /src -e "MAVEN_OPTS= -XX:+TieredCompilation -XX:TieredStopAtLevel=1" -t maven:3-jdk-8 mvn'
alias stream='mkchromecast --encoder-backend ffmpeg --alsa-device hw:0,1 --name Bureau -b 320 --control'
alias agv='ag --ignore=vendor/'
# Go
alias playground="code $GOPATH/src/github.com/jgsqware/playground"
alias godocs='godoc -http=":6060"'
alias guv="glide update -v"

# Giantswarm
export GS="$GOPATH/src/github.com/giantswarm/"
export GS_AWS_OPERATOR="~/.ssh/aws-operator"
alias gingerctl="gsctl --endpoint https://api.g8s.ginger.eu-central-1.aws.gigantic.io --auth-token $GS_GINGER_AUTH_TOKEN"
alias gaussctl="gsctl --endpoint https://api.g8s.gauss.eu-central-1.aws.gigantic.io --auth-token $GS_GAUSS_AUTH_TOKEN"
alias gaussctl_kubeconfig="gaussctl create kubeconfig --certificate-organizations='system:masters' -c"
alias irisctl="gsctl --endpoint https://api.g8s.iris.eu-central-1.aws.gigantic.io "
alias irisctl_kubeconfig="irisctl create kubeconfig --certificate-organizations='system:masters' -c"
alias aws_ssh="ssh -i ~/.ssh/aws-operator"
alias vpn_tcp="sudo openvpn /home/jgsqware/workspace/giantswarm/openvpn/openvpn-tcp.conf"
alias vpn_ucp="sudo openvpn /home/jgsqware/workspace/giantswarm/openvpn/openvpn-ucp.conf"
alias core-toolbox="sh ~/workspace/apps/core-toolbox"
alias k="kubectl"
alias slackutil="docker run --rm -ti -e SLACK_TOKEN=${SLACK_TOKEN} giantswarm/slackutil"

function gs_support_start() {
    slackutil join --include "support-*"
    slackutil star --include "support"
    slackutil unmute --include "support-*"
}

function gs_support_stop() {
    slackutil unstar --include "support"
    slackutil mute --include "support-*"
}

function fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

function fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}
