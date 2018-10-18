#!/usr/bin/env bash

set -eu

if [ -z "$1" ]; then
    printf "No cluster id supplied\n"
    exit 0
fi

if [ -z "$2" ]
then
    printf "No installation codename supplied\n"
    exit 0
fi

CLUSTER=$1
INSTALLATION=$2
return="no"

gsctl select endpoint ${INSTALLATION}
gsctl create kubeconfig --cluster ${CLUSTER} --certificate-organizations system:masters --ttl 1d 
api=$(gsctl show cluster ${CLUSTER} | grep API | awk '{print $4}' | sed 's/https:\/\///')

function check_certs() {
    echo "Worker IP:" $1
    opsctl ssh --machine-user giantswarm --cert-based ${INSTALLATION} master1 --cmd "ssh -q -oStrictHostKeyChecking=no ${USER}@${1} 'sudo openssl x509 -in /etc/kubernetes/ssl/worker-crt.pem -noout -text | grep After '"
    read -r -p "Is the certificate renewed? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
    then
        return="yes"
    else
        return="no"
    fi
}

function check_master_certs() {
    echo "Master IP:" $1
    opsctl ssh --machine-user giantswarm --cert-based ${INSTALLATION} master1 --cmd "ssh -q -oStrictHostKeyChecking=no ${USER}@${1} 'sudo openssl x509 -in /etc/kubernetes/ssl/apiserver-crt.pem -noout -text | grep After '"
    read -r -p "Is the certificate renewed? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
    then
        return="yes"
    else
        return="no"
    fi
}

# ROLLING MASTER NODE
read -r -p "Do you want to check or reboot the master? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    master=$(kubectl --context giantswarm-${CLUSTER} get node -l role=master -o json | jq -r ".items[0].status.addresses[0].address")
    check_master_certs $master

    if [ "$return" == "no" ]
    then 
        while true; do
            opsctl ssh --jumphost-user $USER --machine-user giantswarm --cert-based ${INSTALLATION} master1 --cmd "ssh -oStrictHostKeyChecking=no ${USER}@${master} sudo reboot"
            printf "Rebooting master $master \n"

            while true; do
                printf '.'
                sleep 5
                code=$(curl --silent --output /dev/null --write-out "%{http_code}" https://$api -k)
                if [ "$code" == "401" ]
                then 
                  break
                fi
            done 

            printf "\n master back again! \n"
            sleep 5

            check_master_certs $master
            if [ "$return" == "yes" ]
            then 
              break
            fi
        done
    fi
else
    printf "Sckipping master node \n"
fi

# ROLLING WORKER NODES 
number_nodes=$(($(kubectl --context giantswarm-${CLUSTER} get node -l role!=master | wc -l) + 0)) 
printf "\nRolling now $number_nodes worker nodes\n"
for node in $(kubectl --context giantswarm-${CLUSTER} get node -l role!=master -o json | jq -r ".items[].status.addresses[0].address"); do 
    read -r -p "Do you want to check or reboot the $node? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
    then
        check_certs $node
        if [ "$return" == "yes" ]
        then 
            continue
        fi

        printf "Draining node ${node}\n"
        kubectl --context giantswarm-${CLUSTER} drain -l ip=$node --ignore-daemonsets --delete-local-data --force

        while true; do
            printf "Rebooting node ${node}\n"
            opsctl ssh --jumphost-user $USER --machine-user giantswarm --cert-based ${INSTALLATION} master1 --cmd "ssh -oStrictHostKeyChecking=no ${USER}@${node} sudo reboot"
            sleep 45 #default timeout after api consider node not ready
            
            while true; do
                printf '.'
                sleep 5
                ready=$(kubectl --context giantswarm-${CLUSTER} get node -l ip=$node | grep " Ready")
                if [ -n "$ready" ]
                then 
                    break
                fi
            done

            printf "Node ready again\n"
            check_certs $node
            if [ "$return" == "yes" ]
            then 
                break
            fi
        done

        printf "Uncordoning ${node} \n"
        kubectl --context giantswarm-${CLUSTER} uncordon -l ip=$node

        ((number_nodes-=1)) #skip last node
        if [ "$number_nodes" == 0 ]
        then
            break
        fi

        echo "$(date)"
        printf "Waiting 5 minutes extre to be sure all workloads are spinned up correctly in other node \n\n"
        sleep 90
    else
        echo "Skipping node $node"
    fi
done;