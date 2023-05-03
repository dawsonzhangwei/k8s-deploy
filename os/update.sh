#查看当前内核版本
uname -a
cat /etc/redhat-release

#更新yum仓库

##替换阿里云yum源，并升级
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all && yum -y update

##启用elrepo仓库
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm

#升级内核
##安装最新版本内核
yum --enablerepo=elrepo-kernel install kernel-ml

##设置 grub2
rpm -qa | grep -i kernel
awk -F\' ' $1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
yum install -y grub
grub-mkconfig -o /boot/grub/grub.conf
yum install -y grub2
grub2-mkconfig -o /boot/grub2/grub.cfg

##设置新的内核为grub2的默认版本
grub2-set-default 0