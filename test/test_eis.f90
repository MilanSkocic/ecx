program test_eis
    use iso_fortran_env
    use ieee_arithmetic
    use ecx
    implicit none
    
    print "(A)", "***** TESTING FORTRAN CODE FOR EIS *****"

    call test_zr()
    call test_zc()
    call test_zl()

contains

pure elemental function roundn(x, n)result(r)
    implicit none
    real(real64), intent(in) :: x
    integer(int32), intent(in) :: n
    real(real64) :: r
    real(real64) :: fac

    fac = 10**n
    r = nint(x*fac, kind=kind(x)) / fac
end function

 function assertEqual(x1, x2, n)result(r)
    implicit none
    real(real64), intent(in) :: x1
    real(real64), intent(in) :: x2
    integer(int32), intent(in) :: n
    logical :: r

    real(real64) :: fac
    real(real64) :: ix1
    real(real64) :: ix2
    
    if(ieee_is_nan(x1) .or. ieee_is_nan(x2))then
        r = .false.
    else
        fac = 10**n
        ix1 = nint(x1 * fac, kind=kind(n))
        ix2 = nint(x2 * fac, kind=kind(n))
        r = ix1 == ix2
    endif
end function

subroutine test_zr()
    implicit none

    real(real64) :: w(1) = 1.0d0
    real(real64) :: p(1) = 100.0d0
    complex(real64) :: z(1)
    complex(real64) :: value
    complex(real64) :: expected = (100.0d0, 0.0d0)
    complex(real64) :: diff

    write(*, "(4X, A)", advance="no") "Z_R..."
    
    call ecx_eis_z("R", p, w, z)
    value = z(1)
    diff = value - expected
    if((.not. assertEqual(diff%re, 0.0d0, 16)) .or. (.not. assertEqual(diff%im, 0.0d0, 16)))then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X,SP,ES23.16,2X,ES23.16)", advance="yes") value%re, value%im
        write(*, "(4X,SP,ES23.16,2X,ES23.16)", advance="yes") expected%re, expected%im
        write(*, "(4X,SP,ES23.16,2X,ES23.16)", advance="yes") diff%re, diff%im
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif

end subroutine

subroutine test_zc()
    implicit none

    real(real64) :: w(1) = 0.01d0
    real(real64) :: p(1) = 100.0d0
    complex(real64) :: z(1)
    complex(real64) :: value
    complex(real64) :: expected = (0.0d0, -1.0d0)
    complex(real64) :: diff

    write(*, "(4X, A)", advance="no") "Z_C..."
    
    call ecx_eis_z("C", p, w, z)
    value = z(1)
    diff = value - expected
    if((.not. assertEqual(diff%re, 0.0d0, 16)) .or. (.not. assertEqual(diff%im, 0.0d0, 16)))then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X,SP,ES23.16,2X,ES23.16)", advance="yes") value%re, value%im
        write(*, "(4X,SP,ES23.16,2X,ES23.16)", advance="yes") expected%re, expected%im
        write(*, "(4X,SP,ES23.16,2X,ES23.16)", advance="yes") diff%re, diff%im
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif

end subroutine

subroutine test_zl()
    implicit none

    real(real64) :: w(1) = 0.010d0
    real(real64) :: p(1) = 100.0d0
    complex(real64) :: z(1)
    complex(real64) :: value
    complex(real64) :: expected = (0.0d0, 1.0d0)
    complex(real64) :: diff

    write(*, "(4X, A)", advance="no") "Z_L..."
    
    call ecx_eis_z("L", p, w, z)
    value = z(1)
    diff = value - expected
    if((.not. assertEqual(diff%re, 0.0d0, 16)) .or. (.not. assertEqual(diff%im, 0.0d0, 16)))then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X,SP,ES23.16,2X,ES23.16)", advance="yes") value%re, value%im
        write(*, "(4X,SP,ES23.16,2X,ES23.16)", advance="yes") expected%re, expected%im
        write(*, "(4X,SP,ES23.16,2X,ES23.16)", advance="yes") diff%re, diff%im
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif

end subroutine

end program