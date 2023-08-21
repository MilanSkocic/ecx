module ecx__eis
    !! Module containing functions and subroutines for Electrochemical Impedance Spectroscopy.
    use iso_fortran_env
    use ieee_arithmetic
    use ecx__utilities
    implicit none
    private
    
    type :: ecx_eis_error_messages_t
        integer(int32) :: i
        character(len=64) :: msg
    end type

    type(ecx_eis_error_messages_t), parameter :: ecx_eis_errmsg(3) = &
    [ecx_eis_error_messages_t(1, "Parameter array must be at least of size 3."), &
    ecx_eis_error_messages_t(2, "Unknown element."), &
    ecx_eis_error_messages_t(3, "n must be greater or equal to 1.")] 
    

public :: ecx_eis_z
public :: ecx_eis_zr, ecx_eis_zc, ecx_eis_zl
public :: ecx_eis_zw, ecx_eis_zflw, ecx_eis_zfsw
public :: ecx_eis_zg, ecx_eis_zcpe
public :: ecx_eis_errmsg

contains

pure elemental function ecx_eis_zr(w, R) result(Z)
    !! Compute the complex impedance for a resistor. 
    implicit none

    real(real64), intent(in) :: R
        !! Resistance in Ohms.
    real(real64), intent(in) :: w
        !! Angular frequencies in rad.s^-1.
    complex(real64) :: Z
        !! Complex impedance in Ohms.
    Z = cmplx(R, 0.0d0, kind=real64)
end function

pure elemental function ecx_eis_zc(w, C) result(Z)
    !! Compute the complex impedance for a capacitor. 
    implicit none

    real(real64), intent(in) :: C
        !! Capacitance in Farad.
    real(real64), intent(in) :: w
        !! Angular frequencies in rad.s^-1.
    complex(real64) :: Z
        !! Complex impedance in Ohms.
    Z = cmplx(0.0d0, -1.0d0/(C*w), kind=real64)
end function

pure elemental function ecx_eis_zl(w, L)result(Z)
    !! Compute the complex impedance for an inductor. 
    implicit none

    real(real64), intent(in) :: L
        !! Inductance in Henry.
    real(real64), intent(in) :: w
        !! Angular frequencies in rad.s^-1.
    complex(real64) :: Z
        !! Complex impedance in Ohms.

    Z = cmplx(0.0d0, L*w, kind=real64)
end function

pure elemental function ecx_eis_zcpe(w, Q, a)result(Z)
    !! Compute the complex impedance for a CPE. 
    implicit none

    real(real64), intent(in) :: Q
        !! Resistance in S.s^-a
    real(real64), intent(in) :: w
        !! Angular frequencies in rad.s^-1.
    real(real64), intent(in) :: a
        !! CPE exponent
    complex(real64) :: Z
        !! Complex impedance in Ohms.

    real(real64) :: mod

    mod = 1/(Q*w**a)
    Z = cmplx(mod * cos(a*ecx_PI/2), -mod*sin(a*ecx_PI/2), kind=real64)
end function

pure elemental function ecx_eis_zw(w, s)result(Z)
    !! Compute the complex impedance for a semi-infinite Warburg.
    implicit none
    real(real64), intent(in) :: w
        !! Angular frequencies in rad.s^-1.
    real(real64), intent(in) :: s
        !! Pseudo-Resistance in Ohms.s^(1/2).
    complex(real64) :: Z
        !! Complex impedance in Ohms.
    real(real64) :: s2
    s2 = s/sqrt(w)
    Z = cmplx(s2, -s2, kind=real64)
end function

pure elemental function ecx_eis_zflw(w, R, tau, n)result(Z)
    !! @brief Compute the complex impedance for a finite length warburg
    implicit none
    real(real64), intent(in) :: w
        !! Angular frequency in rad.s^-1.
    real(real64), intent(in) :: R
        !! Resistance in Ohms.
    real(real64), intent(in) :: tau
        !! Characteristic time in s.
    real(real64), intent(in) :: n
        !! Order of the fsw.
    complex(real64) :: Z
        !! Complex impedance in Ohms.
    complex(real64) :: x


    x = sqrt(cmplx(0.0d0, tau*w, kind=real64))
    x = x**n
    Z = R/x * tanh(x)

end function

pure elemental function ecx_eis_zfsw(w, R, tau, n)result(Z)
    !! Compute the complex impedance for a finite space warburg
    implicit none
    real(real64), intent(in) :: w
        !! Angular frequency in rad.s^-1.
    real(real64), intent(in) :: R
        !! Resistance in Ohms.
    real(real64), intent(in) :: tau
        !! Characteristic time in s.
    real(real64), intent(in) :: n
        !! Order of the fsw.
    complex(real64) :: Z
        !! Complex impedance in Ohms.
    complex(real64) :: x

    x = cmplx(0.0d0, tau*w, kind=real64)
    x = x**n

    Z = R/(x * tanh(x))

end function

pure elemental function ecx_eis_zg(w, G, K)result(Z)
    !! Compute the complex impedance of the Gerisher element.
    implicit none
    real(real64), intent(in) :: w
        !! Angular frequency in rad.s^-1.
    real(real64), intent(in) :: G
        !! Pseudo-Resistance in Ohms.s^(1/2).
    real(real64), intent(in) :: K
        !! Offset in rad.s^-1.
    complex(real64) :: Z
        !! Complex impedance in Ohms. 
    complex(real64) :: x
    
    x = cmplx(0.0d0, w, kind=real64)
    Z = G / sqrt(K+x)
end function

pure subroutine ecx_eis_z(p, w, z, e, errstat)
    !! Compute the complex impedance for the given element.
    implicit none
    character(len=1), intent(in) :: e
        !! Electrochemical element: R, C, L, Q, O, T, G
    integer(int32), intent(out) :: errstat
        !! Error status
    real(real64), intent(in) :: p(:)
        !! Parameters.
    real(real64), intent(in) :: w(:)
        !! Angular frequencies in rad.s-1
    complex(real64), intent(out) :: z(:)
        !! Complex impedance in Ohms.
    
    errstat = 0
    if(size(p)<3)then
        errstat = 1
        z = cmplx(ieee_value(0.0d0, ieee_quiet_nan), &
                ieee_value(0.0d0, ieee_quiet_nan), &
                real64)
    else
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
                errstat= 2
                z = cmplx(ieee_value(0.0d0, ieee_quiet_nan), &
                        ieee_value(0.0d0, ieee_quiet_nan), &
                        real64)
        end select
    endif

end subroutine

pure subroutine ecx_eis_mm(p, w, z, n)
    !! Compute the measurement model.
    real(real64), intent(in) :: p(:)
        !! Parameters.
    real(real64), intent(in) :: w(:)
        !! Angular frequencies in rad.s-1
    complex(real64), intent(out) :: z(:)
        !! Complex impedance in Ohms.
    integer(int32), intent(in) :: n
        !! Number of voigt elements.

    integer(int32) :: i
    integer(int32) :: errstat
    complex(real64) :: zr(size(z))
    complex(real64) :: zc(size(z))

    if(n<1)then
        errstat = 3
        z = cmplx(ieee_value(0.0d0, ieee_quiet_nan), &
                ieee_value(0.0d0, ieee_quiet_nan), &
                real64)
    else
        call ecx_eis_z(p, w, z, "R", errstat)

        do i = 1, n-2
            call ecx_eis_z(p(i+1:), w, zr, "R", errstat)
            call ecx_eis_z(p(i+2:), w, zc, "C", errstat)
            z = z + (zr*zc) / (zr+zc)
        enddo
    endif

end subroutine

end module