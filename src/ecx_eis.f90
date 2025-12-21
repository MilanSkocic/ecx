module ecx__eis
    use ecx__common
    use ecx__core
    implicit none
    private

    character(len=:), allocatable, target :: errmsg_f
    character(len=:), allocatable, target :: errmsg_c
    
    public :: zr, zc, zl, zq, zw, zo, zt, zg

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



end module
