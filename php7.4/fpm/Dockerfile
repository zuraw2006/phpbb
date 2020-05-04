FROM php:7.4-fpm

RUN set -eux; \
	apt-get update && apt-get install -y --no-install-recommends \
	ghostscript \
	&& rm -rf /var/lib/apt/lists/*

# Install the PHP extensions
RUN set -ex; \
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update && apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg-dev \
		libmagickwand-dev \
		libpng-dev \
		libzip-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j "$(nproc)" \
		gd \
		bcmath \
		exif \
		mysqli \
		opcache \
		zip \
	; \
	pecl install imagick-3.4.4 \
	&& docker-php-ext-enable imagick; \
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# Set PHP.ini settings
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

VOLUME /var/www/html

ENV PHPBB_SHA256 a6234ac9dcf9086c025ece29a0a235f997a92bb9a994eff0ddcf8917e841262f

RUN set -ex; \
	curl -o phpbb.tar.bz2 -fSL "https://download.phpbb.com/pub/release/3.3/3.3.0/phpBB-3.3.0.tar.bz2"; \
	echo "$PHPBB_SHA256 *phpbb.tar.bz2" | sha256sum -c -; \
	tar -xjf phpbb.tar.bz2 -C /usr/src/ \
	&& rm phpbb.tar.bz2 \
	&& chown -R www-data:www-data /usr/src/phpBB3

COPY ./docker-entrypoint.sh /usr/local/bin/

RUN chmod a+x /usr/local/bin/docker-entrypoint.sh \
  && ln -s /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]