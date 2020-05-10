FROM alpine:3.11 as unziper

ENV PHPBB_PL_VER 3_3_0
ENV PHPBB_PL_MD5 e55c35eca5ecd6cab36d99a54b7ead91

WORKDIR /src

RUN set -eux; \
	apk add --no-cache curl

RUN set -ex; \
	curl -o polish_${PHPBB_PL_VER}.zip -fSL "https://www.phpbb.com/customise/db/download/174486"; \
	echo "$PHPBB_PL_MD5 *polish_${PHPBB_PL_VER}.zip" | md5sum -c -; \
	unzip polish_${PHPBB_PL_VER}.zip \
	&& mv polish_${PHPBB_PL_VER} polish \
	&& rm polish_${PHPBB_PL_VER}.zip

FROM zuraw2006/phpbb:3.3.0-php7.4-fpm

COPY --from=unziper --chown=www-data:www-data /src/polish/ /usr/src/phpBB3/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]