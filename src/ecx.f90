!> @file
!! Electrochemistry module.

!> @brief Electrochemistry module.
module ecx
    use iso_fortran_env
    implicit none
    private

public :: ecx_z_r, ecx_z_c

contains

!> @brief Compute resistance impedance. 
!! @details \f$ Z = R \forall \omega \f$
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] R Resistance in Ohms.
pure elemental function ecx_z_r(w, R) result(Z)
    implicit none

    real(real64), intent(in) :: R
    real(real64), intent(in) :: w
    complex(real64) :: Z

    Z = cmplx(R, 0.0d0, kind=real64)
end function

!!
!> @brief Compute capacitance impedance. 
!! @details \f$ Z = 1/(jCw) \f$
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] R Resistance in Ohms.
pure elemental function ecx_z_c(w, C) result(Z)
    implicit none

    real(real64), intent(in) :: C
    real(real64), intent(in) :: w
    complex(real64) :: Z

    Z = cmplx(0.0d0, -1/(C*w), kind=real64)
end function
end module