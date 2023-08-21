program test_eis
    use iso_fortran_env
    use ecx__core
    implicit none
    
    print "(A)", "***** TESTING FORTRAN CODE FOR CORE *****"
    call test_pi()
    call test_nm2eV()
    call test_eV2nm()
    call test_deg2rad()
    call test_rad2deg()

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

subroutine test_pi()
    implicit none

    real(real64) :: value
    real(real64) :: expected = 3.1416d0
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "PI..."
    value = ecx_PI
    diff = value - expected
    if(.not. assertEqual(diff, 0.0d0, 4))then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X,SP,ES23.16,2X,ES23.16,2X,ES23.16)", advance="yes") value, expected, diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif

end subroutine

subroutine test_nm2eV()
    implicit none

    real(real64) :: value
    real(real64) :: expected = 1239.84
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "nm2eV..."
    value = ecx_nm2eV(1.0d0)
    diff = value - expected
    if(.not. assertEqual(diff, 0.0d0, 2))then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X,SP,ES23.16,2X,ES23.16,2X,ES23.16)", advance="yes") value, expected, diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif

end subroutine

subroutine test_eV2nm()
    implicit none

    real(real64) :: value
    real(real64) :: expected = 1.0d0
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "eV2nm..."
    value = ecx_eV2nm(1239.84d0)
    diff = value - expected
    if(.not. assertEqual(diff, 0.0d0, 2))then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X,SP,ES23.16,2X,ES23.16,2X,ES23.16)", advance="yes") value, expected, diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif

end subroutine

subroutine test_deg2rad()
    implicit none

    real(real64) :: value
    real(real64) :: expected
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "deg2rad..."
    value = ecx_deg2rad(180.0d0)
    expected = ecx_PI
    diff = value - expected
    if(.not. assertEqual(diff, 0.0d0, 16))then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X,SP,ES23.16,2X,ES23.16,2X,ES23.16)", advance="yes") value, expected, diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif

end subroutine

subroutine test_rad2deg()
    implicit none

    real(real64) :: value
    real(real64) :: expected = 180.0d0
    real(real64) :: diff
    
    write(*, "(4X, A)", advance="no") "rad2deg..."
    value = ecx_rad2deg(ecx_PI)
    diff = value - expected
    if(.not. assertEqual(diff, 0.0d0, 16))then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X,SP,ES23.16,2X,ES23.16,2X,ES23.16)", advance="yes") value, expected, diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif

end subroutine


end program