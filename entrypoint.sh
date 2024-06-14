#!/bin/bash

# Set permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

chown -R www-data:www-data /var/www/html/public
chmod -R 755 /var/www/html/public

chown -R www-data:www-data /var/www/files 
chmod -R 775 /var/www/file

# Execute the provided command
exec "$@"