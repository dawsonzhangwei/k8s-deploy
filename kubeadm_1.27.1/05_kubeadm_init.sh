#!/bin/bash

set -e

# Reset firstly if ran kubeadm init before
kubeadm reset

cat > ./kubeadm.yaml <<EOF
apiVersion: kubeadm.k8s.io/v1beta3
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 172.29.169.68
  bindPort: 6443
nodeRegistration:
  criSocket: unix:///var/run/containerd/containerd.sock
  imagePullPolicy: IfNotPresent
  name: k8s-master
  taints: null
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta3
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns: {}
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: registry.cn-hangzhou.aliyuncs.com/google_containers
kind: ClusterConfiguration
kubernetesVersion: 1.24.0
networking:
  dnsDomain: cluster.local
  podSubnet: 10.244.0.0/16
  serviceSubnet: 10.96.0.0/12
scheduler: {}
--- 
apiVersion: kubeproxy.config.k8s.io/v1alpha1 
kind: KubeProxyConfiguration 
mode: ipvs 
--- 
apiVersion: kubelet.config.k8s.io/v1beta1 
kind: KubeletConfiguration 
cgroupDriver: systemd
EOF

# kubeadm init with flannel network
kubeadm init --config=kubeadm.yaml 

# kube
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo "export KUBECONFIG=$HOME/.kube/config" >> $HOME/.bash_profile
source $HOME/.bash_profile


# auto complete
yum install -y bash-completion 
source /usr/share/bash-completion/bash_completion 
source <(kubectl completion bash) 
echo "source <(kubectl completion bash)" >> ~/.bashrc