#!/bin/bash -x
rm -rf /var/lock/one/one
rm -rf /etc/one/sunstone-views
ln -sf /etc/sunstone-views /etc/one/sunstone-views

ssh-keygen -A
/usr/sbin/sshd -E /var/log/one/sshd.log
chown -R oneadmin:oneadmin /var/log/one/

cp /etc/hosts ~/hosts.bck
sed -i 's/localhost ip6-localhost ip6-loopback/ip6-localhost ip6-loopback/' ~/hosts.bck
cp -f ~/hosts.bck /etc/hosts

su oneadmin /start-as-oneadmin.sh
