#!/bin/bash
# Install python-boto3
# Install helm v3
# Install awscli
# Install ansible (>=2.9)
# Install python-psycopg2

BRANCH=$(git rev-parse --abbrev-ref HEAD)
CONTEXT="arn:aws:eks:us-east-1:160116585046:cluster/ccuat01"
if [ "$BRANCH" != "master" ]
then
  echo "Unable to execute ansible playbook. Current GIT branch is not 'master' it is '$BRANCH'."
else
  echo "Current branch is master, executing playbook now against '$CONTEXT'"
  ansible-galaxy collection install community.aws
  ansible-galaxy collection install community.kubernetes
  ansible-playbook flux-ccuat01.yml -e "context=$CONTEXT"
fi
