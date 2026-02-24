module testsuite__eis
    use testdrive, only : new_unittest, unittest_type, error_type, check
    use ecx__common
    use ecx
    implicit none

    
    public :: collect_suite_eis

contains

subroutine collect_suite_eis(testsuite)
    implicit none
    type(unittest_type), allocatable, intent(out) :: testsuite(:)
    testsuite = [new_unittest('test zr', test_zr), &
                 new_unittest('test zc', test_zc), &
                 new_unittest('test zl', test_zl) &
                 ]
end subroutine

subroutine test_zr(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 

    integer(int32) :: errstat
    character(len=:), pointer :: errmsg
    real(dp) :: w(1) = 1.0d0
    real(dp) :: p(3) = [100.0d0, 0.0d0, 0.0d0]
    complex(dp) :: zv(1)
    complex(dp) :: value, expected

    call z(p, w, zv, "R", errstat, errmsg)
    value = zv(1)
    expected = (100.0d0, 0.0d0)

    call check(error, value*1d-2, expected*1d-2, thr=1d-16)
    if (allocated(error)) return
end subroutine

subroutine test_zc(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 

    integer(int32) :: errstat
    character(len=:), pointer :: errmsg
    real(dp) :: w(1) = 0.01d0
    real(dp) :: p(3) = [100.0d0, 0.0d0, 0.0d0]
    complex(dp) :: zv(1)
    complex(dp) :: value, expected

    call z(p, w, zv, "C", errstat, errmsg)
    value = zv(1)
    expected = (0.0d0, -1.0d0)

    call check(error, value, expected, thr=1d-16)
    if (allocated(error)) return

end subroutine

subroutine test_zl(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 

    integer(int32) :: errstat
    character(len=:), pointer :: errmsg
    real(dp) :: w(1) = 0.010d0
    real(dp) :: p(3) = [100.0d0, 0.0d0, 0.0d0]
    complex(dp) :: zv(1)
    complex(dp) :: value, expected

    call z(p, w, zv, "L", errstat, errmsg)
    value = zv(1)
    expected = (0.0d0, 1.0d0)

    call check(error, value, expected, thr=1d-16)
    if (allocated(error)) return
end subroutine

end module
