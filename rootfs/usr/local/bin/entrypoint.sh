#!/bin/bash
set -eux

if [ ! -e /usr/share/nginx/html/index.php ];  then
	echo "[FileRun fresh install]"
	unzip /filerun.zip -d /usr/share/nginx/html
	cp /autoconfig.php /usr/share/nginx/html/system/data/
	chown -R www-data:www-data /usr/share/nginx/html
	mkdir -p /user-files/superuser
	chown -R www-data:www-data /user-files
	exec su-exec /usr/local/bin/wait-for-it.sh mariadb:3306 -t 120 -- /db/import-db.sh

fi

exec "$@"
