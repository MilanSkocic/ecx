# Introduction

`ecx` is a Fortran library providing formulas for electrochemistry.

To use `ecx` within your `fpm <https://github.com/fortran-lang/fpm>`_ project,
add the following to your `fpm.toml` file:

```
    [dependencies]
    ecx = { git="https://github.com/MilanSkocic/ecx.git" }
```
    

# Dependencies

```
gcc>=10
gfortran>=10
fpm>=0.7
codata==0.10.0
```

# Installation

A Makefile is provided, which uses [fpm](https://fpm.fortran-lang.org), for building the library.

* On windows, [msys2](https://www.msys2.org) needs to be installed. 
  Add the msys2 binary (usually C:\\msys64\\usr\\bin) to the path in order to be able to use make.
* On Darwin, the [gcc](https://formulae.brew.sh/formula/gcc) toolchain needs to be installed.

Build: the configuration file will set all the environment variables necessary for the compilation

```
    chmod +x configure.sh
    . ./configure.sh
    make
```

Run tests

```
    make test
```


Install

```
    make install
```

Uninstall

```
    make uninstall
```


# License

MIT
