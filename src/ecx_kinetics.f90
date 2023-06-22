module ecx__kinetics
    !! Module for computing kinetics using the Butler-Volmer equations.
    use iso_fortran_env
    use codata
    implicit none
    private

    real(real64), parameter :: T_K=273.15d0

contains

pure elemental function sbv(OCV, U, j0, aa, ac, za, zc, A, T)result(I)
    !! Compute Butler Volmer equation without mass transport.
    real(real64), intent(in) :: OCV
    real(real64), intent(in) :: U
    real(real64), intent(in) :: j0
    real(real64), intent(in) :: aa
    real(real64), intent(in) :: ac
    real(real64), intent(in) :: za
    real(real64), intent(in) :: zc
    real(real64), intent(in) :: A
    real(real64), intent(in) :: T

    real(real64) :: I

    real(real64) :: kTe
    
    kTe = BOLTZMANN_CONSTANT * (T+T_K) / ELECTRON_VOLT

    I = A * j0 * (exp(aa * za * (U - OCV) / kTe) - exp(-ac * zc * (U - OCV) / kTe));
end function

end module