module testsuite__core
    use stdlib_kinds, only: dp
    use testdrive, only : new_unittest, unittest_type, error_type, check
    use ecx__common
    use ecx__core
    implicit none
    
    public :: collect_suite_core

contains

subroutine collect_suite_core(testsuite)
    implicit none
    type(unittest_type), allocatable, intent(out) :: testsuite(:)
    testsuite = [new_unittest("PI", test_pi)]
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

end module
