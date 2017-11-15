#!/bin/zsh 
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

function gs_invite_gauss() {
    PASSAGE_ENDPOINT="https://passage.g8s.gauss.eu-central-1.aws.gigantic.io"
    GS_AUTH_TOKEN="$GS_GAUSS_AUTH_TOKEN"
    ORGNAME=giantswarm
    EMAIL=$1
    curl -X POST ${PASSAGE_ENDPOINT}/invite/ \
     -H "Authorization: giantswarm ${GS_AUTH_TOKEN}" \
     -H "Content-Type:application/json" \
     -d "{ 
        \"email\": \"${EMAIL}\", 
        \"organizations\": [\"${ORGNAME}\"], 
        \"send_email\": true, 
        \"account_expiry_days\": 1000
      }"
}
