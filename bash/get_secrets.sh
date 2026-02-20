#!/bin/bash
set -x 
SECRET_ID=$(env  | grep AWS_SECRET_ID | cut -d '=' -f2-)
AWS_REGION=$(env  | grep AWS_REGION | cut -d '=' -f2-)

function get_secrets {
    aws secretsmanager get-secret-value --region $AWS_REGION\
        --secret-id $SECRET_ID \
        | jq --raw-output '.SecretString' \
        | jq '.' \
        | jq -r "to_entries|map(\"\(.key)=${SECRET_ID}/\(.key|tostring)\")|.[]" > secrets.txt  
}

function create_env_file {
    awssecret2env --aws-region $AWS_REGION --output env_file --export secrets.txt
    eval source env_file && env > .env
}

function get_ec2_ip {
    EC2_PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
    echo "EC2_PRIVATE_IP=$EC2_PRIVATE_IP"
    DOMAIN_NAME=$(grep ALLOWED_HOSTS .env | cut -d '=' -f2)
    echo "DOMAIN_NAME=$DOMAIN_NAME"
}

function set_allowed_hosts_var {
    ALLOWED_HOSTS="$DOMAIN_NAME,$EC2_PRIVATE_IP"
    echo "ALLOWED_HOSTS=$ALLOWED_HOSTS"
    sed -i 's/\(ALLOWED_HOSTS=\)\(.*\)/\1'"$ALLOWED_HOSTS"'/' .env
}


function initialize {
    get_secrets
    create_env_file
    get_ec2_ip
    set_allowed_hosts_var
}

initialize