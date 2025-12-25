!> @brief PEC
module ecx__pec
    !! PEC.
    use ecx__common
    use ecx__core
    implicit none
    private

public :: alpha, iph
    
contains


pure elemental function alpha(hv, Eg, n)result(res) !> Compute the not scaled absorbance coefficient.
    implicit none
    real(real64), intent(in) :: hv !! Light energy in eV.
    real(real64), intent(in) :: Eg !! Bandgap in eV.
    real(real64), intent(in) :: n !! Exponent for direct (1/2) or indirect transition (2)

    real(real64) :: res !! Absorbance coefficient in eV.

    real(real64) :: d
    d = hv - Eg

    if(d > 0.0_dp)then
        res = (hv - Eg)**n / hv
    else
        res = 0.0_dp
    endif
end function

pure elemental function iph(hv, K, Eg, theta, n)result(res) !! Compute the complex photocurrent
    !! Compute the complex photocurrent.
    implicit none
    real(real64), intent(in) :: hv !! Light energy in eV.
    real(real64), intent(in) :: K !! Scaling factor for absorbance in .
    real(real64), intent(in) :: Eg !! Bandgap in eV.
    real(real64), intent(in) :: theta !! Phase in degree.
    real(real64), intent(in) :: n  !! Transition type: n=1/2 for direct transition and n=2 for indirect transition
    complex(real64) :: res !! Complex photocurrent Iph

    real(real64) :: re, im, mod, phase
    
    phase = deg2rad(theta)
    mod = K**n * alpha(hv, Eg, n)
    re = mod * cos(phase)
    im = mod *sin(phase)
    res = cmplx(re, im, kind=real64)
end function

end module
