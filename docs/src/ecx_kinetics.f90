module ecx__kinetics
    !! Module for computing kinetics using the Butler-Volmer equations.
    use stdlib_kinds, only: dp, int32
    use ecx__core
    implicit none
    private

    public :: nernst
    public :: sbv, bv

contains

pure function nernst(E0, z, aox, vox, ared, vred, T)result(E)
    !! Compute the Nernst electrochemical potential in V.
    implicit none
    real(dp), intent(in) :: E0
        !! Standard electrochemical potential in V.
    integer(int32), intent(in) :: z
        !! Number of exchanged electrons.
    real(dp), intent(in) :: aox(:)
        !! Activities of the oxidants.
    real(dp), intent(in) :: vox(:)
        !! Coefficients for the oxidants.
    real(dp), intent(in) :: ared(:)
        !! Activities of the reductants
    real(dp), intent(in) :: vred(:)
        !! Coefficients for the reductants.
    real(dp), intent(in) :: T
        !! Temperature in °C.

    real(dp) :: E, ox, red, kTe_
    
    kTe_ = kTe(T)
    ox = product(aox**vox)
    red = product(ared**vred)

    E = E0 + kTe_/z * log(ox/red)

end function

pure elemental function sbv(U, OCV, j0, aa, ac, za, zc, A, T)result(I)
    !! Compute Butler Volmer equation without mass transport.
    real(dp), intent(in) :: OCV
        !! Open Circuit Voltage in V.
    real(dp), intent(in) :: U
        !! Electrochemical potential in V.
    real(dp), intent(in) :: j0
        !! Exchange current density in A.cm-2.
    real(dp), intent(in) :: aa
        !! Anodic transfer coefficient.
    real(dp), intent(in) :: ac
        !! Cathodic transfer coefficient.
    real(dp), intent(in) :: za
        !! Number of exchnaged electrons in the anodic branch.
    real(dp), intent(in) :: zc
        !! Number of exchnaged electrons in the cathodic branch.
    real(dp), intent(in) :: A
        !! Area in cm2.
    real(dp), intent(in) :: T
        !! Temperature in °C.

    real(dp) :: I

    real(dp) :: kTe_
    
    kTe_ = kTe(T)

    I = A * j0 * (exp(aa * za * (U - OCV) / kTe_) - exp(-ac * zc * (U - OCV) / kTe_));
end function

pure elemental function bv(U, OCV, j0, jdla, jdlc, aa, ac, za, zc, A, T)result(I)
    !! Compute Butler Volmer equation with mass transport.
    implicit none
    real(dp), intent(in) :: OCV
        !! Open Circuit Voltage in V.
    real(dp), intent(in) :: U
        !! Electrochemical potential in V.
    real(dp), intent(in) :: j0
        !! Exchange current density in A.cm-2.
    real(dp), intent(in) :: jdla
        !! Anodic diffusion limiting current density in A.cm-2.
    real(dp), intent(in) :: jdlc
        !! Cathodic diffusion limiting current density in A.cm-2.
    real(dp), intent(in) :: aa
        !! Anodic transfer coefficient.
    real(dp), intent(in) :: ac
        !! Cathodic transfer coefficient.
    real(dp), intent(in) :: za
        !! Number of exchnaged electrons in the anodic branch.
    real(dp), intent(in) :: zc
        !! Number of exchnaged electrons in the cathodic branch.
    real(dp), intent(in) :: A
        !! Area in cm2.
    real(dp), intent(in) :: T
        !! Temperature in °C.

    real(dp) :: I, kTe_, num, denom

    kTe_ = kTe(T)
    
    num = sbv(U, OCV, j0, aa, ac, za, zc, 1.0_dp, T)
    denom = 1 + j0 / jdla * exp(aa * za * (U - OCV) / kTe_) + j0 / jdlc * exp(-ac * zc * (U - OCV) / kTe_);

    I = A * num / denom;

end function

end module
