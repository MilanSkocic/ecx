<h1 align="center">
<img src="./media/logo.png" width="300">
</h1><br>


`ecx` a Fortran library for provinding a collection of routines for electrochemistry. A C API

- **Documentation:** https://milanskocic.github.io/ecx/
- **Source code:** https://github.com/MilanSKocic/ecx
- **Python wrapper:** https://pypi.org/project/pyecx

It covers:

- kinetics
- electrochemical impedance
- photoelectrochemistry

To use within your [fpm](https://github.com/fortran-lang/fpm) project,
add the following to your file:

```

[dependencies]
ecx = { git="https://github.com/MilanSkocic/ecx.git" }
```
