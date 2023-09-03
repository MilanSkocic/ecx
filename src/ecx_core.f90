module ecx__core
    !! Module for constants and utilities functions used in the ECX library.
    use iso_fortran_env
    use ieee_arithmetic
    use codata
    use stdlib_math
    implicit none
    
    real(real64), parameter :: ecx_core_PI = 4.0d0*datan(1.0d0) !! PI
    real(real64), parameter :: ecx_core_T_K=273.15d0 !! 0°C in Kelvin.

contains

pure elemental function ecx_core_roundn(x, n)result(r)
    !! Round x to n digits.
    implicit none
    real(real64), intent(in) :: x
        !! Number to be rounded.
    integer(int32), intent(in) :: n
        !! Number of digits.s
    real(real64) :: r
        !! Rounded number
    real(real64) :: fac

    fac = 10**n
    r = nint(x*fac, kind=kind(x)) / fac
end function

function ecx_core_assertEqual(x1, x2, n)result(r)
    !! Assert if two numbers are equal.
    implicit none
    real(real64), intent(in) :: x1
        !! First number to be compared.
    real(real64), intent(in) :: x2
        !! Second number to be compared.
    integer(int32), intent(in) :: n
        !! Number of digits.
    logical :: r
        !! Comparison result.

    real(real64) :: fac
    real(real64) :: ix1
    real(real64) :: ix2
    
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
    real(real64), intent(in) :: start
        !! Starting value.
    real(real64), intent(in) :: end
        !! Ending value (included).
    integer(int32), intent(out) :: x(:)
        !! 1d-array where to put the linear spaced values.

    real(real64) :: dx
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
    real(real64), intent(in) :: start
        !! Starting value.
    real(real64), intent(in) :: end
        !! Ending value (included).
    integer(int32), intent(out) :: x(:)
        !! 1d-array where to put the log spaced values.

    call ecx_core_linspace(start, end, x)

    x(:) = 10.0d0**x(:)

end subroutine

pure elemental function ecx_core_nm2eV(lambda)result(E)
    !! Convert wavelength to energy
    implicit none
    real(real64), intent(in) :: lambda
        !! Wavelength in nm.
    real(real64) :: E
        !! Energy in eV.

    E = PLANCK_CONSTANT_IN_EV_HZ * SPEED_OF_LIGHT_IN_VACUUM / (lambda*1.0d-9)

end function

pure elemental function ecx_core_eV2nm(E)result(lambda)
    !! Convert wavelength to energy
    implicit none
    real(real64), intent(in) :: E
        !! Energy in eV.
    real(real64) :: lambda
        !! Wavelength in nm.

    lambda = PLANCK_CONSTANT_IN_EV_HZ * SPEED_OF_LIGHT_IN_VACUUM / (E * 1.0d-9)

end function

pure elemental function ecx_core_deg2rad(theta)result(phase)
    !! Converts degrees to rad.
    implicit none
    real(real64), intent(in) :: theta
        !! Angle in degrees.
    real(real64) :: phase
        !! Angle in rad.
    phase = theta * ecx_core_PI / 180.0d0
end 

pure elemental function ecx_core_rad2deg(phase)result(theta)
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