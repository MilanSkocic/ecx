module ecx__core
    !! Module for constants and utilities functions used in the ECX library.
    use iso_fortran_env, only : real64
    use codata
    implicit none
    
    real(real64), parameter :: ecx_core_PI = 4.0d0*datan(1.0d0) !! PI
    real(real64), parameter :: ecx_core_T_K=273.15d0 !! 0°C in Kelvin.

contains

pure elemental function ecx_nm2eV(lambda)result(E)
    !! Convert wavelength to energy
    implicit none
    real(real64), intent(in) :: lambda
        !! Wavelength in nm.
    real(real64) :: E
        !! Energy in eV.

    E = PLANCK_CONSTANT_IN_EV_HZ * SPEED_OF_LIGHT_IN_VACUUM / (lambda*1.0d-9)

end function

pure elemental function ecx_eV2nm(E)result(lambda)
    !! Convert wavelength to energy
    implicit none
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
    phase = theta * ecx_core_PI / 180.0d0
end 

pure elemental function ecx_rad2deg(phase)result(theta)
    !! Converts degrees to rad.
    implicit none
    real(real64), intent(in) :: phase
        !! Angle in rad.
    real(real64) :: theta
        !! Angle in degrees.
    theta = phase * 180.0d0 / ecx_core_PI
end 

pure elemental function ecx_core_kTe(T)result(r)
    !! Compute the thermal voltage.
    implicit none
    real(real64), intent(in) :: T
        !! Temperature in °C.
    real(real64) :: r
        !! Thermal voltage in V.
    
    r = (T+ecx_core_T_K) * BOLTZMANN_CONSTANT_IN_EV_K

end function

end module