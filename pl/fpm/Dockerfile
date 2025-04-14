FROM alpine:3.21 AS unziper

ENV PHPBB_PL_VER=3_3_15
ENV PHPBB_PL_MD5=bf693cf69e8e29f1e99723a662e10199

WORKDIR /src

RUN set -eux; \
	apk add --no-cache curl

RUN set -ex; \
	curl -o polish_${PHPBB_PL_VER}.zip -fSL "https://www.phpbb.com/customise/db/download/210139"; \
	echo "$PHPBB_PL_MD5 *polish_${PHPBB_PL_VER}.zip" | md5sum -c -; \
	unzip polish_${PHPBB_PL_VER}.zip \
	&& mv polish_polish_${PHPBB_PL_VER} polish \
	&& rm polish_${PHPBB_PL_VER}.zip

FROM zuraw2006/phpbb:3.3.15-php8.4.6-fpm

COPY --from=unziper --chown=www-data:www-data /src/polish/ /usr/src/phpBB3/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]