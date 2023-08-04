module ecx__kinetics
    !! Module for computing kinetics using the Butler-Volmer equations.
    use iso_fortran_env
    use codata
    implicit none
    private

    real(real64), parameter :: T_K=273.15d0 !! 0°C in Kelvin.

    public :: ecx_kinetics_sbv

contains

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
    
    kTe = BOLTZMANN_CONSTANT * (T+T_K) / ELECTRON_VOLT

    I = A * j0 * (exp(aa * za * (U - OCV) / kTe) - exp(-ac * zc * (U - OCV) / kTe));
end function

end module