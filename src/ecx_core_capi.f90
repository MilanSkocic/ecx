module ecx__core_capi
    !! C API for the core module.
    use iso_c_binding, only : c_double
    use ecx__core
    implicit none

    real(c_double), protected, bind(C, name="ecx_core_capi_PI") :: &
    ecx_core_capi_PI = ecx_core_PI
    real(c_double), protected, bind(C, name="T_K") :: &
    ecx_core_capi_T_K = ecx_core_T_K

contains    

pure subroutine ecx_core_capi_nm2eV(lambda, E, n)bind(C)
    !! Convert wavelength to energy
    implicit none
    integer(c_size_t), intent(in), value :: n
        !! Size of lambda and E.
    real(c_double), intent(in) :: lambda(n)
        !! Wavelength in nm.
    real(c_double), intent(inout) :: E(n)
        !! Energy in eV.
    E = ecx_nm2eV(lambda)

end subroutine

pure subroutine ecx_core_capi_kTe(T, kTe, n)bind(C)
    !! Compute the thermal voltage.
    integer(c_size_t), intent(in), value :: n
        !! Size of T and kTe.
    real(c_double), intent(in) :: T(n)
        !! Temperature in °C.
    real(c_double), intent(inout) :: kTe(n)
        !! Thermal voltage in V.

    kTe = ecx_core_kTe(T)

end subroutine

end module