name=ecx
pyw_folder=./pywrapper
pyecx_dir=./pywrapper/pyecx

ifneq ($(prefix), )
	install_dir=$(prefix)
else
	install_dir=$(DEFAULT_INSTALL_DIR)
endif

.PHONY: clean install uninstall

all: $(name) 

$(name): build
	cp $(shell find ./build -type f -name "lib$(name)*.a") $(pyecx_dir)/

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
	rm -f $(install_dir)/lib/lib$(name).a
	rm -f $(install_dir)/include/codata.mod
