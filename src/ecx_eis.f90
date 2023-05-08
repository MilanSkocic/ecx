!> @file
!! Electrochemistry module.

!> @brief Electrochemistry module.
module ecx_eis
    use iso_fortran_env
    use ecx_constants
    implicit none
    private

public :: ecx_eis_zr, ecx_eis_zc

contains

!> @brief Compute resistance impedance. 
!! @details \f$ Z = R \forall \omega \f$
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] R Resistance in Ohms.
pure elemental function ecx_eis_zr(w, R) result(Z)
    implicit none

    real(real64), intent(in) :: R
    real(real64), intent(in) :: w
    complex(real64) :: Z

    Z = cmplx(R, 0.0d0, kind=real64)
end function

!> @brief Compute capacitance impedance. 
!! @details \f$ Z = 1/(jCw) \f$
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] C Capacitance in Farad.
pure elemental function ecx_eis_zc(w, C) result(Z)
    implicit none

    real(real64), intent(in) :: C
    real(real64), intent(in) :: w
    complex(real64) :: Z

    Z = cmplx(0.0d0, -1/(C*w), kind=real64)
end function


!> @brief Compute inductance impedance. 
!! @details \f$ Z = jLw \f$
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] L Inductance in Henry.
pure elemental function ecx_eis_zl(w, L)result(Z)
    implicit none

    real(real64), intent(in) :: L
    real(real64), intent(in) :: w
    complex(real64) :: Z

    Z = cmplx(0.0d0, L*w, kind=real64)
end function

!> @brief Compute CPE impedance. 
!! @details \f$ Z = 1/((jw)^aQ) \f$
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

end module