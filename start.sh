#!/bin/bash -x

ssh-keygen -A
/usr/sbin/sshd -E /var/log/one/sshd.log

su oneadmin /start-as-oneadmin.sh
tail -F /var/log/one/*.{log,errror}
