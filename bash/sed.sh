#!/bin/bash
set -e

sed -i "s|redis_address|${REDIS_ADDRESS}|g" config/staging.yaml

sed -i "s|couch_address|${COUCH_ADDRESS}|g" config/staging.yaml

sed -i "s|es_address|${ELASTICSEARCH_HOST}|g" config/staging.yaml

sed -i "s|dynamo_address|${DYNAMO_DB}|g" config/staging.yaml

sed -i "s|aws_region|${AWS_DEFAULT_REGION}|g" config/staging.yaml

sed -i "s|base_url|${BASE_URL}|g" config/staging.yaml

sed -i "s|S3_BUCKET|${S3_BUCKET}|g" config/staging.yaml

sed -i "s|S3_URL|${S3_URL}|g" config/staging.yaml

sed -i "s|aws_access_id|${AWS_ACCESS_KEY_ID}|g" config/staging.yaml

sed -i "s|aws_access_key|${AWS_SECRET_ACCESS_KEY}|g" config/staging.yaml

sed -i "s|FRONTEND_URL|${FRONTEND_URL}|g" config/staging.yaml