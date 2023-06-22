!> @file
!! EIS Module.

!> @brief Module containing functions and subroutines for Electrochemical Impedance Spectroscopy.
module ecx__eis
    use iso_fortran_env
    implicit none
    private
    
    !> PI constant
    real(real64), parameter :: PI = 4.0d0*datan(1.0d0)

public :: ecx_eis_zr, ecx_eis_zc, ecx_eis_zl, ecx_eis_zcpe
public :: ecx_eis_zw, ecx_eis_zflw, ecx_eis_zfsw, ecx_eis_zg

contains

!> @brief Compute the complex impedance for a resistor. 
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] R Resistance in Ohms.
!! @return Z Complex impedance in Ohms.
pure elemental function ecx_eis_zr(w, R) result(Z)
    implicit none

    real(real64), intent(in) :: R
    real(real64), intent(in) :: w
    complex(real64) :: Z
    Z = cmplx(R, 0.0d0, kind=real64)
end function

!> @brief Compute the complex impedance for a capacitor. 
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] C Capacitance in Farad.
!! @return Z Complex impedance in Ohms.
pure elemental function ecx_eis_zc(w, C) result(Z)
    implicit none

    real(real64), intent(in) :: C
    real(real64), intent(in) :: w
    complex(real64) :: Z

    Z = cmplx(0.0d0, -1/(C*w), kind=real64)
end function


!> @brief Compute the complex impedance for an inductor. 
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] L Inductance in Henry.
!! @return Z Complex impedance in Ohms.
pure elemental function ecx_eis_zl(w, L)result(Z)
    implicit none

    real(real64), intent(in) :: L
    real(real64), intent(in) :: w
    complex(real64) :: Z

    Z = cmplx(0.0d0, L*w, kind=real64)
end function

!> @brief Compute the complex impedance for a CPE. 
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] Q Resistance in S.s^-a
!! @param[in] a CPE exponent
!! @return Z Complex impedance in Ohms.
pure elemental function ecx_eis_zcpe(w, Q, a)result(Z)
    implicit none

    real(real64), intent(in) :: Q
    real(real64), intent(in) :: w
    real(real64), intent(in) :: a
    complex(real64) :: Z

    real(real64) :: mod

    mod = 1/(Q*w**a)
    Z = cmplx(mod * cos(a*PI/2), -mod*sin(a*PI/2), kind=real64)
end function

!> @brief Compute the complex impedance for a semi-infinite Warburg.
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] s Pseudo-Resistance in Ohms.s^(1/2).
!! @return Z Complex impedance in Ohms.
pure elemental function ecx_eis_zw(w, s)result(Z)
    implicit none
    real(real64), intent(in) :: w
    real(real64), intent(in) :: s
    complex(real64) :: Z
    real(real64) :: s2
    s2 = s/sqrt(w)
    Z = cmplx(s2, -s2, kind=real64)
end function


!> @brief Compute the complex impedance for a finite length warburg
!! @param[in] w Angular frequency in rad.s^-1.
!! @param[in] R Resistance in Ohms.
!! @param[in] tau Characteristic time in s.
!! @return Z Complex impedance in Ohms.
pure elemental function ecx_eis_zflw(w, R, tau)result(Z)
    implicit none
    real(real64), intent(in) :: w
    real(real64), intent(in) :: R
    real(real64), intent(in) :: tau
    complex(real64) :: Z
    complex(real64) :: x

    x = sqrt(cmplx(0.0d0, tau*w, kind=real64))

    Z = R/x * tanh(x)

end function

!> @brief Compute the complex impedance for a finite space warburg
!! @param[in] w Angular frequency in rad.s^-1.
!! @param[in] R Resistance in Ohms.
!! @param[in] tau Characteristic time in s.
!! @return Z Complex impedance in Ohms.
pure elemental function ecx_eis_zfsw(w, R, tau)result(Z)
    implicit none
    real(real64), intent(in) :: w
    real(real64), intent(in) :: R
    real(real64), intent(in) :: tau
    complex(real64) :: Z
    complex(real64) :: x

    x = sqrt(cmplx(0.0d0, tau*w, kind=real64))

    Z = R/(x * tanh(x))

end function

!> @brief Compute the complex impedance of the Gerisher element.
!! @param w Angular frequency in rad.s^-1.
!! @param G Pseudo-Resistance in Ohms.s^(1/2).
!! @param K Offset in rad.s^-1.
!! @return Z Complex impedance in Ohms. 
pure elemental function ecx_eis_zg(w, G, K)result(Z)
    implicit none
    real(real64), intent(in) :: w
    real(real64), intent(in) :: G
    real(real64), intent(in) :: K
    complex(real64) :: Z
    complex(real64) :: x
    
    x = cmplx(0.0d0, w, kind=real64)
    Z = G / sqrt(K+x)
end function

!> @brief Compute the complex impedance of a simple Randles: Rel+Rct/Cdl
!! @param[in] Rel Electrolyte resistance in Ohms.
!! @param[in] Rct Charge transfert resistance in Ohms.
!! @param[in] C Double layer capacitance in Farad.
!! @return Z Complex impedance in Ohms. 
pure elemental function ecx_eis_randles(w, Rel, Rct, Cdl)result(Z)
    implicit none
    real(real64), intent(in) :: w
    real(real64), intent(in) :: Rel
    real(real64), intent(in) :: Rct
    real(real64), intent(in) :: Cdl
    complex(real64) :: Z
    complex(real64) :: zrel
    complex(real64) :: zrct
    complex(real64) :: zcdl

    zrct = ecx_eis_zr(w, Rct)
    zcdl = ecx_eis_zc(w, Cdl)
    zrel = ecx_eis_zr(w, Rel)

    Z = zrel + (zrct * zcdl)/(zrct+zcdl)
end function

end module