FROM php:8.2-fpm-alpine

RUN apk add openssl curl ca-certificates
RUN apk add nginx
RUN apk add libpq-dev
RUN apk add bash

# Nginx & PHP configs
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/http.d/default.conf /etc/nginx/http.d/default.conf
#COPY ./docker/php/extensions/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Install PHP extensions https://github.com/mlocati/docker-php-extension-installer#supported-php-extensions
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_pgsql
#RUN docker-php-ext-install opcache

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy source code & set permissions
COPY ./ /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# Add entrypoint
ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]