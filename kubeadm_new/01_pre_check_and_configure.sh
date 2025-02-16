#!/bin/bash

set -e

echo "###############################################"
echo "Please ensure your OS is CentOS7 64 bits"
echo "Please ensure your machine has full network connection and internet access"
echo "Please ensure run this script with root user"

# Check hostname, Mac addr and product_uuid
echo "###############################################"
echo "Please check hostname as below:"
uname -a

echo "###############################################"
echo "Please check Mac addr and product_uuid as below:"
ip link
sudo cat /sys/class/dmi/id/product_uuid

# Stop firewalld
echo "###############################################"
echo "Stop firewalld"
systemctl stop firewalld
systemctl disable firewalld

# Disable SELinux
echo "###############################################"
echo "Disable SELinux"
setenforce 0
cp -p /etc/selinux/config /etc/selinux/config.bak$(date '+%Y%m%d%H%M%S')
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# Turn off Swap
echo "###############################################"
echo "Turn off Swap"
swapoff -a
sed -ri 's/.*swap.*/#&/' /etc/fstab
mount -a
free -m
cat /proc/swaps

# Setup iptables (routing)
echo "###############################################"
echo "Setup iptables (routing)"
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-arptables = 1
net.ipv4.ip_forward = 1
vm.swappiness=0 
EOF

modprobe br_netfilter
sysctl -p /etc/sysctl.d/k8s.conf

# Time Sync
yum install chrony -y
systemctl enable chronyd
systemctl start chronyd
chronyc sources

# Use Aliyun Yum source
echo "###############################################"
echo "Use Aliyun Yum source"
./use_aliyun_yum_source.sh



