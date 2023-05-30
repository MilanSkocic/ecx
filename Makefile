name=ecx
pyw_folder=./pywrapper

.PHONY: clean install uninstall

all: $(name) py$(name) 

$(name): clean
	fpm build --profile=release

py$(name): $(name)
	$(MAKE) -C $(pyw_folder)

clean:
	fpm clean --all
	$(MAKE) -C $(pyw_folder) clean

install:
	fpm install prefix=prefix

