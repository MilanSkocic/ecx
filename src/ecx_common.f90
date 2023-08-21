module ecx__common
    !! Module for constants and utilities functions used in the ECX library.
    use iso_fortran_env, only : real64
    use codata
    implicit none
    
    real(real64), protected :: ecx_PI = 4.0d0*datan(1.0d0) !! PI

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

pure elemental function ecx_deg2rad(theta)result(phase)
    !! Converts degrees to rad.
    implicit none
    real(real64), intent(in) :: theta
        !! Angle in degrees.
    real(real64) :: phase
        !! Angle in rad.
    phase = theta * ecx_PI / 180.0d0
end 

pure elemental function ecx_rad2deg(phase)result(theta)
    !! Converts degrees to rad.
    implicit none
    real(real64), intent(in) :: phase
        !! Angle in rad.
    real(real64) :: theta
        !! Angle in degrees.
    theta = phase * 180.0d0 / ecx_PI
end 

end module