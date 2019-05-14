#!/bin/bash

#colors
GREEN=$(tput setaf 034)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)
RESET=$(tput sgr0)

EMAIL=julien@giantswarm.io
TMP_FILE=/tmp/.tmp_creds
ACCOUNT_TABLE="${KB_DOTFILE}/.aws-account_table"
GS_AWS_ACCOUNT_ID="084190472784"
AWS_MFA_ID="arn:aws:iam::${GS_AWS_ACCOUNT_ID}:mfa/${EMAIL}"

# read stuff
echo "enter customer AWS account (enter 'None' for giantswarm acc)"; read ACCOUNT
echo "> all information requested." ;echo;

MFA_TOKEN=$(ykman oath code | grep AWS-GS | awk '{print $2}')
echo "> generating tmp creds for giantswarm account"
# generate tmp credentials
echo ${AWS_MFA_ID}  ${MFA_TOKEN}
aws sts --profile giantswarm get-session-token --serial-number ${AWS_MFA_ID} --token-code ${MFA_TOKEN} > ${TMP_FILE}
echo ">> aws creds fetched"
AWS_KEY_ACCESS=`jq .Credentials.SecretAccessKey ${TMP_FILE} | cut -d\" -f2`
AWS_KEY_ID=`jq .Credentials.AccessKeyId ${TMP_FILE} | cut -d\" -f2`
AWS_SESSION_TOKEN=`jq .Credentials.SessionToken ${TMP_FILE} | cut -d\" -f2`
echo ">> aws creds parsed"
rm -f ${TMP_FILE}
PROFILE_ID="giantswarm-session-"`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1`
## add tmp profile to aws credential file
cat >> ~/.aws/credentials << EOF
[${PROFILE_ID}]
aws_access_key_id=${AWS_KEY_ID}
aws_secret_access_key=${AWS_KEY_ACCESS}
aws_session_token=${AWS_SESSION_TOKEN}
EOF
echo ">> aws creds stored into tmp file"

echo "> done";echo;
if [ "$ACCOUNT" == "None" ];then
        echo "Temporary aws credentials generated."
        echo "Please use: '${GREEN}${BOLD}${PROFILE_ID}${RESET}' as aws profile."
else
        ACCOUNT_ID=`jq .${ACCOUNT}.id ${ACCOUNT_TABLE} | cut -d\" -f2`
	echo "> generating tmp profile for ${ACCOUNT}  id: ${ACCOUNT_ID}"
        aws sts --profile ${PROFILE_ID} assume-role --role-session-name ${EMAIL} --role-arn arn:aws:iam::${ACCOUNT_ID}:role/GiantSwarmAdmin > ${TMP_FILE}
	echo ">> aws tmp creds fetched"
        AWS_KEY_ACCESS=`jq .Credentials.SecretAccessKey ${TMP_FILE} | cut -d\" -f2`
        AWS_KEY_ID=`jq .Credentials.AccessKeyId ${TMP_FILE} | cut -d\" -f2`
        AWS_SESSION_TOKEN=`jq .Credentials.SessionToken ${TMP_FILE} | cut -d\" -f2`
        rm -f ${TMP_FILE}
	echo ">> aws tmp creds parsed"
	
        PROFILE_ID="${ACCOUNT}-session-"`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1`

        ## add tmp profile to aws credential file
        cat >> ~/.aws/credentials << EOF
[${PROFILE_ID}]
aws_access_key_id=${AWS_KEY_ID}
aws_secret_access_key=${AWS_KEY_ACCESS}
aws_session_token=${AWS_SESSION_TOKEN}
EOF
	echo ">> aws tmp creds saved"
	echo "> done";echo;

echo "Please use: ${GREEN}${BOLD}$PROFILE_ID${RESET} as aws profile."
  
fi<Paste>
