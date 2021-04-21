#!/bin/bash

#Run as root

source variable.sh

#create cluster

cat <<EOF >> /etc/docker/daemon.json

{
      "registry-mirrors": ["https://registry.dockercn.com","https://mj9kvemk.mirror.aliyuncs.com"]
}
EOF

service docker restart

kubeadm config images pull

kubeadm init --pod-network-cidr=$NETWORK_CIDR  --apiserver-advertise-address=$MASTER_IP

su - $USERNAME <<EOF
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
EOF

sudo chown $USERNAME:$USERNAME $HOME/.kube/config

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
