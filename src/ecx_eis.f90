!> @file
!! @brief EIS module.

!> @brief EIS module. 
module ecx__eis
    use iso_fortran_env
    use iso_c_binding, only: c_double, c_int, c_double_complex, c_size_t, c_char, c_loc, c_ptr, c_null_char
    use ieee_arithmetic, only: ieee_quiet_nan, ieee_value
    use ecx__core
    implicit none
    private

    character(len=:), allocatable, target :: errmsg_f
    character(len=:), allocatable, target :: errmsg_c
    
public :: z, capi_z

contains

!> @brief Compute the complex impedance for a resistor. 
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] R Resistance in Ohms.
!! @return Complex impedance in Ohms.
pure elemental function zr(w, R) result(Z)
    implicit none
    real(real64), intent(in) :: R
    real(real64), intent(in) :: w
    complex(real64) :: Z
    Z = cmplx(R, 0.0d0, kind=real64)
end function

pure elemental function zc(w, C) result(Z)
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

pure elemental function zl(w, L)result(Z)
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

pure elemental function zq(w, Q, a)result(Z)
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
    Z = cmplx(mod * cos(a*PI/2), -mod*sin(a*PI/2), kind=real64)
end function

pure elemental function zw(w, s)result(Z)
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

pure elemental function zo(w, R, tau, n)result(Z)
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

pure elemental function zt(w, R, tau, n)result(Z)
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

pure elemental function zg(w, G, K)result(Z)
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

!> @brief Compute the complex impedance for the given element.
!! @param[in] p Parameters.
!! @param[in] w Angular frequencies in rad.s-1
!! @param[in] zout Complex impedance in Ohms.
!! @param[in] e Electrochemical element: R, C, L, Q, O, T, G
!! @param[in] k Size of p
!! @param[in] n Size of w
!! @param[in] errstat Error status
!! @param[in] errmsg Error message
subroutine z(p, w, zout, e, errstat, errmsg)
    implicit none
    real(real64), intent(in) :: p(:)
    real(real64), intent(in) :: w(:)
    character(len=1), intent(in) :: e
    complex(real64), intent(out) :: zout(:)
    integer(int32), intent(out) :: errstat
    character(len=:), intent(out), pointer :: errmsg
    
    
    if(allocated(errmsg_f))then
        deallocate(errmsg_f)
    endif
    
    errstat = 0
    if(size(p)<3)then
        errmsg_f = "The size of p must be 3."
        errstat = 1
        zout = cmplx(ieee_value(0.0d0, ieee_quiet_nan), &
                ieee_value(0.0d0, ieee_quiet_nan), &
                real64)
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
                zout = cmplx(ieee_value(0.0d0, ieee_quiet_nan), &
                        ieee_value(0.0d0, ieee_quiet_nan), &
                        real64)
        end select
    endif
    errmsg => errmsg_f

end subroutine


!> @brief C API - Compute the complex impedance for the given element.
!! @param[in] p Parameters.
!! @param[in] w Angular frequencies in rad.s-1
!! @param[in] zout Complex impedance in Ohms.
!! @param[in] e Electrochemical element: R, C, L, Q, O, T, G
!! @param[in] k Size of p
!! @param[in] n Size of w
!! @param[in] errstat Error status
!! @param[in] errmsg Error message
subroutine capi_z(p, w, zout, e, k, n, errstat, errmsg)bind(C, name="ecx_eis_z")
    implicit none
    integer(c_size_t), intent(in), value :: n
    integer(c_size_t), intent(in), value :: k
    character(len=1,kind=c_char), intent(in), value :: e
    real(c_double), intent(in) :: p(k)
    real(c_double), intent(in) :: w(n)
    complex(c_double_complex), intent(out) :: zout(n)
    integer(c_int), intent(out) :: errstat
    type(c_ptr), intent(out) :: errmsg
    
    character(len=:), pointer :: fptr

    call z(p, w, zout, e, errstat, fptr)

    if(allocated(errmsg_c))then
        deallocate(errmsg_c)
    endif
    allocate(character(len=len(fptr)+1) :: errmsg_c)

    errmsg_c = fptr // c_null_char
    errmsg = c_loc(errmsg_c)

end subroutine

subroutine mm(p, w, zout, n)
    !! Compute the measurement model.
    real(real64), intent(in) :: p(:)
        !! Parameters.
    real(real64), intent(in) :: w(:)
        !! Angular frequencies in rad.s-1
    complex(real64), intent(out) :: zout(:)
        !! Complex impedance in Ohms.
    integer(int32), intent(in) :: n
        !! Number of voigt elements.

    integer(int32) :: i
    integer(int32) :: errstat
    character(len=:), pointer :: errmsg
    complex(real64) :: zr(size(zout))
    complex(real64) :: zc(size(zout))

    if(n<1)then
        errstat = 3
        zout = cmplx(ieee_value(0.0d0, ieee_quiet_nan), ieee_value(0.0d0, ieee_quiet_nan), real64)
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
            zout = cmplx(ieee_value(0.0d0, ieee_quiet_nan), ieee_value(0.0d0, ieee_quiet_nan), real64)
        endif
    endif


end subroutine

end module
