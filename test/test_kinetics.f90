program test_eis
    use iso_fortran_env
    use codata
    use ecx
    implicit none
    
    print "(A)", "***** TESTING FORTRAN CODE FOR KINETICS *****"
    call test_sbv()

contains


subroutine test_sbv()
    implicit none

    real(real64) :: U = 0.0d0
    real(real64) :: OCV = 0.0d0
    real(real64) :: j0 = 1.0d-6
    real(real64) :: aa = 0.5d0
    real(real64) :: ac = 0.5d0
    real(real64) :: za = 1.0d0
    real(real64) :: zc = 1.0d0
    real(real64) :: A =1.0d0
    real(real64) :: T = 25.0d0
    real(real64) :: value
    real(real64) :: expected = 0.0d0
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "sbv..."
    U = 10*BOLTZMANN_CONSTANT * (T+273.15d0) / ELECTRON_VOLT
    expected = j0*(exp(10*aa*za) - exp(-ac*zc*10))
    value = ecx_kinetics_sbv(U, OCV, j0, aa, ac, za, zc, A, T)
    diff = value - expected
    if(.not. ecx_core_assertEqual(diff, 0.0d0, 16))then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X,SP,ES23.16,2X,ES23.16,2X,ES23.16)", advance="yes") value, expected, diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif

end subroutine
end program