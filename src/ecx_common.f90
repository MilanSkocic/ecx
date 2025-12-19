module ecx__common
    use stdlib_kinds, only: int64, dp, int32, sp
    use stdlib_optval, only: optval
    use stdlib_codata, only: PLANCK_CONSTANT_IN_EV_HZ, &
                      SPEED_OF_LIGHT_IN_VACUUM, &
                      BOLTZMANN_CONSTANT_IN_EV_K
    use stdlib_constants, only: PI_dp
    use ieee_arithmetic, only: ieee_quiet_nan, ieee_value
    private

    
    real(dp), parameter :: T_K=273.15_dp !< 0°C in Kelvin.
    real(dp), parameter :: kB_eV = BOLTZMANN_CONSTANT_IN_EV_K%value !< kB

    public :: T_K, kB_eV
    public :: optval
    public :: sp, dp, int32, int64
end module
