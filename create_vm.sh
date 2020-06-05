#!/bin/bash

# Helper script:
# Spin up a VM on Azure and deploy the streamlit app there
# Use at own risk!
# Requires azure-cli

name=$1
group="streamlit"
region=australiasoutheast
datadir=data
appdir=app

if [ -n "$2" ]; then
    group=$2
fi
if [ -n "$3" ]; then
    region=$3
fi

image=ubuntu1804lts-python-docker-zerto
image="zerto:azure-vms-by-zerto:ubuntu1804lts-python-docker-zerto:1.0.0"

az vm create --resource-group $group \
  --name $name \
  --image $image \
  --authentication-type ssh \
  --ssh-key-values $HOME/.ssh/id_rsa.pub \
  --priority Spot \
  --max-price 0.03 \
  --output json \
  --verbose | tr '\r\n' ' ' > /tmp/vm.json

echo "VM created."
ip=$(jq -r '.publicIpAddress' /tmp/vm.json)
echo "IP: $ip"

ssh -o StrictHostKeyChecking=no $ip "sudo docker pull coljac/streamlit_ds:latest"

echo "Copying data to VM..."
rsync -avhW --progress $datadir $ip:.
rsync -avhW --progress $appdir $ip:.
scp run.sh $ip:

echo "Opening port 80"
az vm open-port -g $group -n $name --port 80 > /tmp/port.json

ssh $ip "sudo sh run.sh"
echo "App running at: http://$ip/"


