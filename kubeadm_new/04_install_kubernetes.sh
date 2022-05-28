#!/bin/bash

set -e

./use_aliyun_kubernetes_yum_source.sh

setenforce 0
yum install -y kubelet-1.24.0 kubeadm-1.24.0 kubectl-1.24.0


# Check Containerd version
crictl version

# Set containerd as cri 
crictl config runtime-endpoint /run/containerd/containerd.sock

systemctl daemon-reload
systemctl enable kubelet && systemctl start kubelet
