module ecx__kinetics
    !! Module for computing kinetics using the Butler-Volmer equations.
    use iso_fortran_env
    use codata
    use ecx__core
    implicit none
    private

    public :: ecx_kinetics_nernst
    public :: ecx_kinetics_sbv, ecx_kinetics_bv

contains

pure function ecx_kinetics_nernst(E0, z, aox, vox, ared, vred, T)result(E)
    !! Compute the Nernst electrochemical potential in V.
    implicit none
    real(real64), intent(in) :: E0
        !! Standard electrochemical potential in V.
    integer(int32), intent(in) :: z
        !! Number of exchanged electrons.
    real(real64), intent(in) :: aox(:)
        !! Activities of the oxidants.
    real(real64), intent(in) :: vox(:)
        !! Coefficients for the oxidants.
    real(real64), intent(in) :: ared(:)
        !! Activities of the reductants
    real(real64), intent(in) :: vred(:)
        !! Coefficients for the reductants.
    real(real64), intent(in) :: T
        !! Temperature in °C.

    real(real64) :: E, ox, red, kTe
    
    kTe = ecx_core_kTe(T)
    ox = product(aox**vox)
    red = product(ared**vred)

    E = E0 + kTe/z * log(ox/red)

end function

pure elemental function ecx_kinetics_sbv(U, OCV, j0, aa, ac, za, zc, A, T)result(I)
    !! Compute Butler Volmer equation without mass transport.
    real(real64), intent(in) :: OCV
        !! Open Circuit Voltage in V.
    real(real64), intent(in) :: U
        !! Electrochemical potential in V.
    real(real64), intent(in) :: j0
        !! Exchange current density in A.cm-2.
    real(real64), intent(in) :: aa
        !! Anodic transfer coefficient.
    real(real64), intent(in) :: ac
        !! Cathodic transfer coefficient.
    real(real64), intent(in) :: za
        !! Number of exchnaged electrons in the anodic branch.
    real(real64), intent(in) :: zc
        !! Number of exchnaged electrons in the cathodic branch.
    real(real64), intent(in) :: A
        !! Area in cm2.
    real(real64), intent(in) :: T
        !! Temperature in °C.

    real(real64) :: I

    real(real64) :: kTe
    
    kTe = ecx_core_kTe(T)

    I = A * j0 * (exp(aa * za * (U - OCV) / kTe) - exp(-ac * zc * (U - OCV) / kTe));
end function

pure elemental function ecx_kinetics_bv(U, OCV, j0, jdla, jdlc, aa, ac, za, zc, A, T)result(I)
    !! Compute Butler Volmer equation with mass transport.
    implicit none
    real(real64), intent(in) :: OCV
        !! Open Circuit Voltage in V.
    real(real64), intent(in) :: U
        !! Electrochemical potential in V.
    real(real64), intent(in) :: j0
        !! Exchange current density in A.cm-2.
    real(real64), intent(in) :: jdla
        !! Anodic diffusion limiting current density in A.cm-2.
    real(real64), intent(in) :: jdlc
        !! Cathodic diffusion limiting current density in A.cm-2.
    real(real64), intent(in) :: aa
        !! Anodic transfer coefficient.
    real(real64), intent(in) :: ac
        !! Cathodic transfer coefficient.
    real(real64), intent(in) :: za
        !! Number of exchnaged electrons in the anodic branch.
    real(real64), intent(in) :: zc
        !! Number of exchnaged electrons in the cathodic branch.
    real(real64), intent(in) :: A
        !! Area in cm2.
    real(real64), intent(in) :: T
        !! Temperature in °C.

    real(real64) :: I, kTe, num, denom

    kTe = ecx_core_kTe(T)
    
    num = ecx_kinetics_sbv(U, OCV, j0, aa, ac, za, zc, 1.0d0, T)
    denom = 1 + j0 / jdla * exp(aa * za * (U - OCV) / kTe) + j0 / jdlc * exp(-ac * zc * (U - OCV) / kTe);

    I = A * num / denom;

end function

end module