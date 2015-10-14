all: public_copyme

public_copyme:
	mv public public_copyme;\
	ln -s /var/nodebb/public public
