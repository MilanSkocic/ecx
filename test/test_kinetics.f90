program test_eis
    use iso_fortran_env
    use codata
    use ecx
    implicit none
    
    print "(A)", "***** TESTING FORTRAN CODE FOR KINETICS *****"
    call test_sbv()
    call test_bv()
    call test_nernst()

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
    U = 10*BOLTZMANN_CONSTANT_IN_EV_K * (T+273.15d0)
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

subroutine test_bv()
    implicit none

    real(real64) :: U = 0.0d0
    real(real64) :: OCV = 0.0d0
    real(real64) :: j0 = 1.0d-6
    real(real64) :: jdla = 1.0d-5
    real(real64) :: jdlc = -1.0d-5
    real(real64) :: aa = 0.5d0
    real(real64) :: ac = 0.5d0
    real(real64) :: za = 1.0d0
    real(real64) :: zc = 1.0d0
    real(real64) :: A =1.0d0
    real(real64) :: T = 25.0d0
    real(real64) :: value
    real(real64) :: expected = 0.0d0
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "bv..."
    U = 50*BOLTZMANN_CONSTANT_IN_EV_K * (T+273.15d0)
    expected = jdla
    value = ecx_kinetics_bv(U, OCV, j0, jdla, jdlc, aa, ac, za, zc, A, T)
    diff = value - expected
    if(.not. ecx_core_assertEqual(diff, 0.0d0, 16))then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X,SP,ES23.16,2X,ES23.16,2X,ES23.16)", advance="yes") value, expected, diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif

end subroutine

subroutine test_nernst()
    implicit none

    real(real64) :: E0
    integer(int32) :: z
    real(real64) :: aox(3) = [1.0d0, 1.0d0, 1.0d0]
    real(real64) :: vox(3) = [1.0d0, 1.0d0, 1.0d0]
    real(real64) :: ared(3) = [1.0d0, 1.0d0, 1.0d0]
    real(real64) :: vred(3) = [1.0d0, 1.0d0, 1.0d0]
    real(real64) :: T = 25.0d0
    real(real64) :: value
    real(real64) :: expected
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "nernst..."
    E0 = 0.1d0
    z = 1
    expected = E0
    value = ecx_kinetics_nernst(E0, z, aox, vox, ared, vred, T)
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