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
sudo pip3 install --upgrade pip
sudo pip3 install -r ./taskgen/requirements.txt
sudo pip3 install dicttoxml
sudo sh -c 'echo "\nauto br0\niface br0 inet static\n\thwaddress ether DE:AD:BE:EF:69:01\n\taddress 10.200.40.10\n\tnetmask 255.255.248.0\n\tgateway 10.200.40.10\nbridge_ports eth0\nbridge_stp off\nbridge_maxwait 0\nbridge_fd 0\n" >> /etc/network/interfaces'

sudo /etc/init.d/networking restart

sudo cp ./dhcpd.conf /etc/dhcp/

sudo systemctl enable isc-dhcp-server
sudo systemctl start isc-dhcp-server
