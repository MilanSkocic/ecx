module ecx__pec
    !! Module for PEC.
    use iso_fortran_env
    use ecx__core
    use codata
    implicit none
    private
    
contains

pure elemental function ecx_pec_alpha(hv, Eg, n)result(alpha)
    !! Compute the not scaled absorbance coefficient.
    implicit none

    real(real64), intent(in) :: hv
        !! Light energy in eV.
    real(real64), intent(in) :: Eg
        !! Bandgap in eV.
    real(real64), intent(in) :: n
        !! Exponent for direct (1/2) or indirect transition (2)

    real(real64) :: alpha
        !! Absorbance coefficient in eV.

    real(real64) :: d
    d = hv - Eg

    if(d > 0.0d0)then
        alpha = (hv - Eg)**n / hv
    else
        alpha = 0.0d0
    endif
end function

pure elemental function ecx_pec_iph(hv, K, Eg, theta, n)result(iph)
    !! Compute the complex photocurrent
    implicit none

    real(real64), intent(in) :: hv
        !! hv Light energy in eV.
    real(real64), intent(in) :: K
        !! Scaling factor for absorbance in .
    real(real64), intent(in) :: Eg
        !! Bandgap in eV.
    real(real64), intent(in) :: theta
        !! Phase in degrees.
    real(real64), intent(in) :: n 
        !! Transition type: n=1/2 for direct transition and n=2 for indirect transition
    complex(real64) :: iph
        !! @return iph Complex photocurrent.

    real(real64) :: re, im, mod, phase
    
    phase = ecx_core_deg2rad(theta)
    mod = K**n * ecx_pec_alpha(hv, Eg, n)
    re = mod * cos(phase)
    im = mod *sin(phase)
    iph = cmplx(re, im, kind=real64)

end function

end module