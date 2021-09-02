Example of related pages generated from markdown. Every file placed in root directory for docs will be generated as related pages.


# section 1

The `README.md` file is written in __markdown__ but can be enhanced with html commands and/or doxygen commands usually used in for example `main.c` with `\\mainpage` command. In order to use a `README.md` file as mainpage, the doxyfile must be modified as following:

	l. 985: USE_MDFILE_AS_MAINPAGE = README.md

# section 2
Be sure that the root path of the mainpage is added first in the `INPUT`:

	l. 793: INPUT                  = ./ ../../src/ ../../include/




