name=ecx
pyw_folder=./pywrapper

.PHONY: clean install uninstall

all: $(name) 

$(name): clean
	fpm build

clean:
	fpm clean --all

install:
	fpm install prefix=prefix

