#!/usr/bin/env sh

adduser --disabled-password --gecos "" $USER
usermod -aLG sudo $USER

mkdir /home/$USER/.ssh