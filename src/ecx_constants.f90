module ecx__constants
    !! Module for constants used in the ECX library.
    use iso_fortran_env, only : real64
    implicit none
    
    real(real64), parameter :: PI = 4.0d0*datan(1.0d0) !! PI

end module