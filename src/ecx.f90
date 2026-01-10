! NAME
!     ecx - library for electrochemistry
! 
! SYNOPSIS
!     use ecx
! 
! DESCRIPTION
!     ecx a Fortran library for providing a collection of routines for electrochemistry.
!     A C API allows usage from C, or can be used as a basis for other wrappers.
!     A Python wrapper allows easy usage from Python.
! 
!     It covers:
! 
!       o kinetics  Nernst, Butler-Volmer
!       o electrochemical  Impedance, Admittance, Circuit Elements, Equivalent Circuits
!       o photoelectrochemistry  Photocurrent, Band-gap, space charge.
! 
!     The C API is defined by adding a prefix to the functions from the Fortran
!     API due to the lack of module/namespace feature in the C language.
!     The functions are therefore following this template:
!     (c_prefix)fortran_func.
! 
!         o (ecx_)get_version
!         o (ecx_core_)kTe
!         o (ecx_eis_)z
!         o mm
!         o (ecx_kinetics_)nernst
!         o (ecx_kinetics_)sbv
!         o (ecx_kinetics_)bv
!         o (ecx_eis_)z
! 
! 
! EXAMPLE
!     Minimal example in Fortran:
! 
!         use ecx
! 
!     Minimal example in C:
! 
!         include "ecx.h"
! 
!     Minimal example in Python:
! 
!         import pyecx
! 
! SEE ALSO
!     complex(7), gsl(3), catanh(3), gnuplot(1)
!
module ecx
    !! Main module for ecx.
    use ecx__api
    use ecx__capi
end module
