#!/bin/bash -x

envtpl --keep-template /etc/one/oned.conf.tpl
if [[ ! -f /var/lib/one/.copied  ]]
then
    echo '/var/lib/one not initialized. copying orig'
    cp -av /var/lib/one.orig/* /var/lib/one.orig/.??* /var/lib/one/
    touch /var/lib/one/.copied
fi

echo ${ONE_USER}:${ONE_PASSWORD} > ~/.one/one_auth
cat ~/.one/one_auth


if [[ -f ~/.ssh/id_ed25519 && -f ~/.ssh/id_ed25519.pub ]]
then
    echo already got key
    cat ~/.ssh/id_ed25519.pub
else
    echo no key - generating
    ls -al ~/.ssh
    ssh-keygen -t ed25519 -C oneadmin -N "" -f ~/.ssh/id_ed25519
    cat ~/.ssh/id_ed25519.pub
fi

one start
sunstone-server start
fireedge-server start
oneuser show

exec tail -F /var/log/one/*.{log,error}
