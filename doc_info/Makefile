include ../make.in

TITLE=$(FPM_NAME)
AUTHOR=$(FPM_AUTHOR)
LIBNAME=$(FPM_LIBNAME)

all: info pdf html

info:
	makeinfo main.texi

pdf:
	makeinfo --pdf main.texi

html:
	makeinfo --html main.texi

clean:
	rm -f main.aux main.cp main.cps main.info main.log main.pdf main.toc main.dvi main.out main.synctex* *.idx *.ilg *.ind
	rm -rf main_html/*
