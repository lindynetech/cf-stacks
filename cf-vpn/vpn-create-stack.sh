#!/bin/bash -ex

VpcId="$(aws ec2 describe-vpcs --filter "Name=isDefault, Values=true" --query "Vpcs[0].VpcId" --output text)"
SubnetId="$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VpcId" --query "Subnets[0].SubnetId" --output text)"
SharedSecret="$(openssl rand -base64 30)"
Password="$(openssl rand -base64 30)"
keypair=sysops-key

aws cloudformation create-stack --stack-name cf-vpn \
--template-body file://vpn-stack.yml \
--parameters "ParameterKey=KeyName,ParameterValue=$keypair" \
"ParameterKey=VPC,ParameterValue=$VpcId" \
"ParameterKey=Subnet,ParameterValue=$SubnetId" \
"ParameterKey=IPSecSharedSecret,ParameterValue=$SharedSecret" \
"ParameterKey=VPNUser,ParameterValue=vpn" \
"ParameterKey=VPNPassword,ParameterValue=$Password"

aws cloudformation wait stack-create-complete --stack-name cf-vpn

aws cloudformation describe-stacks --stack-name cf-vpn --query "Stacks[0].Outputs"