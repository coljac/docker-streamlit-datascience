#!/bin/bash

# Helper script:
# Spin up a VM on Azure and deploy the streamlit app there
# Use at own risk!
# Requires azure-cli

# create_vm.sh vm-name [group] [datadir] [appdir]

name=$1
group="streamlit"
datadir=data
appdir=app

if [ -z "$1" ]
then
    tput bold; echo "Usage: create_vm.sh vm-name [group] [datadir] [appdir]"
    exit 0
fi

if [ -n "$2" ]
then
    group=$2
fi


if [ -n "$3" ]
then
    datadir=$3
fi

if [ -n "$4" ]
then
    appdir=$4
fi

if [ ! -d "$datadir" ] 
then
    tput setaf 3; echo "Warning: Data dir doesn't exist."; tput sgr0 
fi

if [ ! -d "$appdir" ]
then
    tput setaf 1; echo "Error: No script dir - $appdir not found."
    exit 1
fi

image=ubuntu1804lts-python-docker-zerto
image="zerto:azure-vms-by-zerto:ubuntu1804lts-python-docker-zerto:1.0.0"

tput setaf 7; echo "Creating virtual machine $name:"; tput sgr0 

az vm create --resource-group $group \
  --name $name \
  --image $image \
  --authentication-type ssh \
  --ssh-key-values $HOME/.ssh/id_rsa.pub \
  --priority Spot \
  --max-price 0.03 \
  --output json \
  --verbose  > /tmp/vm.json

if [ $? != "0" ]
then
    tput setaf 1; echo "Create failed."
    exit $?
fi

tput setaf 2; echo "VM created."; tput sgr0 

nc -zv $ip 22

ip=$(cat /tmp/vm.json |  tr '\r\n' ' ' | jq -r '.publicIpAddress')
echo "IP: $ip"
echo
echo "Grabbing docker image:"

ssh -o StrictHostKeyChecking=no $ip "sudo docker pull coljac/streamlit_ds:latest"

echo "Copying data to VM..."

rsync -avhW --progress $datadir $ip:.
rsync -avhW --progress $appdir $ip:.
scp run.sh $ip:

echo "Opening port 80"
az vm open-port -g $group -n $name --port 80 > /tmp/port.json

if [ $? != "0" ]
then
    tput setaf 1; echo "Failed."
    exit $?
fi

ssh $ip "sudo sh run.sh"

tput setaf 2; tput bold; echo "App running at: http://$ip/"; tput sgr0 


