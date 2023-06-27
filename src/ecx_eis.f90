!> @file
!! EIS Module.

!> @brief Module containing functions and subroutines for Electrochemical Impedance Spectroscopy.
module ecx__eis
    use iso_fortran_env
    use ieee_arithmetic
    implicit none
    private
    
    !> PI constant
    real(real64), parameter :: PI = 4.0d0*datan(1.0d0)

public :: ecx_eis_z
public :: ecx_eis_zr, ecx_eis_zc, ecx_eis_zl
public :: ecx_eis_zw, ecx_eis_zflw, ecx_eis_zfsw
public :: ecx_eis_zg, ecx_eis_zcpe

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
impure elemental function ecx_eis_zc(w, C) result(Z)
    implicit none

    real(real64), intent(in) :: C
    real(real64), intent(in) :: w
    complex(real64) :: Z
    Z = cmplx(0.0d0, -1.0d0/(C*w), kind=real64)
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
pure elemental function ecx_eis_zflw(w, R, tau, n)result(Z)
    implicit none
    real(real64), intent(in) :: w
    real(real64), intent(in) :: R
    real(real64), intent(in) :: tau
    real(real64), intent(in) :: n
    complex(real64) :: Z
    complex(real64) :: x

    x = sqrt(cmplx(0.0d0, tau*w, kind=real64))
    x = x**n
    Z = R/x * tanh(x)

end function

!> @brief Compute the complex impedance for a finite space warburg
!! @param[in] w Angular frequency in rad.s^-1.
!! @param[in] R Resistance in Ohms.
!! @param[in] tau Characteristic time in s.
!! @return Z Complex impedance in Ohms.
pure elemental function ecx_eis_zfsw(w, R, tau, n)result(Z)
    implicit none
    real(real64), intent(in) :: w
    real(real64), intent(in) :: R
    real(real64), intent(in) :: tau
    real(real64), intent(in) :: n
    complex(real64) :: Z
    complex(real64) :: x

    x = cmplx(0.0d0, tau*w, kind=real64)
    x = x**n

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

subroutine ecx_eis_z(e, p, w, z)
    ! Compute the complex impedance for the given element.
    implicit none
    character(len=1), intent(in) :: e
    real(real64), intent(in) :: p(:)
    real(real64), intent(in) :: w(:)
    complex(real64), intent(out) :: z(:)
    select case(e)
        case("R")
            z = ecx_eis_zr(w, p(1))
        case("C")
            z = ecx_eis_zc(w, p(1))
        case("L")
            z = ecx_eis_zl(w, p(1))
        case("W")
            z = ecx_eis_zw(w, p(1))
        case("Q")
            z = ecx_eis_zcpe(w, p(1), p(2))
        case("O")
            z = ecx_eis_zflw(w, p(1), p(2), p(3))
        case("T")
            z = ecx_eis_zfsw(w, p(1), p(2), p(3))
        case("G")
            z = ecx_eis_zg(w, p(1), p(2))
        case DEFAULT
            z = cmplx(ieee_value(0.0d0, ieee_quiet_nan), &
                      ieee_value(0.0d0, ieee_quiet_nan), &
                      real64)
    end select

end subroutine

end module