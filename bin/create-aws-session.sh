#!/bin/sh

set -eu

if [ "$#" -ne 2 ]; then
    echo "Usage: create-aws-session <MFA_ARN> <MFA_TOKEN>"
    exit 1
fi

MFA_ARN=$1
MFA_TOKEN=$2

CREDENTIALS=$(aws sts --profile giantswarm-permanent get-session-token --serial-number "$MFA_ARN" --token-code $MFA_TOKEN)

ACCESS_KEY=$(echo $CREDENTIALS|jq --raw-output  ".Credentials.AccessKeyId")
SECRET_KEY=$(echo $CREDENTIALS|jq --raw-output  ".Credentials.SecretAccessKey")
SESSION_TOKEN=$(echo $CREDENTIALS|jq --raw-output  ".Credentials.SessionToken")

sed -i '/^\[giantswarm\]$/,/^\[/ s#^aws_access_key_id = .*#aws_access_key_id = '"$ACCESS_KEY"'#' /home/jgsqware/.config/kb_dotfile/aws.credentials
sed -i '/^\[giantswarm\]$/,/^\[/ s#^aws_secret_access_key = .*#aws_secret_access_key = '"$SECRET_KEY"'#' /home/jgsqware/.config/kb_dotfile/aws.credentials
sed -i '/^\[giantswarm\]$/,/^\[/ s#^aws_session_token = .*#aws_session_token = '"$SESSION_TOKEN"'#' /home/jgsqware/.config/kb_dotfile/aws.credentials
