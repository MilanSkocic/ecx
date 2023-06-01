ifneq ($(prefix), )
	install_dir=$(prefix)
else
	install_dir=$(DEFAULT_INSTALL_DIR)
endif

.PHONY: clean install uninstall

all: $(LIBNAME) 

$(LIBNAME): build
	cp $(shell find ./build -type f -name "lib$(LIBNAME)*.a") $(PYW_MOD_DIR)/

build: clean
	fpm build

clean:
	fpm clean --all

install:
	fpm install --prefix=$(install_dir)
	cp -f ./include/*.h $(install_dir)/include

uninstall:
	rm -f $(install_dir)/include/ecx*.h
	rm -f $(install_dir)/include/ecx*.mod
	rm -f $(install_dir)/lib/lib$(LIBNAME).a
	rm -f $(install_dir)/include/codata.mod
