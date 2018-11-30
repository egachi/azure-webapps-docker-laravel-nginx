#!/bin/sh

# ----------------------------------------------------------------------
# Create the .env file if it does not exist.
# ----------------------------------------------------------------------

if [[ ! -f "/var/www/.env" ]] && [[ -f "/var/www/.env.example" ]];
then
cp /var/www/.env.example /var/www/.env
fi

# ----------------------------------------------------------------------
# Run Composer
# ----------------------------------------------------------------------

if [[ ! -d "/var/www/vendor" ]];
then
cd /var/www
composer update
composer dump-autoload -o
fi

cd /var/www/
chmod -R 777 storage

# ----------------------------------------------------------------------
# Start SSH
# ----------------------------------------------------------------------
echo "Starting SSH..."

# Ensure this happens after /sbin/init
( sleep 5 ; /etc/init.d/sshd restart ) &
# Needs to start as PID 1 for openrc on alpine

exec -c /sbin/init &

( sleep 5 ; echo "Starting supervisord..."; /usr/bin/supervisord -c /etc/supervisord.conf -n)
