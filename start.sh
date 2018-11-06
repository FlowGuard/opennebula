#!/bin/bash -x

rm -rf /etc/one/sunstone-views
ln -sf /etc/sunstone-views /etc/one/sunstone-views

ssh-keygen -A
/usr/sbin/sshd -E /var/log/one/sshd.log

chown oneadmin:oneadmin /var/log/one /var/lib/one

su oneadmin /start-as-oneadmin.sh
tail -F /var/log/one/*.{log,errror}
