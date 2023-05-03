#!/bin/bash

set -e

# Install containerd
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum list | grep containerd
yum install -y containerd.io.x86_64

# Config
mkdir -p /etc/containerd 
containerd config default > /etc/containerd/config.toml  
sed -i "s#k8s.gcr.io#registry.cn-hangzhou.aliyuncs.com/google_containers#g"  /etc/containerd/config.toml 
sed -i '/plugins."io.containerd.grpc.v1.cri".registry.mirrors/a\ \ \ \ \ \ \ \ [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]\n\ \ \ \ \ \ \ \ \ \ endpoint = ["https://frz7i079.mirror.aliyuncs.com"]' /etc/containerd/config.toml

# Run Containerd as systemd service
systemctl daemon-reload 
systemctl enable containerd 
systemctl restart containerd

# crictl
VERSION="v1.22.0"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz

cat <<EOF> /etc/crictl.yaml 
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
EOF
