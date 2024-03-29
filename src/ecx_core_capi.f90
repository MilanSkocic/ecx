module ecx__core_capi
    !! C API for the core module.
    use iso_c_binding, only : c_double, c_size_t
    use ecx__core
    implicit none
    private


contains    

pure subroutine ecx_core_capi_nm2eV(lambda, E, n)bind(C, name="ecx_core_capi_nm2eV")
    !! Convert wavelength to energy
    implicit none
    integer(c_size_t), intent(in), value :: n
        !! Size of lambda and E.
    real(c_double), intent(in) :: lambda(n)
        !! Wavelength in nm.
    real(c_double), intent(out) :: E(n)
        !! Energy in eV.
    E = ecx_core_nm2eV(lambda)

end subroutine

pure subroutine ecx_core_capi_kTe(T, kTe, n)bind(C, name="ecx_core_capi_kTe")
    !! Compute the thermal voltage.
    integer(c_size_t), intent(in), value :: n
        !! Size of T and kTe.
    real(c_double), intent(in) :: T(n)
        !! Temperature in °C.
    real(c_double), intent(out) :: kTe(n)
        !! Thermal voltage in V.

    kTe = ecx_core_kTe(T)

end subroutine

end module
