include ../make.in

all: man/ecxcli.1 man/ecxcli.1.pdf
	make -C sphinx html

.PHONY:
man/ecxcli.1: man/ecxcli.1.txt 
	txt2man -s 1 -v "User commands" -r $(FPM_VERSION) -t $(shell basename $@ | cut -d '.' -f 1) $< > $@

.PHONY:
man/ecxcli.1.pdf: man/ecxcli.1
	man -l -Tpdf $< > $@

.PHONY:
clean:
	make -C sphinx clean
