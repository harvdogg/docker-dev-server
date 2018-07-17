FROM alpine:3.8

# install packages
RUN apk add --no-cache curl ca-certificates php7-intl nginx runit openssl git \
        php php-common php-curl php-ctype php-sockets php-session \
        php-dom php-xml php-phar php-mbstring php-pcntl php-json \
        php-opcache php-pdo php-pdo_mysql php-fpm php-tokenizer php-openssl \
        php-simplexml php-xmlwriter

# Install Composer
RUN curl https://getcomposer.org/composer.phar > /usr/sbin/composer \
    && chmod a+x /usr/sbin/composer

# Copy configs
COPY container/php.ini /etc/php7/php.ini
COPY container/nginx.conf /etc/nginx/nginx.conf
COPY container/fpm.conf /etc/php7/php-fpm.d//www.conf

# set up runit
COPY container/runsvinit /sbin/runsvinit
RUN mkdir /tmp/nginx \
    && mkdir -p /etc/service/nginx \
    && echo '#!/bin/sh' >> /etc/service/nginx/run \
    && echo 'nginx' >> /etc/service/nginx/run \
    && chmod +x /etc/service/nginx/run \
    && mkdir -p /etc/service/fpm \
    && echo '#!/bin/sh' >> /etc/service/fpm/run \
    && echo 'php-fpm7 -FR' >> /etc/service/fpm/run \
    && chmod +x /etc/service/fpm/run \
    && chmod +x /sbin/runsvinit

ENTRYPOINT ["/sbin/runsvinit"]
EXPOSE 80

WORKDIR /var/app

# set up app; order of operations optimized for maximum layer reuse
RUN mkdir -p /var/app/public
COPY container/index.php /var/app/public/index.php
