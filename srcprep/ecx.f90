$BLOCK comment --file ecx.3.txt
NAME
    ecx - library for electrochemistry

SYNOPSIS
    use ecx

DESCRIPTION
    ecx a Fortran library for providing a collection of routines for electrochemistry.
    A C API allows usage from C, or can be used as a basis for other wrappers. 
    A Python wrapper allows easy usage from Python.

EXAMPLE
    Minimal example in Fortran:

        use ecx
    
    Minimal example in C:

        include "ecx.h"

    Minimal example in Python:

        import pyecx

SEE ALSO
    complex(7), gsl(3), catanh(3), gnuplot(1)

$ENDBLOCK
module ecx
    !! Main module for ecx.
    use ecx__api
    use ecx__capi
end module
