#!/usr/bin/env sh

adduser --disabled-password --gecos "" $USER
usermod -aLG sudo $USER

# Allow no password for sudo
cat <<EOF > "/etc/sudoers.d/$USER"
# Members of the admin group may gain root privileges
%$USER  ALL=(ALL) NOPASSWD:ALL
EOF


mkdir /home/$USER/.ssh