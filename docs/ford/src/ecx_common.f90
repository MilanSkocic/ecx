module ecx__common
    !! Common module for ecx.
    use ieee_arithmetic
    use iso_c_binding, only: c_size_t, &
                             c_int,    &
                             c_double, &
                             c_double_complex, &
                             c_char,   &
                             c_ptr,    &
                             c_null_char, &
                             c_loc
    use stdlib_kinds, only: int64, dp, int32, sp
    use stdlib_optval, only: optval
    use stdlib_codata, only: PLANCK_CONSTANT_IN_EV_HZ, &
                      SPEED_OF_LIGHT_IN_VACUUM, &
                      BOLTZMANN_CONSTANT_IN_EV_K
    use stdlib_constants, only: PI_dp
    use stdlib_math, only: linspace, logspace
    
    real(dp), parameter :: PI = PI_dp !< PI
    real(dp), parameter :: T_K=273.15_dp !< 0°C in Kelvin.
    real(dp), parameter :: kB_eV = BOLTZMANN_CONSTANT_IN_EV_K%value !< kB
    real(dp), parameter :: h_eV = PLANCK_CONSTANT_IN_EV_HZ%value 
    real(dp), parameter :: c = SPEED_OF_LIGHT_IN_VACUUM%value
    
    real(c_double), bind(C, name="ecx_core_PI") :: &
    capi_PI = PI
    real(c_double), bind(C, name="ecx_core_T_K") :: &
    capi_T_K = T_K

end module
