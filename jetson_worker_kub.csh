# Not to be ran as a script as is.  
# Verify the first 3 commands and adjust to 
# Network config, Delete lines and then should be able to run
# if not, call individually. 

container-runtime --version
# Verify output: 
# runc version 1.1.0-0ubuntu1~18.04.1
# spec: 1.0.2-dev
# go: go1.16.2
# libseccomp: 2.5.1

lsb_release -a
# Verify output:
# No LSB modules are available.
# Distributor ID: Ubuntu
# Description: Ubuntu 18.04.6 LTS
# Release: 18.04
# Codename: bionic

# Verify Jetson is installed
pt-cache show nvidia-jetpack

sudo apt-get update && sudo apt-get upgrade && sudo apt autoremove

sudo apt-get -y install python3-pip curl && sudo pip3 install -U jetson-stats

sudo echo "# Disable IPv6\
net.ipv6.conf.all.disable_ipv6 = 1\
net.ipv6.conf.default.disable_ipv6 = 1\
net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

sudo echo "CONFIGURE_INTERFACES=no">> /etc/default/networking 

sudo echo "auto eth0\
iface eth0 inet static\
  address 192.168.1.5\
    netmask 255.255.255.0\
      gateway 192.168.1.1" > /etc/default/networking 
 apt-cache show nvidia-jetpack

 sudo echo "127.0.0.1 localhost\
 192.168.1.2 node01 node01.local\
 192.168.1.3 node02 node02.local\
 192.168.1.4 node03 node03.local\
 192.168.1.5 node04 node04.local" > /etc/hosts

 set-hostname node04

 curl -sfL https://get.k3s.io | K3S_URL=https://10.0.0.60:6443 K3S_TOKEN=myrandompassword sh -

 cp /var/lib/rancher/k3s/agent/etc/containerd/config.toml /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl

 sudo echo "[plugins."io.containerd.grpc.v1.cri".containerd]\
   snapshotter = "overlayfs"\
   disable_snapshot_annotations = true\
   default_runtime_name = "nvidia" " >> /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl

 systemctl restart containerd
 systemctl restart k3s-agent

 docker run --rm --runtime nvidia xift/jetson_devicequery:r32.5.0

 ctr i pull docker.io/xift/jetson_devicequery:r32.5.0
 ctr run --rm --gpus 0 --tty docker.io/xift/jetson_devicequery:r32.5.0 deviceQuery

 kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.13.0/nvidia-device-plugin.yml

 kubectl get pods -n kube-system | grep nvidia-device-plugin
 nvidia-device-plugin-daemonset-gpljh 1/1 Running 0 50m
 nvidia-device-plugin-daemonset-2hsmv 1/1 Running 0 50m
 nvidia-device-plugin-daemonset-4b2dj 1/1 Running 0 50m
 nvidia-device-plugin-daemonset-cn7zf 1/1 Running 2 (28m ago) 50m
