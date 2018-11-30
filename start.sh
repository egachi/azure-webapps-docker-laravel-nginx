#!/usr/bin/env bash
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
# Start supervisord
# ----------------------------------------------------------------------

exec /usr/bin/supervisord -n -c /etc/supervisord.conf

# ----------------------------------------------------------------------
# Start SSH
# ----------------------------------------------------------------------

# Ensure this happens after /sbin/init
( sleep 5 ; /etc/init.d/sshd restart ) &
# Needs to start as PID 1 for openrc on alpine

exec -c /sbin/init 
#exec /usr/sbin/sshd -D -e "${@}"

