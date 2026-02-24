module testsuite__kinetics
    use testdrive, only : new_unittest, unittest_type, error_type, check
    use ecx__common
    use ecx
    implicit none
    
    public :: collect_suite_kinetics

contains

subroutine collect_suite_kinetics(testsuite)
    implicit none
    type(unittest_type), allocatable, intent(out) :: testsuite(:)
    testsuite = [new_unittest('test sbv', test_sbv), &
                 new_unittest('test bv', test_bv), &
                 new_unittest('test nernst', test_nernst) &
                 ]
end subroutine

subroutine test_sbv(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 

    real(dp) :: U = 0.0d0
    real(dp) :: OCV = 0.0d0
    real(dp) :: j0 = 1.0d-6
    real(dp) :: aa = 0.5d0
    real(dp) :: ac = 0.5d0
    real(dp) :: za = 1.0d0
    real(dp) :: zc = 1.0d0
    real(dp) :: A =1.0d0
    real(dp) :: T = 25.0d0
    real(dp) :: value, expected
    
    U = 10*BOLTZMANN_CONSTANT_IN_EV_K%value * (T+273.15d0)
    value = sbv(U, OCV, j0, aa, ac, za, zc, A, T)
    expected = j0*(exp(10*aa*za) - exp(-ac*zc*10))

    call check(error, value, expected, thr=1d-16)
    if (allocated(error)) return
end subroutine

subroutine test_bv(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 

    real(dp) :: U = 0.0d0
    real(dp) :: OCV = 0.0d0
    real(dp) :: j0 = 1.0d-6
    real(dp) :: jdla = 1.0d-5
    real(dp) :: jdlc = -1.0d-5
    real(dp) :: aa = 0.5d0
    real(dp) :: ac = 0.5d0
    real(dp) :: za = 1.0d0
    real(dp) :: zc = 1.0d0
    real(dp) :: A =1.0d0
    real(dp) :: T = 25.0d0
    real(dp) :: value, expected
    
    U = 100d0*BOLTZMANN_CONSTANT_IN_EV_K%value * (T+273.15d0)
    value = bv(U, OCV, j0, jdla, jdlc, aa, ac, za, zc, A, T)
    expected = jdla
    
    call check(error, value, expected, thr=1d-16)
    if (allocated(error)) return
end subroutine

subroutine test_nernst(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 

    real(dp) :: E0
    integer(int32) :: z
    real(dp) :: aox(3) = [1.0d0, 1.0d0, 1.0d0]
    real(dp) :: vox(3) = [1.0d0, 1.0d0, 1.0d0]
    real(dp) :: ared(3) = [1.0d0, 1.0d0, 1.0d0]
    real(dp) :: vred(3) = [1.0d0, 1.0d0, 1.0d0]
    real(dp) :: T = 25.0d0
    real(dp) :: value, expected
    
    E0 = 0.1d0
    z = 1d0
    value = nernst(E0, z, aox, vox, ared, vred, T)
    expected = E0
    
    call check(error, value*1d1, expected*1d1, thr=1d-16)
    if (allocated(error)) return
end subroutine

end module
