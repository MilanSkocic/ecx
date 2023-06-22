!> @file
!! PEC module.

!> @brief Module containing functions and subroutines for PhotoElectrochemistry.
module ecx__pec
    use iso_fortran_env
    use codata
    implicit none
    private
    
    !> PI constant
    real(real64), parameter :: PI = 4.0d0*datan(1.0d0)

contains

!> @brief Compute the not scaled absorbance coefficient.
!! @param[in] hv Light energy in eV.
!! @param[in] Eg Bandgap in eV.
!! @param[in] n Exponent for direct (1/2) or indirect transition (2)
!! @return alpha  energy in eV.
pure elemental function ecx_pec_alpha(hv, Eg, n)result(alpha)
    implicit none

    !! arguments
    real(real64), intent(in) :: hv
    real(real64), intent(in) :: Eg
    real(real64), intent(in) :: n

    !!returns
    real(real64) :: alpha

    !! local variables
    real(real64) :: d

    d = hv - Eg

    if(d > 0.0d0)then
        alpha = (hv - Eg)**n
    else
        alpha = 0.0d0
    endif
end function

!> @brief Converts degrees to rad.
!! @param[in] theta Angle in degrees.
!! @return phase Angle in rad.
pure elemental function ecx_pec_deg2rad(theta)result(phase)
    implicit none
    real(real64), intent(in) :: theta
    real(real64) :: phase
    phase = theta * PI / 180.0d0
end 

!> @brief Compute the complex photocurrent
!! @param[in] hv Light energy in eV.
!! @param[in] K Scaling factor for absorbance in .
!! @param[in] Eg Bandgap in eV.
!! @param[in] theta Phase in degrees.
!! @param[in] n Transition type: n=1/2 for direct transition and n=2 for indirect transition
!! @return iph Complex photocurrent.
pure elemental function ecx_pec_iph(hv, K, Eg, theta, n)result(iph)
    implicit none

    !! arguments
    real(real64), intent(in) :: hv
    real(real64), intent(in) :: K
    real(real64), intent(in) :: Eg
    real(real64), intent(in) :: theta
    real(real64), intent(in) :: n 

    !! returns
    complex(real64) :: iph

    !! local variables
    real(real64) :: re, im, mod, phase
    
    phase = ecx_pec_deg2rad(theta)
    mod = K**n * ecx_pec_alpha(hv, Eg, n)
    re = mod * cos(phase)
    im = mod *sin(phase)
    iph = cmplx(re, im, kind=real64)

end function


end module