! NAME
!     ecx - library for electrochemistry
! 
! LIBRARY
!     ecx (-libecx, -lecx)
! 
! SYNOPSIS
!     ecx (Fortran): use ecx
!     ecx (C): include "ecx.h"
!     ecx (python): import pyecx
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
!     Fortran API
!         o function get_version() -> fptr     Get the version.
!         o pure elemental function kTe(T) -> r     Compute the thermal voltage.
!             o real(dp), intent(in)::T     Temperature in °C.
!         o subroutine z(p, w, zout, e, errstat, errmsg)     Compute the complex impedance.
!             o real(dp), intent(in), dimension(:)::p     Parameters defining the element e
!             o real(dp), intent(in), dimension(:)::w     Angular frequencies in rad.s-1
!             o complex(dp), intent(out), dimension(:)::zout     Complex impedance in Ohms.
!             o character(len=1), intent(in)::e     Electrochemical element: R, C, L, Q, O, T, G
!             o integer(int32), intent(out)::errstat     Error status
!             o character(len=:), intent(out), pointer::errmsg     Error message
!         o subroutine mm(p, w, zout, n)    ---
!             o real(dp), intent(in), dimension(:)::p     Compute the measurement model.
!             o real(dp), intent(in), dimension(:)::w     Parameters.
!             o complex(dp), intent(out), dimension(:)::zout     Angular frequencies in rad.s-1
!             o integer(int32), intent(in)::n     Complex impedance in Ohms.
!         o pure function nernst(E0, z, aox, vox, ared, vred, T) -> E     Compute the Nernst electrochemical potential in V.
!             o real(dp), intent(in)::E0    ---
!             o integer(int32), intent(in)::z     Standard electrochemical potential in V.
!             o real(dp), intent(in), dimension(:)::aox     Number of exchanged electrons.
!             o real(dp), intent(in), dimension(:)::vox     Activities of the oxidants.
!             o real(dp), intent(in), dimension(:)::ared     Coefficients for the oxidants.
!             o real(dp), intent(in), dimension(:)::vred     Activities of the reductants
!             o real(dp), intent(in)::T     Coefficients for the reductants.
!         o pure elemental function sbv(U, OCV, j0, aa, ac, za, zc, A, T) -> I    ---
!             o real(dp), intent(in)::U     Open Circuit Voltage in V.
!             o real(dp), intent(in)::OCV     Compute Butler Volmer equation without mass transport.
!             o real(dp), intent(in)::j0     Electrochemical potential in V.
!             o real(dp), intent(in)::aa     Exchange current density in A.cm-2.
!             o real(dp), intent(in)::ac     Anodic transfer coefficient.
!             o real(dp), intent(in)::za     Cathodic transfer coefficient.
!             o real(dp), intent(in)::zc     Number of exchnaged electrons in the anodic branch.
!             o real(dp), intent(in)::A     Number of exchnaged electrons in the cathodic branch.
!             o real(dp), intent(in)::T     Area in cm2.
!         o pure elemental function bv(U, OCV, j0, jdla, jdlc, aa, ac, za, zc, A, T) -> I     Compute Butler Volmer equation with mass transport.
!             o real(dp), intent(in)::U     Open Circuit Voltage in V.
!             o real(dp), intent(in)::OCV    ---
!             o real(dp), intent(in)::j0     Electrochemical potential in V.
!             o real(dp), intent(in)::jdla     Exchange current density in A.cm-2.
!             o real(dp), intent(in)::jdlc     Anodic diffusion limiting current density in A.cm-2.
!             o real(dp), intent(in)::aa     Cathodic diffusion limiting current density in A.cm-2.
!             o real(dp), intent(in)::ac     Anodic transfer coefficient.
!             o real(dp), intent(in)::za     Cathodic transfer coefficient.
!             o real(dp), intent(in)::zc     Number of exchnaged electrons in the anodic branch.
!             o real(dp), intent(in)::A     Number of exchnaged electrons in the cathodic branch.
!             o real(dp), intent(in)::T     Area in cm2.
! 
! NOTES
!     To use ecx within your fpm <https://github.com/fortran-lang/fpm>
!     project, add the following lines to your file:
! 
!         [dependencies]
!         ecx = { git="https://github.com/MilanSkocic/ecx.git" }
! 
! EXAMPLE
!     Example in Fortran:
! 
!         program example_in_f
!             use iso_fortran_env
!             use ecx
!             implicit none
! 
!             real(real64) :: w(3) = [1.0d0, 1.0d0, 100.0d0]
!             real(real64) :: r = 100.0d0
!             real(real64) :: p(3) = 0.0d0
!             character(len=1) :: e
!             integer :: errstat
!             complex(real64) :: zout(3)
!             character(len=:), pointer :: errmsg
! 
!             p(1) = r
!             e = "R"
!             call z(p, w, zout, e, errstat, errmsg)
!             print *, zout
!             print *, errstat, errmsg
!         end program
! 
!     Example in C:
! 
!         int main(void){
!             int errstat, i;
!             double w[3] = {1.0, 1.0, 1.0};
!             double p[3] = {100.00, 0.0, 0.0};
!             ecx_cdouble z[3] = {ecx_cbuild(0.0,0.0),
!                                 ecx_cbuild(0.0, 0.0),
!                                 ecx_cbuild(0.0, 0.0)};
!             char *errmsg;
! 
!             ecx_eis_z(p, w, z, 'R', 3, 3, &errstat, &errmsg);
! 
!             for(i=0; i<3;i++){
!                 printf("%f %f \n", creal(z[i]), cimag(z[i]));
!             }
!             printf("%d %s\n", errstat, errmsg);
!             return EXIT_SUCCESS;
!         }
! 
!     Example in Python:
! 
!         import numpy as np
!         import pyecx
!         import matplotlib.pyplot as plt
! 
!         R = 100
!         C = 1e-6
!         w = np.logspace(6, -3, 100)
! 
!         p = np.asarray([R, 0.0, 0.0])
!         zr = np.asarray(pyecx.z("R", w, p))
!         p = np.asarray([C, 0.0, 0.0])
!         zc = np.asarray(pyecx.z("C", w, p))
!         zrc = zr*zc / (zr+zc)
!         print("finish")
! 
!         fig = plt.figure()
!         ax = fig.add_subplot(111)
! 
!         ax.set_aspect("equal")
!         ax.plot(zrc.real, zrc.imag, "g.", label="R/C")
! 
!         ax.invert_yaxis()
! 
!         plt.show()
! 
! SEE ALSO
!     complex(7), gsl(3), catanh(3), gnuplot(1),
!     ecx_get_version(3)
!
module ecx
    !! Main module for ecx.
    use ecx__api
    use ecx__capi
end module
