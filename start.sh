#!/bin/bash
echo "root:$SSH_PASSWORD" | chpasswd
/usr/sbin/sshd -D

