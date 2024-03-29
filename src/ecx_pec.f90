!> @file
!! @brief Module for PEC.

!> @brief Module for PEC.
module ecx__pec
    use iso_fortran_env
    use ecx__core
    use codata
    implicit none
    private

public :: alpha, iph
    
contains


!> @brief Compute the not scaled absorbance coefficient.
!! @param[in] hv Light energy in eV.
!! @param[in] Eg Bandgap in eV.
!! @param[in] n Exponent for direct (1/2) or indirect transition (2)
!! @return Absorbance coefficient in eV.
pure elemental function alpha(hv, Eg, n)result(res)
    implicit none
    real(real64), intent(in) :: hv
    real(real64), intent(in) :: Eg
    real(real64), intent(in) :: n

    real(real64) :: res

    real(real64) :: d
    d = hv - Eg

    if(d > 0.0d0)then
        res = (hv - Eg)**n / hv
    else
        res = 0.0d0
    endif
end function

!> @brief Compute the complex photocurrent
!! @param[in] hv Light energy in eV.
!! @param[in] K Scaling factor for absorbance in .
!! @param[in] Eg Bandgap in eV.
!! @param[in] theta Phase in degrees.
!! @param[in] n Transition type: n=1/2 for direct transition and n=2 for indirect transition
!! @return iph Complex photocurrent.
pure elemental function iph(hv, K, Eg, theta, n)result(res)
    implicit none
    real(real64), intent(in) :: hv
    real(real64), intent(in) :: K
    real(real64), intent(in) :: Eg
    real(real64), intent(in) :: theta
    real(real64), intent(in) :: n 
    complex(real64) :: res

    real(real64) :: re, im, mod, phase
    
    phase = ecx_core_deg2rad(theta)
    mod = K**n * alpha(hv, Eg, n)
    re = mod * cos(phase)
    im = mod *sin(phase)
    res = cmplx(re, im, kind=real64)

end function

end module
