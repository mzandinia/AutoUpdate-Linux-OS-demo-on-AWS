#!/bin/bash
apt update
apt install -y git python3-pip sshpass
python3 -m pip install ansible
echo "# set PATH so it includes user's private bin if it exists" >> /root/.bashrc
echo """if [ -d "/root/.local/bin" ] ; then""" >> /root/.bashrc
echo """    PATH="/root/.local/bin:$PATH"""" >> /root/.bashrc
echo 'fi' >> /root/.bashrc
cd /home/admin
git clone https://github.com/mzandinia/AutoUpdate-Linux-OS.git
chown -R admin:admin /home/admin
