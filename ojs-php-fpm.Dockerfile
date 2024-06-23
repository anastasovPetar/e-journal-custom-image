# Use the PHP 8.1 FPM Alpine base image
FROM php:8.1-fpm-alpine

# Install dependencies for Composer
RUN apk add --no-cache \
    curl \
    git \
    unzip \
    nano

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create the /var/www/html/ojfiless directory 
RUN mkdir -p /var/www/html/files

# Create the /var/www/html/ojs directory if it doesn't exist
RUN mkdir -p /var/www/html/ojs

# Copy the .tar.gz file to the container
COPY ojs-3.4.0-5.tar.gz /tmp/ojs.tar.gz

# Extract the .tar.gz file into /var/www/html/ojs
RUN tar -xzf /tmp/ojs.tar.gz -C /var/www/html/ojs && rm /tmp/ojs.tar.gz

# Set the working directory
WORKDIR /var/www/html/ojs

# Set the appropriate permissions
RUN chown -R www-data:www-data /var/www/html/ojs

# Expose port 9000 and start PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]

