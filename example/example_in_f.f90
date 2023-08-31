program example_in_f
    use iso_fortran_env
    use ecx
    implicit none

    real(real64) :: w(3) = [1.0d0, 1.0d0, 100.0d0]
    real(real64) :: r = 100.0d0
    real(real64) :: p(3) = 0.0d0
    character(len=1) :: e 
    integer :: errstat
    complex(real64) :: z(3)

    p(1) = r
    e = "R"
    call ecx_eis_z(p, w, z, e, errstat)
    print *, z
    

end program