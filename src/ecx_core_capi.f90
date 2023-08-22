module ecx__core_capi
    !! C API for the core module.
    use iso_c_binding, only : c_double
    use ecx__core
    implicit none

    real(c_double), protected, bind(C, name="ecx_core_capi_PI") :: &
    ecx_core_capi_PI = ecx_PI

end module