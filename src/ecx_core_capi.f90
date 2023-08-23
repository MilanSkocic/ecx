module ecx__core_capi
    !! C API for the core module.
    use iso_c_binding, only : c_double
    use ecx__core
    implicit none

    real(c_double), protected, bind(C, name="ecx_core_capi_PI") :: &
    ecx_core_capi_PI = ecx_PI

contains    

subroutine dummy()bind(C)
    implicit none
    print *, "hello"
end subroutine 

subroutine ecx_core_capi_nm2eV(lambda, E, n)bind(C)
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

end module