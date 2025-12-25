###############
Getting Started
###############

    
Introduction
============

`ecx` a Fortran library for providing a collection of routines for electrochemistry.
A C API allows usage from C, or can be used as a basis for other wrappers. 
A Python wrapper allows easy usage from Python.

To use `ecx` within your `fpm <https://github.com/fortran-lang/fpm>`_
project, add the following lines to your file:

::

           [dependencies]
           ecx = { git="https://github.com/MilanSkocic/ecx.git" }

Dependencies
============

::

           gcc>=10
           gfortran>=10
           fpm>=0.7
           stdlib>=0.7

Installation
============

A Makefile is provided, which uses
`fpm <https://fpm.fortran-lang.org>`__, for building the library.

-  On windows, `msys2 <https://www.msys2.org>`__ needs to be installed.
   Add the msys2 binary (usually C:\\msys64\\usr\\bin) to the path in
   order to be able to use make.

-  On Darwin, the `gcc <https://formulae.brew.sh/formula/gcc>`__
   toolchain needs to be installed.

::

           chmod +x configure.sh
           ./configure.sh
           make
           make test
           make install
           make uninstall

You need a compiler that can compile the
`stdlib <https://github.com/fortran-lang/stdlib>`__.

License
=======

MIT
