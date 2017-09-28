#!/usr/bin/env bash
# We want this script to exit if we get any errors
set -e
set -x
# This script pushes the built docker image to the repository

# We should have secrets file created by create_ecr_secrets.sh, encoded
# in the dev environment and decoded in the travis environment

# Import the AWS ECR variables
. ./ecr.secrets

# if we got a tag name from gitub it will be in $TRAVIS_TAG
# If we have a tag name, use it in repository, else use latest
TAG=$TRAVIS_TAG
if [ -z $TRAVIS_TAG ]; then
  # Github tag was empty.. use 'latest'
  TAG='latest'
fi

# Log into the AWS ECR repository
docker login -u ${ECR_USER} -p ${ECR_PASS} ${ECR_URL}
# Tag the image we built
# TODO: get a tagged version number from github, instead of "latest"
docker tag flask_docker_lab:latest ${ECR_DNS}/flask_docker_lab:${TAG}
# Now push the docker image to AWS ECR repository
docker push ${ECR_DNS}/flask_docker_lab:${TAG}
