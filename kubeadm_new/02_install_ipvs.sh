#!/bin/bash

set -e

# Install ipvs
cat > /etc/sysconfig/modules/ipvs.modules <<EOF
modprobe -- ip_vs 
modprobe -- ip_vs_rr 
modprobe -- ip_vs_wrr 
modprobe -- ip_vs_sh 
modprobe -- nf_conntrack
EOF

chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack

# Install ip set
yum install -y ipset

# Install ipvsadm
yum install -y ipvsadm
