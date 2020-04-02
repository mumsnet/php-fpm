FROM php:7.3-fpm

# Update the package repo
# and install required PHP extensions
RUN apt-get update \
    && apt-get install -y libbz2-dev libxslt-dev libzip-dev nginx supervisor zip \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install calendar \
    && docker-php-ext-install exif \
    && docker-php-ext-install gettext \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install opcache \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install sockets \
    && docker-php-ext-install xsl \
    && docker-php-ext-install zip

# Configure opcache
COPY opcache.ini $PHP_INI_DIR/conf.d/

# Configure nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY configure_nginx_for_assets.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/configure_nginx_for_assets.sh

# Configure FPM
RUN sed -i 's%;ping\.path.*$%ping.path = /fpm-ping%' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's%;status\.path.*$%status.path = /fpm-status%' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's%^access.log%;access.log%' /usr/local/etc/php-fpm.d/docker.conf

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Ensure the html folder is owned by www-data
RUN mkdir -p /var/www/html/public
RUN chown -R www-data:www-data /var/www/html

# Install composer
# and make it globally accessible
RUN curl --silent --show-error https://getcomposer.org/installer \
        | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod 755 /usr/local/bin/composer

# Add composer package binaries to the PATH
# so you can run things like lumen directly on the command line
ENV PATH $PATH:/root/.composer/vendor/bin

EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

# Configure a healthcheck to validate that everything is up & running
HEALTHCHECK --timeout=10s CMD curl --silent --output /dev/null --fail http://127.0.0.1:8080/fpm-ping
