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

subroutine test_zr()
    implicit none

    integer(int32) :: errstat
    real(real64) :: w(1) = 1.0d0
    real(real64) :: p(3) = [100.0d0, 0.0d0, 0.0d0]
    complex(real64) :: z(1)
    complex(real64) :: value
    complex(real64) :: expected = (100.0d0, 0.0d0)
    complex(real64) :: diff

    write(*, "(4X, A)", advance="no") "Z_R..."
    
    call ecx_eis_z(p, w, z, "R", errstat)
    value = z(1)
    diff = value - expected
    if((.not. ecx_core_assertEqual(diff%re, 0.0d0, 16)) .or. (.not. ecx_core_assertEqual(diff%im, 0.0d0, 16)))then
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

    integer(int32) :: errstat
    real(real64) :: w(1) = 0.01d0
    real(real64) :: p(3) = [100.0d0, 0.0d0, 0.0d0]
    complex(real64) :: z(1)
    complex(real64) :: value
    complex(real64) :: expected = (0.0d0, -1.0d0)
    complex(real64) :: diff

    write(*, "(4X, A)", advance="no") "Z_C..."
    
    call ecx_eis_z(p, w, z, "C", errstat)
    value = z(1)
    diff = value - expected
    if((.not. ecx_core_assertEqual(diff%re, 0.0d0, 16)) .or. (.not. ecx_core_assertEqual(diff%im, 0.0d0, 16)))then
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

    integer(int32) :: errstat
    real(real64) :: w(1) = 0.010d0
    real(real64) :: p(3) = [100.0d0, 0.0d0, 0.0d0]
    complex(real64) :: z(1)
    complex(real64) :: value
    complex(real64) :: expected = (0.0d0, 1.0d0)
    complex(real64) :: diff

    write(*, "(4X, A)", advance="no") "Z_L..."
    
    call ecx_eis_z(p, w, z, "L", errstat)
    value = z(1)
    diff = value - expected
    if((.not. ecx_core_assertEqual(diff%re, 0.0d0, 16)) .or. (.not. ecx_core_assertEqual(diff%im, 0.0d0, 16)))then
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