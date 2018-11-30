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
exec /usr/sbin/sshd &
(echo "Starting supervisord..."; /usr/bin/supervisord -c /etc/supervisord.conf -n)
