# Use the official PHP image as a base image
FROM php:8.1-fpm

# Install required PHP extensions and other dependencies
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libxml2-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev \
    libvpx-dev \
    libzip-dev \
    unzip \
    git \
    nano \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) intl gd xml zip mysqli pdo pdo_mysql opcache \
    && pecl install apcu \
    && docker-php-ext-enable apcu

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Download and extract OJS
RUN curl -LO https://pkp.sfu.ca/ojs/download/ojs-3.4.0-5.tar.gz \
    && tar -xzf ojs-3.4.0-5.tar.gz --strip-components=1 \
    && rm ojs-3.4.0-5.tar.gz

# Copy custom configuration and other files if necessary
# COPY config.inc.php /var/www/html/config.inc.php

# Set file permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html 


#Creare directory for the file uploads and change permission
RUN mkdir -p /var/www/files \
    && chown -R www-data:www-data /var/www/files \
    && chmod -R 775 /var/www/files

# Expose the port OJS will run on
EXPOSE 9000

# Run PHP-FPM server
CMD ["php-fpm"]
