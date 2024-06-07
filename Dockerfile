# Use the official PHP 8.1 image as a base image
FROM php:8.1-fpm

# Install Nginx and necessary PHP extensions
RUN apt-get update && apt-get install -y \
    nginx \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mbstring mysqli pdo pdo_mysql xml opcache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Download OJS and set up the directory
RUN mkdir -p /var/www/html \
    && mkdir -p /var/www/files \
    && cd /var/www/html \
    && curl -sSL https://pkp.sfu.ca/ojs/download/ojs-3.4.0-5.tar.gz | tar -xz --strip-components=1

# Configure Nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY ojs.conf /etc/nginx/sites-available/default

# Set up permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80 for Nginx
EXPOSE 80

# Start PHP-FPM and Nginx
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
