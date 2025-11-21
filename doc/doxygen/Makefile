

all: html pdf

.PHONY: html
html:
	doxygen Doxyfile

.PHONY: pdf
pdf: 
	make -C build/latex

clean:
	rm -rf build/*

