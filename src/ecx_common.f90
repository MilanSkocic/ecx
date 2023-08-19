module ecx__common
    !! Module for constants used in the ECX library.
    use iso_fortran_env, only : real64
    use codata
    implicit none
    
    real(real64), parameter :: PI = 4.0d0*datan(1.0d0) !! PI

contains

pure elemental function ecx_nm2eV(lambda)result(E)
    !! Convert wavelength to energy
    real(real64), intent(in) :: lambda
        !! Wavelength in nm.
    real(real64) :: E
        !! Energy in eV.

    E = PLANCK_CONSTANT_IN_EV_HZ * SPEED_OF_LIGHT_IN_VACUUM / (lambda*1.0d-9)

end function

pure elemental function ecx_eV2nm(E)result(lambda)
    !! Convert wavelength to energy
    real(real64), intent(in) :: E
        !! Energy in eV.
    real(real64) :: lambda
        !! Wavelength in nm.

    lambda = PLANCK_CONSTANT_IN_EV_HZ * SPEED_OF_LIGHT_IN_VACUUM / (E * 1.0d-9)

end function

end module