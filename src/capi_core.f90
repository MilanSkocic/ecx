module ecx__capi_core
    use iso_c_binding, only: c_double, c_size_t
    use ecx__core, only: nm2eV, kTe
    implicit none

contains

pure subroutine capi_nm2eV(lambda, E, n)bind(C, name="ecx_core_nm2eV")
    !! Convert wavelength to energy

    integer(c_size_t), intent(in), value :: n
        !! Size of lambda and E.
    real(c_double), intent(in) :: lambda(n)
        !! Wavelength in nm.
    real(c_double), intent(out) :: E(n)
        !! Energy in eV.
    E = nm2eV(lambda)

end subroutine

pure subroutine capi_kTe(T, kTe_, n)bind(C, name="ecx_core_kTe")
    !! Compute the thermal voltage.
    
    integer(c_size_t), intent(in), value :: n
        !! Size of T and kTe.
    real(c_double), intent(in) :: T(n)
        !! Temperature in °C.
    real(c_double), intent(out) :: kTe_(n)
        !! Thermal voltage in V.

    kTe_ = kTe(T)

end subroutine

end module
