DESTDIR=
INSTALL_DIR=$(DESTDIR)/usr
BUILD_DIR=./build
NAME=indi-backup
LIB_DIR=./lib

all:
	mkdir -p $(BUILD_DIR)
	sed -s 's/@@VERSION@@/$(shell git describe --tags --long)/' $(NAME) > $(BUILD_DIR)/$(NAME)

install: all
	mkdir -p $(INSTALL_DIR)/bin
	mkdir -p $(INSTALL_DIR)/lib/$(NAME)
	cp $(BUILD_DIR)/$(NAME) $(INSTALL_DIR)/bin
	chmod 755 $(INSTALL_DIR)/$(NAME)

	cp -r $(LIB_DIR) $(INSTALL_DIR)/lib/$(NAME)

uninstall:
	rm -rf $(INSTALL_DIR)/bin/$(NAME)
	rm -rf $(INSTALL_DIR)/lib/$(NAME)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all install uninstall clean
