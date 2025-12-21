# NAME
#     pyecx - Python wrapper for the electrochemistry Library.
# 
# SYNOPSIS
#     import pyecx
# 
# DESCRIPTION
#     The ecx library is a collection of routines for electrochemistry.
#     A C API allows usage from C, or can be used as a basis for other wrappers.
#     A Python wrapper allows easy usage from Python.
# 
#     The library covers the following areas:
#     o kinetics        Nernst, Tafel
#     o impedance       EIS, DIA
#     o photocurrent    Iph
# 
#     Defined constants:
#     o PI       Pi number.
#     o T_K      Kelvin conversion value.
# 
# EXAMPLE
#     Minimal program:
# 
#         import pyecx
#         print *, pyecx.__version__
# 
# REPORTING BUGS
# 
#     Please report any bugs at http://github.com/ecx/issues
# 
# SEE ALSO
#     python(1), complex(7), ecx(3)
"""Python wrapper of the (Modern Fortran) ecx library."""
from .version import __version__
from . import eis
from . import core
