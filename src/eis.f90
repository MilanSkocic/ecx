!>
!> @file eis.f90
!!

!> @brief Module for Electrochemical Impedance Spectroscopy
module eis
    use iso_fortran_env
    use iso_c_binding
    implicit none


contains

!!
!> @brief Compute resistance impedance. 
!! @details \f$ Z = R \forall \omega \f$
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] R Resistance in Ohms.
pure elemental function resistance_impedance(w, R) result(Z)
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
pure elemental function capacitance_impedance(w, C) result(Z)
    implicit none

    real(real64), intent(in) :: C
    real(real64), intent(in) :: w
    complex(real64) :: Z

    Z = cmplx(0.0d0, -1/(C*w), kind=real64)
end function

end module