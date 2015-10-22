all: node_modules public_copyme config.json_copyme

public_copyme:
	mv public public_copyme;\
	ln -s /var/nodebb/public public

config.json_copyme:
	mv config.json config.json_copyme;\
	ln -s /var/nodebb/config.json config.json

node_modules:
	npm install --production;\
	npm install redis connect-redis redisearch

restore: restore_public restore_config

restore_public:
	if [ -d "public_copyme" ] ;\
	then\
		rm -f public && mv public_copyme public ;\
	fi

restore_config:
	if [ -e "config.json_copyme" ] ;\
	then\
		rm -f config.json && mv config.json_copyme config.json ;\
	fi

