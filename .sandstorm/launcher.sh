#!/bin/bash
set -euo pipefail
# This script is run every time an instance of our app - aka grain - starts up.
# This is the entry point for your application both when a grain is first launched
# and when a grain resumes after being previously shut down.
#
# This script is responsible for launching everything your app needs to run.  The
# thing it should do *last* is:
#
#   * Start a process in the foreground listening on port 8000 for HTTP requests.
#
# This is how you indicate to the platform that your application is up and
# ready to receive requests.  Often, this will be something like nginx serving
# static files and reverse proxying for some other dynamic backend service.
#
# Other things you probably want to do in this script include:
#
#   * Building folder structures in /var.  /var is the only non-tmpfs folder
#     mounted read-write in the sandbox, and when a grain is first launched, it
#     will start out empty.  It will persist between runs of the same grain, but
#     be unique per app instance.  That is, two instances of the same app have
#     separate instances of /var.
#   * Preparing a database and running migrations.  As your package changes
#     over time and you release updates, you will need to deal with migrating
#     data from previous schema versions to new ones, since users should not have
#     to think about such things.
#   * Launching other daemons your app needs (e.g. mysqld, redis-server, etc.)

# By default, this script does nothing.  You'll have to modify it as
# appropriate for your application.
cd /opt/app

if [ ! -d "/var/nodebb" ]
then
	echo "First time running. Preparing the working directory."
	
	mkdir -p /var/nodebb
	find `pwd` -mindepth 1 -maxdepth 1 \
		! -type l \
		! -name '*_copyme' \
		! -name .git \
		! -name .sandstorm \
		-exec ln -s {} /var/nodebb/ \;
	cp -R public_copyme      /var/nodebb/public
	cp    config.json_copyme /var/nodebb/config.json
	touch /var/nodebb/output.log
	cd /var/nodebb
	redis-server &
	until redis-cli config set save "10 1"
	do
		echo "Waiting for Redis to start..."
		sleep 0.5s
	done
	nodejs app.js --setup="{\"url\":\"http://127.0.0.1:8000/\",\"secret\":\"abcdef\",\"database\":\"redis\",\"mongo:host\":\"127.0.0.1\",\"mongo:port\":27017,\"mongo:username\":\"\",\"mongo:password\":\"\",\"mongo:database\":0,\"redis:host\":\"127.0.0.1\",\"redis:port\":6379,\"redis:password\":\"\",\"redis:database\":0,\"admin:username\":\"admin\",\"admin:email\":\"test@example.org\",\"admin:password\":\"abcdef\",\"admin:password:confirm\":\"abcdef\"}" 
else
	echo "Re-launching."
	cd /var/nodebb
	redis-server &
fi

nodejs app.js

exit 0
