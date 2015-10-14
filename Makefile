all: public_copyme node_modules

public_copyme:
	mv public public_copyme;\
	ln -s /var/nodebb/public public

node_modules:
	npm install --production
	npm install redis connect-redis

