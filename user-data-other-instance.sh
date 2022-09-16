#!/bin/bash
useradd -m -s /bin/bash demoautoupdate
chown -R demoautoupdate:demoautoupdate /home/demoautoupdate
echo -e 'changeme\nchangeme' | passwd demoautoupdate
echo 'demoautoupdate ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/demoautoupdate
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
systemctl restart sshd.service