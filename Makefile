all: node_modules

copy: public_copyme config.json_copyme

public_copyme:
	mv public public_copyme;\
	ln -s /var/nodebb/public public

config.json_copyme:
	mv config.json config.json_copyme;\
	ln -s /var/nodebb/config.json config.json

node_modules:
	npm install --production
	npm install redis connect-redis redisearch

