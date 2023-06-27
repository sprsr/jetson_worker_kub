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
  address 192.168.1.155\
    netmask 255.255.255.0\
      gateway 192.168.1.1" > /etc/default/networking 
