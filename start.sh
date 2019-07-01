#!/bin/bash
mkdir -p /${HOME}/.ssh
echo "root:$SSH_PASSWORD" | chpasswd
echo "${DEVELOPER_PUBLIC_KEY}" >> /${HOME}/.ssh/authorized_keys
/usr/sbin/sshd -D

