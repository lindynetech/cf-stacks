#!/bin/bash

stackName=twok8s-clusters

aws cloudformation create-stack --stack-name $stackName --template-body file://stack.yml && \
aws cloudformation wait stack-create-complete --stack-name $stackName && \
sleep 120 && \
ansible-playbook playbook.yml