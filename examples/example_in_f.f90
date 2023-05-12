program example_in_f
    use iso_fortran_env
    use ecx_eis
    implicit none

    real(real64) :: w(3) = [1.0d0, 1.0d0, 100.0d0]
    real(real64) :: r = 100.0d0

    print *, ecx_eis_zr(w,r)
    

end program