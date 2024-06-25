module ecx__eis
    !! EIS module.
    use stdlib_kinds, only: dp, int32
    use iso_c_binding, only: c_double, c_int, c_double_complex, c_size_t, c_char, c_loc, c_ptr, c_null_char
    use ieee_arithmetic, only: ieee_quiet_nan, ieee_value
    use ecx__core
    implicit none
    private

    character(len=:), allocatable, target :: errmsg_f
    character(len=:), allocatable, target :: errmsg_c
    
    public :: z

contains

pure elemental function zr(w, R) result(Z)
    !! Compute the complex impedance for a resistor. 
    implicit none
    real(dp), intent(in) :: R
        !! Resistance in Ohms.
    real(dp), intent(in) :: w
        !! Angular frequencies in rad.s^-1.

    complex(dp) :: Z
        !! Complex impedance in Ohms.

    Z = cmplx(R, 0.0_dp, kind=dp)
end function

pure elemental function zc(w, C) result(Z)
    !! Compute the complex impedance for a capacitor. 
    implicit none

    real(dp), intent(in) :: C
        !! Capacitance in Farad.
    real(dp), intent(in) :: w
        !! Angular frequencies in rad.s^-1.
    complex(dp) :: Z
        !! Complex impedance in Ohms.
    Z = cmplx(0.0_dp, -1.0_dp/(C*w), kind=dp)
end function

pure elemental function zl(w, L)result(Z)
    !! Compute the complex impedance for an inductor. 
    implicit none

    real(dp), intent(in) :: L
        !! Inductance in Henry.
    real(dp), intent(in) :: w
        !! Angular frequencies in rad.s^-1.
    complex(dp) :: Z
        !! Complex impedance in Ohms.

    Z = cmplx(0.0_dp, L*w, kind=dp)
end function

pure elemental function zq(w, Q, a)result(Z)
    !! Compute the complex impedance for a CPE. 
    implicit none

    real(dp), intent(in) :: Q
        !! Resistance in S.s^-a
    real(dp), intent(in) :: w
        !! Angular frequencies in rad.s^-1.
    real(dp), intent(in) :: a
        !! CPE exponent
    complex(dp) :: Z
        !! Complex impedance in Ohms.

    real(dp) :: mod

    mod = 1/(Q*w**a)
    Z = cmplx(mod * cos(a*PI/2), -mod*sin(a*PI/2), kind=dp)
end function

pure elemental function zw(w, s)result(Z)
    !! Compute the complex impedance for a semi-infinite Warburg.
    implicit none
    real(dp), intent(in) :: w
        !! Angular frequencies in rad.s^-1.
    real(dp), intent(in) :: s
        !! Pseudo-Resistance in Ohms.s^(1/2).
    complex(dp) :: Z
        !! Complex impedance in Ohms.
    real(dp) :: s2
    s2 = s/sqrt(w)
    Z = cmplx(s2, -s2, kind=dp)
end function

pure elemental function zo(w, R, tau, n)result(Z)
    !! @brief Compute the complex impedance for a finite length warburg
    implicit none
    real(dp), intent(in) :: w
        !! Angular frequency in rad.s^-1.
    real(dp), intent(in) :: R
        !! Resistance in Ohms.
    real(dp), intent(in) :: tau
        !! Characteristic time in s.
    real(dp), intent(in) :: n
        !! Order of the fsw.
    complex(dp) :: Z
        !! Complex impedance in Ohms.
    complex(dp) :: x


    x = sqrt(cmplx(0.0_dp, tau*w, kind=dp))
    x = x**n
    Z = R/x * tanh(x)

end function

pure elemental function zt(w, R, tau, n)result(Z)
    !! Compute the complex impedance for a finite space warburg
    implicit none
    real(dp), intent(in) :: w
        !! Angular frequency in rad.s^-1.
    real(dp), intent(in) :: R
        !! Resistance in Ohms.
    real(dp), intent(in) :: tau
        !! Characteristic time in s.
    real(dp), intent(in) :: n
        !! Order of the fsw.
    complex(dp) :: Z
        !! Complex impedance in Ohms.
    complex(dp) :: x

    x = cmplx(0.0_dp, tau*w, kind=dp)
    x = x**n

    Z = R/(x * tanh(x))

end function

pure elemental function zg(w, G, K)result(Z)
    !! Compute the complex impedance of the Gerisher element.
    implicit none
    real(dp), intent(in) :: w
        !! Angular frequency in rad.s^-1.
    real(dp), intent(in) :: G
        !! Pseudo-Resistance in Ohms.s^(1/2).
    real(dp), intent(in) :: K
        !! Offset in rad.s^-1.
    complex(dp) :: Z
        !! Complex impedance in Ohms. 
    complex(dp) :: x
    
    x = cmplx(0.0_dp, w, kind=dp)
    Z = G / sqrt(K+x)
end function

subroutine z(p, w, zout, e, errstat, errmsg)
    !! Compute the complex impedance for the given element.
    implicit none
    real(dp), intent(in) :: p(:)
        !! Parameters
    real(dp), intent(in) :: w(:)
        !! Angular frequencies in rad.s-1
    character(len=1), intent(in) :: e
        !! Electrochemical element: R, C, L, Q, O, T, G
    complex(dp), intent(out) :: zout(:)
        !! Complex impedance in Ohms.
    integer(int32), intent(out) :: errstat
        !! Error status
    character(len=:), intent(out), pointer :: errmsg
        !! Error message
     
    
    if(allocated(errmsg_f))then
        deallocate(errmsg_f)
    endif
    
    errstat = 0
    if(size(p)<3)then
        errmsg_f = "The size of p must be 3."
        errstat = 1
        zout = cmplx(ieee_value(0.0_dp, ieee_quiet_nan), &
                ieee_value(0.0_dp, ieee_quiet_nan), &
                dp)
    else
        select case(e)
            case("R")
                zout = zr(w, p(1))
                errmsg_f = "No error"
            case("C")
                zout = zc(w, p(1))
                errmsg_f = "No error"
            case("L")
                zout = zl(w, p(1))
                errmsg_f = "No error"
            case("W")
                zout = zw(w, p(1))
                errmsg_f = "No error"
            case("Q")
                zout = zq(w, p(1), p(2))
                errmsg_f = "No error"
            case("O")
                zout = zo(w, p(1), p(2), p(3))
                errmsg_f = "No error"
            case("T")
                zout = zt(w, p(1), p(2), p(3))
                errmsg_f = "No error"
            case("G")
                zout = zg(w, p(1), p(2))
                errmsg_f = "No error"
            case DEFAULT
                errstat= 2
                errmsg_f = "Unknown element: "//e
                zout = cmplx(ieee_value(0.0_dp, ieee_quiet_nan), &
                        ieee_value(0.0_dp, ieee_quiet_nan), &
                        dp)
        end select
    endif
    errmsg => errmsg_f

end subroutine

subroutine mm(p, w, zout, n)
    !! Compute the measurement model.
    real(dp), intent(in) :: p(:)
        !! Parameters.
    real(dp), intent(in) :: w(:)
        !! Angular frequencies in rad.s-1
    complex(dp), intent(out) :: zout(:)
        !! Complex impedance in Ohms.
    integer(int32), intent(in) :: n
        !! Number of voigt elements.

    integer(int32) :: i
    integer(int32) :: errstat
    character(len=:), pointer :: errmsg
    complex(dp) :: zr(size(zout))
    complex(dp) :: zc(size(zout))

    if(n<1)then
        errstat = 3
        zout = cmplx(ieee_value(0.0_dp, ieee_quiet_nan), ieee_value(0.0_dp, ieee_quiet_nan), dp)
    else 
        if(size(p) == (1+n*2))then
            call z(p, w, zout, "R", errstat, errmsg)
            do i = 1, n-2
                call z(p(i+1:), w, zr, "R", errstat, errmsg)
                call z(p(i+2:), w, zc, "C", errstat, errmsg)
                zout = zout + (zr*zc) / (zr+zc)
            enddo
        else
            errstat = 4
            zout = cmplx(ieee_value(0.0_dp, ieee_quiet_nan), ieee_value(0.0_dp, ieee_quiet_nan), dp)
        endif
    endif


end subroutine

end module
