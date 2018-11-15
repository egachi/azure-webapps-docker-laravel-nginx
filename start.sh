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

#Quick fick for this issue file_put_contents(/var/www/app/storage/meta/services.json): failed to open stream: Permission denied
echo "Running composer update"
composer update
echo "Running php artisan cache:clear "
php artisan cache:clear 
echo "Running chmod -R 777 storage/ " 

chmod -R 777 /var/www/app/storage/
echo "Running composer dump-autoload -o "
composer dump-autoload -o
echo "Running php artisan key:generate"
php artisan key:generate
echo "Running php artisan optimize"
php artisan optimize

fi

# ----------------------------------------------------------------------
# Start supervisord
# ----------------------------------------------------------------------

exec /usr/bin/supervisord -n -c /etc/supervisord.conf