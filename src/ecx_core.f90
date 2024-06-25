module ecx__core
    !! Core.
    use stdlib_kinds, only: dp, int32
    use iso_c_binding, only: c_ptr, c_loc, c_double, c_size_t
    use ieee_arithmetic
    use codata, only: PLANCK_CONSTANT_IN_EV_HZ, &
                      SPEED_OF_LIGHT_IN_VACUUM, &
                      BOLTZMANN_CONSTANT_IN_EV_K
    use stdlib_math, only: linspace, logspace
    implicit none
    private
    
    real(dp), parameter :: PI = 4.0d0*datan(1.0d0) !! PI
    real(dp), parameter :: T_K=273.15d0 !! 0°C in Kelvin.
    real(dp), parameter :: kB_eV = BOLTZMANN_CONSTANT_IN_EV_K%value
    real(dp), parameter :: h_eV = PLANCK_CONSTANT_IN_EV_HZ%value 
    real(dp), parameter :: c = SPEED_OF_LIGHT_IN_VACUUM%value
    
    real(c_double), bind(C, name="ecx_core_PI") :: &
    capi_PI = PI
    real(c_double), bind(C, name="ecx_core_T_K") :: &
    capi_T_K = T_K

public :: PI, T_K
public :: capi_PI, capi_T_K

public :: roundn, assertEqual, kTe, nm2eV, deg2rad, rad2deg

contains

pure elemental function roundn(x, n)result(r)
    !! Round x to n digits.
    implicit none
    real(dp), intent(in) :: x
        !! Number to be rounded.
    integer(int32), intent(in) :: n
        !! Number of digits.s
    real(dp) :: r
        !! Rounded number
    real(dp) :: fac

    fac = 10**n
    r = nint(x*fac, kind=kind(x)) / fac
end function

function assertEqual(x1, x2, n)result(r)
    !! Assert if two numbers are equal.
    implicit none
    real(dp), intent(in) :: x1
        !! First number to be compared.
    real(dp), intent(in) :: x2
        !! Second number to be compared.
    integer(int32), intent(in) :: n
        !! Number of digits.
    logical :: r
        !! Comparison result.

    real(dp) :: fac
    real(dp) :: ix1
    real(dp) :: ix2
    
    if(ieee_is_nan(x1) .or. ieee_is_nan(x2))then
        r = .false.
    else
        fac = 10**n
        ix1 = nint(x1 * fac, kind=kind(n))
        ix2 = nint(x2 * fac, kind=kind(n))
        r = ix1 == ix2
    endif
end function

pure subroutine ecx_core_linspace(start, end, x)
    !! Linear spaced 1d-array.
    real(dp), intent(in) :: start
        !! Starting value.
    real(dp), intent(in) :: end
        !! Ending value (included).
    integer(int32), intent(out) :: x(:)
        !! 1d-array where to put the linear spaced values.

    real(dp) :: dx
    integer(int32) :: n, i

    n = size(x)
    dx = (end - start) / (n-1)
    
    do i=1, n
        x(i) = start + dx * (i-1)
    end do
    x = linspace(start, end, size(x))
end subroutine

pure subroutine ecx_core_logspace(start, end, x)
    !! Log spaced 1d-array.
    real(dp), intent(in) :: start
        !! Starting value.
    real(dp), intent(in) :: end
        !! Ending value (included).
    integer(int32), intent(out) :: x(:)
        !! 1d-array where to put the log spaced values.

    x(:) = logspace(start, end, size(x))
end subroutine

pure elemental function nm2eV(lambda)result(E)
    !! Convert wavelength to energy
    implicit none
    real(dp), intent(in) :: lambda
        !! Wavelength in nm.
    real(dp) :: E
        !! Energy in eV.

    E = h_eV * c / (lambda*1.0d-9)
end function

pure subroutine capi_nm2eV(lambda, E, n)bind(C, name="ecx_core_nm2eV")
    !! Convert wavelength to energy
    implicit none
    integer(c_size_t), intent(in), value :: n
        !! Size of lambda and E.
    real(c_double), intent(in) :: lambda(n)
        !! Wavelength in nm.
    real(c_double), intent(out) :: E(n)
        !! Energy in eV.
    E = nm2eV(lambda)

end subroutine

pure elemental function eV2nm(E)result(lambda)
    !! Convert wavelength to energy
    implicit none
    real(dp), intent(in) :: E
        !! Energy in eV.
    real(dp) :: lambda
        !! Wavelength in nm.

    lambda = h_eV * c / (E * 1.0d-9)
end function

pure elemental function deg2rad(theta)result(phase)
    !! Converts degrees to rad.
    implicit none
    real(dp), intent(in) :: theta
        !! Angle in degrees.
    real(dp) :: phase
        !! Angle in rad.
    phase = theta * PI / 180.0d0
end 

pure elemental function rad2deg(phase)result(theta)
    !! Converts degrees to rad.
    implicit none
    real(dp), intent(in) :: phase
        !! Angle in rad.
    real(dp) :: theta
        !! Angle in degrees.
    theta = phase * 180.0d0 / PI
end 

pure elemental function kTe(T)result(r)
    !! Compute the thermal voltage.
    implicit none
    real(dp), intent(in) :: T
        !! Temperature in °C.
    real(dp) :: r
        !! Thermal voltage in V.
    
    r = (T+T_K) * kB_eV
end function

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
