FROM php:8.2-fpm

RUN apt-get update

# Install nginx
RUN apt-get install nginx -y
COPY docker/nginx.conf /etc/nginx/sites-enabled/default

# Install PHP extensions https://github.com/mlocati/docker-php-extension-installer#supported-php-extensions
RUN apt-get install libpq-dev -y
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_pgsql

#COPY docker/new/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
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