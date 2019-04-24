FROM murara/php-base:7.2-dev

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require "laravel/installer"

COPY config/php.ini /usr/local/etc/php/php.ini

