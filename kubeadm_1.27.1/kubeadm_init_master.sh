#!/bin/bash

set -e

# Pre-configure
./01_pre_check_and_configure.sh

# Install ipvs
./02_install_ipvs.sh

# Install containerd
./03_install_containerd.sh

# Install kubelet kubeadm kubectl
./04_install_kubernetes.sh

# Initialize k8s master
./05_kubeadm_init.sh

# Install flannel Pod network
./06_install_flannel.sh
