FROM php:5.6-apache

RUN set -ex; \
	\
	apt-get update; \
	apt-get install -y \
		libjpeg-dev \
		libpng12-dev \
		libxml2-dev \
		libpq-dev \
	; \
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install pdo pdo_mysql mbstring tokenizer xml gd mysql mysqli opcache pgsql pdo_pgsql; \
	apt-get remove -y \
		libjpeg-dev \
		libpng12-dev \
		libxml2-dev \
		libpq-dev \
	; \
	apt-get autoremove -y; \
	rm -rf /var/lib/apt/lists/*; \
	apt-get clean; \
	a2enmod actions rewrite authz_groupfile

COPY config/www.conf /etc/apache2/conf-enabled/www.conf
COPY config/php.ini /usr/local/etc/php/conf.d/docker-php.ini
COPY docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["sh","/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
