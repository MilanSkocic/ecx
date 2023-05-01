!> @file
!! Electrochemistry module.

!> @brief Electrochemistry module.
module ecx
    use iso_fortran_env
    implicit none
    private

public :: ecx_zr, ecx_zc

contains

!> @brief Compute resistance impedance. 
!! @details \f$ Z = R \forall \omega \f$
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] R Resistance in Ohms.
pure elemental function ecx_zr(w, R) result(Z)
    implicit none

    real(real64), intent(in) :: R
    real(real64), intent(in) :: w
    complex(real64) :: Z

    Z = cmplx(R, 0.0d0, kind=real64)
end function

!> @brief Compute capacitance impedance. 
!! @details \f$ Z = 1/(jCw) \f$
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] R Resistance in Ohms.
pure elemental function ecx_zc(w, C) result(Z)
    implicit none

    real(real64), intent(in) :: C
    real(real64), intent(in) :: w
    complex(real64) :: Z

    Z = cmplx(0.0d0, -1/(C*w), kind=real64)
end function

!> @brief Compute band egde absorbance coefficient for SC.
!! param[in] hv Light energy in eV.
!! param[in] Eg Band gap in eV.
pure elemental function ecx_alpha(hv, Eg)result(alpha)
    implicit none
    real(real64), intent(in) :: hv
    real(real64), intent(in) :: Eg
    real(real64):: alpha

    if (hv<=Eg) then
        alpha = 0.0
    else
        alpha = (hv-Eg)/hv
    endif

end function

end module