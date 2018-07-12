FROM alpine:3.7

# install packages
RUN apk add --no-cache curl ca-certificates \
&& curl https://repos.php.earth/alpine/phpearth.rsa.pub >> /etc/apk/keys/phpearth.rsa.pub \
&& echo "https://repos.php.earth/alpine/v3.7" >> /etc/apk/repositories \
&& apk add --no-cache openssl php7.2-common php7.2-curl php7.2-ctype php7.2-sockets php7.2-session \
php7.2-phar php7.2-mbstring php7.2-pcntl php7.2-json php7.2-opcache php7.2-pdo php7.2-pdo_mysql \
php7.2-fpm php7.2-tokenizer php7.2 php7.2-openssl php7-intl nginx runit && rm -rf /var/cache/apk/*

# Install Composer
RUN curl https://getcomposer.org/composer.phar > /usr/sbin/composer

# Copy configs
COPY container/php.ini /etc/php/7.2/php.ini
COPY container/nginx.conf /etc/nginx/nginx.conf
COPY container/fpm.conf /etc/php/7.2/php-fpm.conf

# set up runit
COPY container/runsvinit /sbin/runsvinit
RUN mkdir /tmp/nginx && mkdir -p /etc/service/nginx && echo '#!/bin/sh' >> /etc/service/nginx/run && \
echo 'nginx' >> /etc/service/nginx/run && chmod +x /etc/service/nginx/run && \
mkdir -p /etc/service/fpm && echo '#!/bin/sh' >> /etc/service/fpm/run && \
echo 'php-fpm -FR' >> /etc/service/fpm/run && chmod +x /etc/service/fpm/run && \
chmod +x /sbin/runsvinit
ENTRYPOINT ["/sbin/runsvinit"]
EXPOSE 80

# set up app; order of operations optimized for maximum layer reuse
RUN mkdir /var/app
RUN mkdir /var/app/public
COPY container/index.php /var/app/public/index.php
