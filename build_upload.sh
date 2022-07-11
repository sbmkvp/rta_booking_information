#! /bin/bash

docker build --no-cache -t rta_booking . &&
aws ecr get-login-password --region ap-southeast-2 \
  | docker login \
    --username AWS \
    --password-stdin "$(jq -r .ecr_arn settings.json)" &&
docker tag rta_booking:latest "$(jq -r .ecr_arn settings.json)/rta_booking:latest"
docker push "$(jq -r .ecr_arn settings.json)/rta_booking:latest"

