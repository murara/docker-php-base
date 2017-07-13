FROM php:7.1-fpm

RUN set -ex; \
	\
	apt-get update; \
	apt-get install -y \
		git \
		libjpeg-dev \
		libpng12-dev \
		libxml2-dev \
        	libmemcached11 \
        	libmemcachedutil2 \
        	libmemcached-dev \
		libz-dev \
	; \
	cd /root; \
	git clone -b php7 https://github.com/php-memcached-dev/php-memcached; \
	cd php-memcached; \
        phpize; \
        ./configure; \
        make; \
        make install; \
        cd ..; \
        rm -rf  php-memcached; \
        echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini; \
        apt-get remove -y build-essential libmemcached-dev libz-dev; \
	apt-get remove -y \
		git \
        	libmemcached-dev \
        	libz-dev; \
	apt-get autoremove -y; \
	rm -rf /var/lib/apt/lists/*; \
	apt-get clean; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install pdo pdo_mysql mbstring tokenizer xml gd mysqli opcache

COPY config/php.ini /usr/local/etc/php/php.ini
COPY docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /usr/local/apache2/htdocs

ENTRYPOINT ["sh","/docker-entrypoint.sh"]
CMD ["php-fpm"]
