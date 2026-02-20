#!/bin/bash -ax

function getsGlobalVariables
{
  : ${GIT_URL="https://github.com/ezops-br/system"}
  : ${GIT_URL_WITH_AUTH=${GIT_URL:0:8}$GIT_USERNAME:$GIT_PASSWORD@${GIT_URL:8}}
  : ${FOLDER_CORE="/var/lib/ezops-system"}
}

function validateResources
{
  #== Prevent multipe executions
  exec 200>"/tmp/.ezopsSystemLocker" && flock -n 200 
  if [ $? -ne 0 ] 
  then
    echo "Script is already running!!!"
    exit 1  
  fi
    
  #== Verify if is Ubuntu
  if  [ "`lsb_release -is`" != "Ubuntu" ] 
  then
    echo "Distribution is not Ubuntu. Script being closed ..."
    exit 1
  fi
}

function installDependencies
{
  #=== Install pre requisites
    apt-get update
    apt-get -y install zip unzip apt-transport-https software-properties-common vim curl wget jq
   
  #=== Install aws-cli
    apt-get --reinstall install -y python-minimal
    wget -qO- https://s3.amazonaws.com/aws-cli/awscli-bundle.zip > /tmp/awscli-bundle.zip
    unzip -o /tmp/awscli-bundle.zip -d /tmp && \
    /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/bin/aws && \
    rm -rf /tmp/awscli-bundle*

  #=== Install ecs-cli
    wget -qO- https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest > /usr/bin/ecs-cli
    chmod +x /usr/bin/ecs-cli
    
  #=== Install Docker
    wget https://get.docker.com/ -O - | sh

  #=== Install git
    add-apt-repository -y ppa:git-core/ppa 
    apt-get update
    apt-get -y install git rsync
}


function initializeCore
{
  mkdir -p "$FOLDER_CORE"
  cd "$FOLDER_CORE"
  [[ -d "$FOLDER_CORE/.git" ]] || git init
  git pull $GIT_URL_WITH_AUTH $GIT_BRANCH:$GIT_BRANCH
  git checkout -f $GIT_BRANCH
}


#============= Main Line
function main
{
  getsGlobalVariables
  validateResources
  
  if [ ! -d "$FOLDER_CORE/.git" ]
  then
    installDependencies
  fi
  
  initializeCore

  GIT_URL=$GIT_URL \
  GIT_URL_WITH_AUTH=$GIT_URL_WITH_AUTH \
  GIT_USERNAME=$GIT_USERNAME \
  GIT_PASSWORD=$GIT_PASSWORD \
  GIT_BRANCH=$([ "$IS_DEVELOPER_ENVIRONMENT" == "true" ] && echo "$GIT_BRANCH" || echo "client-$JENKINS_ID/master") \
  AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  REGION=$JENKINS_REGION \
  CLUSTER_NAME=$JENKINS_ID \
  CLUSTER_TYPE=$JENKINS_INSTANCE_TYPE \
  CLUSTER_MIN_MACHINES=1 \
  CLUSTER_MAX_MACHINES=1 \
  SITE_CNAME=jenkins-client-$JENKINS_ID.ezops.com.br \
  JENKINS_USERNAME=$JENKINS_USERNAME \
  JENKINS_PASSWORD=$JENKINS_PASSWORD $FOLDER_CORE/devops/lib/Installer/Install/pipeline.sh
    
  $FOLDER_CORE/devops/lib/Installer/Install/always.sh
}

main