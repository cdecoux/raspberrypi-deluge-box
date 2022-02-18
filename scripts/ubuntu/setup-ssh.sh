#!/usr/bin/env sh


apt update
apt install openssh-server

# Enable ssh in-case it wasn't
sudo systemctl enable ssh

# Disable SSH password login
cat /etc/ssh/sshd_config | sed 's/^.*PasswordAuthentication yes.*$//g' > /tmp/sshdconfig
echo "PasswordAuthentication no" >> /tmp/sshdconfig
mv /tmp/sshdconfig /etc/ssh/sshd_config

systemctl restart ssh