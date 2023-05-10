!> @file
!! EIS Module.

!> @brief Module containing functions and subroutines for Electrochemical Impedance Spectroscopy.
module ecx_eis
    use iso_fortran_env
    use ecx_common
    implicit none
    private

public :: ecx_eis_zr, ecx_eis_zc

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
pure elemental function ecx_eis_w(w, s)result(Z)
    implicit none
    real(real64), intent(in) :: w
    real(real64), intent(in) :: s
    complex(real64) :: Z
    real(real64) :: s2
    s2 = s/sqrt(2.0d0)
    Z = cmplx(s2, -s2, kind=real64)
end function


!> @brief Compute the complex impedance for a finite length warburg
!! @param[in] w Angular frequency in rad.s^-1.
!! @param[in] r Resistance in Ohms.
!! @param[in] tau Characteristic time in s.
!! @return Z Complex impedance in Ohms.
pure elemental function flw(w, r, tau)result(Z)
    implicit none
    real(real64), intent(in) :: w
    real(real64), intent(in) :: r
    real(real64), intent(in) :: tau
    complex(real64) :: Z
    complex(real64) :: x

    x = sqrt(cmplx(0.0d0, tau*w, kind=real64))

    Z = r/x * tanh(x)

end function

!> @brief Compute the complex impedance for a finite space warburg
!! @param[in] w Angular frequency in rad.s^-1.
!! @param[in] r Resistance in Ohms.
!! @param[in] tau Characteristic time in s.
!! @return Z Complex impedance in Ohms.
pure elemental function fsw(w, r, tau)result(Z)
    implicit none
    real(real64), intent(in) :: w
    real(real64), intent(in) :: r
    real(real64), intent(in) :: tau
    complex(real64) :: Z
    complex(real64) :: x

    x = sqrt(cmplx(0.0d0, tau*w, kind=real64))

    Z = r/(x * tanh(x))

end function

end module