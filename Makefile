DESTDIR=
INSTALL_DIR=$(DESTDIR)/usr
BUILD_DIR=./build
NAME=indi-backup
LIB_DIR=./lib
CONFIG_SRC=./exemples/exemple_2.conf
CONFIG_DEST=$(DESTDIR)/etc/$(NAME).conf

all:
	mkdir -p $(BUILD_DIR)
	sed -s 's/@@VERSION@@/$(shell git describe --tags --long)/' $(NAME) > $(BUILD_DIR)/$(NAME)

install: all
	mkdir -p $(INSTALL_DIR)/bin
	mkdir -p $(INSTALL_DIR)/lib/$(NAME)
	cp $(BUILD_DIR)/$(NAME) $(INSTALL_DIR)/bin
	chmod 755 $(INSTALL_DIR)/bin/$(NAME)

	cp -r $(LIB_DIR)/* $(INSTALL_DIR)/lib/$(NAME)

	( test ! -f $(CONFIG_DEST) && cp $(CONFIG_SRC) $(CONFIG_DEST) ) || cp $(CONFIG_SRC) $(CONFIG_DEST).dist

uninstall:
	rm -rf $(INSTALL_DIR)/bin/$(NAME)
	rm -rf $(INSTALL_DIR)/lib/$(NAME)
	rm -rf $(CONFIG_DEST) $(CONFIG_DEST).dist

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all install uninstall clean
