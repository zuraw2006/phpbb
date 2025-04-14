#!/bin/bash
set -euo pipefail

user='www-data'
group='www-data'

if [ ! -e index.php ]; then
	if [ "$(id -u)" = '0' ] && [ "$(stat -c '%u:%g' .)" = '0:0' ]; then
		chown "$user:$group" .
	fi

	echo >&2 "phpBB not found in $PWD - copying now..."

	if [ -n "$(ls -A)" ]; then
		echo >&2 "WARNING: $PWD is not empty!"
	fi

	cp -a /usr/src/phpBB3/. /var/www/html
	echo >&2 "Complete! phpBB has been successfully copied to $PWD"

	chmod 777 /var/www/html/config.php
	echo >&2 "Complete! Set permissions to config file for install purpose"
fi

exec "$@"