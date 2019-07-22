FROM php:7.3-fpm

# Update the package repo
# and install required PHP extensions
RUN apt-get update \
    && apt-get install -y libbz2-dev libxslt-dev libzip-dev zip \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install calendar \
    && docker-php-ext-install exif \
    && docker-php-ext-install gettext \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install sockets \
    && docker-php-ext-install xsl \
    && docker-php-ext-install zip

# Install composer
# and make it globally accessible
RUN curl --silent --show-error https://getcomposer.org/installer \
        | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod 755 /usr/local/bin/composer

# Add composer package binaries to the PATH
# so you can run things like lumen directly on the command line
ENV PATH $PATH:/root/.composer/vendor/bin
