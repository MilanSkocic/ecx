module testsuite__core
    use stdlib_kinds, only: dp
    use testdrive, only : new_unittest, unittest_type, error_type, check
    use ecx__common
    use ecx__core
    use ecx
    implicit none
    
    public :: collect_suite_core

contains

subroutine collect_suite_core(testsuite)
    implicit none
    type(unittest_type), allocatable, intent(out) :: testsuite(:)
    testsuite = [new_unittest('PI', test_pi), &
                 new_unittest('nm2eV', test_nm2eV), &
                 new_unittest('eV2nm', test_eV2nm), &
                 new_unittest('rad2deg', test_rad2deg), &
                 new_unittest('deg2rad', test_deg2rad), &
                 new_unittest('kTe', test_kTe) &
                 ]
end subroutine


subroutine test_pi(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    real(dp) :: value, expected

    value = PI
    expected = 3.1416d0
    
    call check(error, value, expected, thr=1d-4)
    if (allocated(error)) return
end subroutine


subroutine test_nm2eV(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    real(dp) :: value, expected

    value = nm2eV(1.0d0)
    expected = 1239.84d0

    call check(error, value*1d-3, expected*1d-3, thr=1d-5)
    if (allocated(error)) return

end subroutine


subroutine test_eV2nm(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    real(dp) :: value, expected

    value = eV2nm(1239.84d0)
    expected = 1.0d0

    call check(error, value, expected, thr=1d-5)
    if (allocated(error)) return
end subroutine


subroutine test_deg2rad(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    real(dp) :: value, expected

    value = deg2rad(180.0d0)
    expected = PI

    call check(error, value, expected, thr=1d-16)
    if (allocated(error)) return
end subroutine


subroutine test_rad2deg(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    real(dp) :: value, expected

    value = rad2deg(PI)
    expected = 180.0d0
    
end subroutine


subroutine test_kTe(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    real(dp) :: value, expected

    value = kTe(25.0d0)
    expected = 25.69d-3

    call check(error, value*1d-2, expected*1d-2, thr=1d-3)
    if (allocated(error)) return
end subroutine

end module
