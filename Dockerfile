FROM php:7.4-fpm

LABEL MAINTAINER="alex.nogara@gmail.com"

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ADD config/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
ADD config/.gitconfig /home/developer/.gitconfig

RUN apt-get update && apt-get install -y curl wget git vim libzip-dev zip unzip libyaml-dev libicu-dev \
    libc-client-dev libkrb5-dev libpng-dev libxml2-dev libmemcached-dev && \
    docker-php-ext-configure gd && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install mysqli pdo pdo_mysql zip opcache gettext intl json imap gd xml && \
    pecl install xdebug apcu yaml redis memcached && \
    docker-php-ext-enable xdebug apcu yaml redis memcached && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/* && \
    adduser developer && \
    chown -R developer: /home/developer/ && \
    wget https://get.symfony.com/cli/installer -O - | bash && \
    mv /root/.symfony/bin/symfony /usr/local/bin/symfony

EXPOSE 9000

WORKDIR /var/www