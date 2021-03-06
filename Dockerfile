FROM php:7.0-fpm

RUN set -ex; \
	\
	apt-get update; \
	apt-get install -y \
		libjpeg-dev \
		libpng12-dev \
		libxml2-dev \
		libcurl4-openssl-dev \
	; \
	apt-get autoremove -y; \
	rm -rf /var/lib/apt/lists/*; \
	apt-get clean; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install pdo pdo_mysql mbstring tokenizer xml gd mysqli opcache curl

COPY config/php.ini /usr/local/etc/php/php.ini
COPY docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["sh","/docker-entrypoint.sh"]
CMD ["php-fpm"]
