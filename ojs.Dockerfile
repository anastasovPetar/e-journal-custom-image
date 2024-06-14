# Use an official PHP runtime as a parent image
FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html


# Add the necessary keys and update package list
RUN apt-get update 
RUN apt-get upgrade -y

# Install dependencies
RUN apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    zlib1g-dev \
    libzip-dev \
    libicu-dev \
    g++ \
    libxml2-dev \
    unzip \
    nano \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd intl mysqli opcache zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy OJS source code
#COPY . /var/www/html

# Set working directory than download
WORKDIR /var/www/html

#download ojs and extract
RUN curl -LO https://pkp.sfu.ca/ojs/download/ojs-3.4.0-5.tar.gz && \
    tar -xzf ojs-3.4.0-5.tar.gz --strip-components=1 && \
    rm ojs-3.4.0-5.tar.gz

#make the files folder-for upload
RUN mkdir -p /var/www/files

# Set permissions
# RUN chown -R www-data:www-data /var/www/html && \
#     chmod -R 755 /var/www/html

# RUN chown -R www-data:www-data /var/www/html/public && \
#     chmod -R 755 /var/www/html/public

# RUN chown -R www-data:www-data /var/www/files && \
#     chmod -R 775 /var/www/files


# Expose port 80
EXPOSE 80

# Run Apache
CMD ["apache2-foreground"]
