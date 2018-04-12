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
sudo apt-get install python3.5 -qq #probably needs sudo
sudo apt-get  install python3-pip -qq
sudo apt-get install bridge-utils -qq
#sudo pip3 install service #should be pip3, do same commandswork? https://pypi.python.org/pypi/service/0.4.1
#sudo pip3 install pynetlinux #1.1 or somewhat close with the 1.1 and everything https://pypi.python.org/pypi/pynetlinux/1.1
sudo pip3 install -r /vagrant/taskgen/requirements.txt
#sudo sh -c 'echo "import sys\nsys.path.append(\"/usr/local/lib/python3.5/dist-packages/pynetlinux\")\n$(cat /usr/local/lib/python3.5/dist-packages/pynetlinux/__init__.py)" > /usr/local/lib/python3.5/dist-packages/pynetlinux/__init__.py'
sudo sh -c 'echo "auto br0\niface br0 inet dhcp\nbridge_ports eth0\nbridge_stp off\nbridge_maxwait 0\nbridge_fd 0\n" >> /etc/network/interfaces'
sudo apt-get install qemu -qq
sudo apt-get install screen -qq
sudo apt-get install nmap isc-dhcp-server -qq
sudo cp /vagrant/dhcpd.conf /etc/dhcp/
sudo apt-get install htop -qq
