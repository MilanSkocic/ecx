include ../../make.in

MANSRC=ecx.1.man \
	   ecx_lib.3.man
MAN=$(patsubst %.man, %, $(MANSRC))
MANPDF=$(patsubst %, %.pdf, $(MAN))
MANTXT=$(patsubst %, %.txt, $(MAN))
MANGZ=$(patsubst %, %.gz, $(MAN))
MANHTML=$(patsubst %, %.html, $(MAN))

all: examples $(MAN) $(MANGZ) $(MANPDF) $(MANTXT) $(MANHTML)

examples: 
	./concatex

ecx.1: ecx.1.man
	cat $< seealso.man > tmp
	sed -E "s/@VERSION@/$(FPM_VERSION)/g;s/@DATE@/$(shell date +'%d %B %Y')/g" tmp > $@
	rm -rfv tmp

ecx_lib.3: ecx_lib.3.man
	cat $< examples.man seealso.man > tmp
	sed -E "s/@VERSION@/$(FPM_VERSION)/g;s/@DATE@/$(shell date +'%d %B %Y')/g" tmp > $@
	rm -rfv tmp

ecx_%.3: ecx_%.3.man
	cat $< seealso.man > tmp
	sed -E "s/@VERSION@/$(FPM_VERSION)/g;s/@DATE@/$(shell date +'%d %B %Y')/g" tmp > $@
	rm -rfv tmp

%.pdf: %
	man -l -Tpdf $< > $@

%.html: %
	man -l -Thtml $< > $@

%.gz: %
	gzip -fk $^ > $@

%.txt: %
	man -l $< > $@

.PHONY: clean
clean:
	rm -fv $(MAN) $(MANGZ) $(MANPDF) $(MANTXT) $(MANHTML)

