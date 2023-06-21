program test_eis
    use iso_fortran_env
    use ecx
    implicit none
    
    print "(A)", "***** TESTING FORTRAN CODE FOR EIS *****"

    call test_zr()

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
    
    fac = 10**n
    ix1 = nint(x1 * fac, kind=kind(n))
    ix2 = nint(x2 * fac, kind=kind(n))
    r = ix1 == ix2
end function

subroutine test_zr()
    implicit none

    real(real64) :: w = 1.0d0
    real(real64) :: r = 100.0d0
    complex(real64) :: value
    complex(real64) :: expected = (100.0d0, 0.0d0)
    complex(real64) :: diff

    write(*, "(4X, A)", advance="no") "Z_R..."
    
    value = ecx_eis_zr(w, r)
    diff = value - expected
    if((.not. assertEqual(diff%re, 0.0d0, 16)) .or. (.not. assertEqual(diff%im, 0.0d0, 16)))then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X,SP,ES23.16,2X,ES23.16,/4X,ES23.16,2X,ES23.16,/4X,ES23.16,2X,ES23.16)", advance="yes") &
        value%re, value%im, expected%re, expected%im, diff%re, diff%im
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif

end subroutine

end program