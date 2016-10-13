#!/bin/bash
if [ ! -f /app/.is_initialized ]; then
    echo "Initialize app directory..."
#    cp -rf /django_start /app
    touch /app/.is_initialized
fi

if [ "${AUTHORIZED_KEYS}" != "**None**" ]; then
    echo "=> Found authorized keys"
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
    touch /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    IFS=$'\n'
    arr=$(echo ${AUTHORIZED_KEYS} | tr "," "\n")
    for x in $arr
    do
        x=$(echo $x |sed -e 's/^ *//' -e 's/ *$//')
        cat /root/.ssh/authorized_keys | grep "$x" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "=> Adding public key to /root/.ssh/authorized_keys: $x"
            echo "$x" >> /root/.ssh/authorized_keys
        fi
    done
fi

if [ ! -f /.root_pw_set ]; then
  /set_root_pw.sh
fi

exec supervisord -n

# /usr/sbin/sshd -D &

# Run demo
# django-admin.py startproject django_start
# echo "===> start listening 80 port"
# exec python ./django_start/manage.py runserver 0.0.0.0:80
