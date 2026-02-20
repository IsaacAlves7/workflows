#!/bin/bash
#script to deploy cluster

if [ -z $CLUSTER_NAME ] 
then
  set -x
  read -e -p  "Cluster name:" -i "" CLUSTER_NAME
fi
if [ -z $REGION ] 
then
  set -x
  read -e -p  "Region name:" -i "" REGION
fi
## enviromment variables ##
KeyName="ezops"


## ECS Variables ##
ECSInstanceType="t3.micro"
AsgServiceMin="1"
AsgServiceDesired="1"
AsgServiceMax="2"

## RDS Parameters ##
HOSTED_ZONE_NAME="bko.ezops.cloud."
DBEngine="aurora-mysql"
DBEngineVersion="5.7"
DBEngineFamily="aurora-mysql5.7"
DB_TYPE="db.t3.small"
DB_SNAPSHOT="WITHOUT"
DB_HAS_AUTOMATIC_BACKUP="true"
CIDR_IP="10.10.0.0"

## Redis Parameters ##
CACHE_NODE_TYPE="cache.t3.small"
NUM_CACHE_NODE="2"

## elb Parameters ##
AcmCertificateArn="arn:aws:acm:us-east-2:975635808270:certificate/a5437f38-2c68-4850-95a7-94c6a6200e4a"

if [ -z "$ACCESS_ID" ] 
then
  ACCESS_ID=$(cat ~/.aws/credentials | grep aws_access_key_id | awk '{print $3}')
  ACCESS_KEY=$(cat ~/.aws/credentials | grep aws_secret_access_key | awk '{print $3}')

  if [ -z "$ACCESS_ID" ]
  then
    echo "Please input your credencials"
    read -e -p  "Insert your aws_access_key_id:" -i "" ACCESS_ID
    read -e -p  "Insert your aws_secret_access_key:" -i "" ACCESS_KEY
  fi
fi

function runStages
{
    function installDependencies
  {

  sudo apt-get update 
  sudo apt-get install zip curl jq awscli -y
  curl -fsSL get.docker.com | sh

  sudo curl -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest
  sudo chmod +x /usr/local/bin/ecs-cli

  }


  function awsCredencial
  {
    $(aws configure set default.region $REGION)
    $(aws configure set aws_access_key_id $ACCESS_ID)
    $(aws configure set aws_secret_access_key $ACCESS_KEY)
  }

  function getsGlobalVariablesAndValidateResources
  {
    InitialPath=$(pwd)

    #== Validate YAMLs
    for i in `find ./ -name *.yml`
    do
      aws cloudformation --region $REGION validate-template --template-body file://${i:2}
    done

    for i in `find ./ -name *.yaml`
    do
      aws cloudformation --region $REGION validate-template --template-body file://${i:2}
    done


    aws ssm put-parameter --region $REGION --type SecureString --name /ECS-CLUSTER/$CLUSTER_NAME/RDS_USER --value user`openssl rand -hex 6` || :
    aws ssm put-parameter --region $REGION --type SecureString --name /ECS-CLUSTER/$CLUSTER_NAME/RDS_PASSWORD --value pass`openssl rand -hex 12` || :

    RDS_USER=$(aws ssm get-parameter --region $REGION --with-decryption --name /ECS-CLUSTER/$CLUSTER_NAME/RDS_USER  --output text --query Parameter.Value)
    RDS_PASS=$(aws ssm get-parameter --region $REGION --with-decryption --name /ECS-CLUSTER/$CLUSTER_NAME/RDS_PASSWORD --output text --query Parameter.Value)
  }

  function deployPipeline
  {
    aws cloudformation deploy --region $REGION --stack-name $CLUSTER_NAME-StackConnection --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --template-file /$InitialPath/cluster/cluster-connection.yml


  }

  function deployCluster
  {
    aws cloudformation deploy --region $REGION --stack-name $CLUSTER_NAME-StackVpc --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --template-file /$InitialPath/cluster/cluster-vpc.yml --parameter-overrides \
      ClusterName=$CLUSTER_NAME


    aws cloudformation deploy --region $REGION --stack-name $CLUSTER_NAME-StackRds --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --template-file /$InitialPath/cluster/cluster-rds.yml --parameter-overrides \
      ClusterName=$CLUSTER_NAME \
      DBUser=$RDS_USER \
      DBEngine=$DBEngine \
      DBInstanceType=$DB_TYPE \
      DBEngineVersion=$DBEngineVersion \
      DBEngineFamily=$DBEngineFamily \
      DBSnapshotName=$DB_SNAPSHOT \
      DBHasAutomaticBackup=$DB_HAS_AUTOMATIC_BACKUP \
      HostedZoneName=$HOSTED_ZONE_NAME \
      CidrIp=$CIDR_IP

    aws cloudformation deploy --region $REGION --stack-name $CLUSTER_NAME-StackRedis --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --template-file /$InitialPath/cluster/cluster-redis.yml --parameter-overrides \
      ClusterName=$CLUSTER_NAME \
      CacheNodeType=$CACHE_NODE_TYPE \
      NumCacheNode=$NUM_CACHE_NODE

    aws cloudformation deploy --region $REGION --stack-name $CLUSTER_NAME-StackElb --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --template-file /$InitialPath/cluster/cluster-elb.yml --parameter-overrides \
      ClusterName=$CLUSTER_NAME \
      DefaultAcmCertificateArn=$AcmCertificateArn \

      EcsImage=$(aws ssm get-parameters --region $REGION --names "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id" \
--query 'Parameters[0].Value' \
--output text)


    aws cloudformation deploy --region $REGION --stack-name $CLUSTER_NAME-StackEcs --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --template-file /$InitialPath/cluster/cluster-ecs.yml --parameter-overrides \
      ClusterName=$CLUSTER_NAME \
      ECSInstanceType=$ECSInstanceType \
      KeyName=$KeyName \
      AsgServiceMinWeb=$AsgServiceMin \
      AsgServiceDesiredWeb=$AsgServiceDesired \
      AsgServiceMaxWeb=$AsgServiceMax \
      EcsImage=$EcsImage

  }


  #installDependencies
  #awsCredencial
  getsGlobalVariablesAndValidateResources
  deployPipeline
  deployCluster
  

}

runStages