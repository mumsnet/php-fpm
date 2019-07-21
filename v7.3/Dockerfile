FROM php:7.3-fpm

# Update the package repo
# and install required PHP extensions
RUN apt-get update \
    && apt-get install -y libbz2-dev libxslt-dev \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install calendar \
    && docker-php-ext-install exif \
    && docker-php-ext-install gettext \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install sockets \
    && docker-php-ext-install xsl

# Install composer
# and make it globally accessible
RUN curl --silent --show-error https://getcomposer.org/installer \
        | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod 755 /usr/local/bin/composer
