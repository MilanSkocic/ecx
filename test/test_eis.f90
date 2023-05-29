program test_eis_r
    use iso_fortran_env
    use ecx, only : ecx_eis_zr
    implicit none

    real(real64) :: w = 1.0d0
    complex(real64) :: Z
    real(real64) :: r = 100.0d0

    real(real64) :: Zreal, Zimag

    Z = ecx_eis_zr(w, r)

    Zreal = real(Z, kind=kind(r))
    Zimag = aimag(Z)

    print "(A10, SP, ES23.16)", "Zreal=", Zreal
    print "(A10, SP, ES23.16)", "Zimag=", Zreal




end program