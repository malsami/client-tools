#!/bin/bash
#######################
#
# This is a provision script
# it will be called once when the vagrant vm is first provisioned
# If you have commands that you want to run always please have a
# look at the bootstrap.sh script
#
# Contributor: Bernhard Blieninger
######################
sudo apt-get update -qq
sudo apt-get install python3.5 python3-pip bridge-utils screen nmap isc-dhcp-server qemu htop pkg-config zlib1g-dev libglib2.0 libpixman-1.0 libpixman-1-dev -qq #probably needs sudo
#sudo apt-get  install python3-pip -qq
#mkdir -p qemu
#cd qemu
#wget -qO- https://download.qemu.org/qemu-2.11.1.tar.xz | tar xJ
#cd qemu-2.11.1
#./configure --target-list=arm-softmmu
#make -j4
#sudo make install
#sudo apt-get install bridge-utils -qq
sudo pip3 install -r /vagrant/taskgen/requirements.txt
sudo pip3 install dicttoxml
sudo sh -c 'echo "auto br0\niface br0 inet dhcp\nbridge_ports eth0\nbridge_stp off\nbridge_maxwait 0\nbridge_fd 0\n" >> /etc/network/interfaces'
#sudo apt-get install qemu -qq
#sudo apt-get install screen -qq
#sudo apt-get install nmap isc-dhcp-server -qq
sudo cp /vagrant/dhcpd.conf /etc/dhcp/
#sudo apt-get install htop -qq