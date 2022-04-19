#!/bin/bash -x
rm -rf /var/lock/one/one
rm -rf /etc/one/sunstone-views
ln -sf /etc/sunstone-views /etc/one/sunstone-views

ssh-keygen -A
/usr/sbin/sshd -E /var/log/one/sshd.log

su oneadmin /start-as-oneadmin.sh
