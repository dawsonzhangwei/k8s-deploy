#!/bin/bash

set -e

# Install containerd
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
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
