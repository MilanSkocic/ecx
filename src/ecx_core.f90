module ecx__core
    !! Core.
    use ecx__common
    private
    public :: roundn, assertEqual, nm2eV, deg2rad, rad2deg

contains

pure elemental function roundn(x, n)result(r)
    !! Round x to n digits.
    implicit none
    real(dp), intent(in) :: x !! Number to be rounded.
    integer(int32), intent(in) :: n !! Number of digits.s
    real(dp) :: r !! Rounded number
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
    real(dp), intent(in) :: theta !! Angle in degrees.
    real(dp) :: phase !! Angle in rad.
    phase = theta * PI / 180.0_dp
end 

pure elemental function rad2deg(phase)result(theta)
    !! Converts degrees to rad.
    implicit none
    real(dp), intent(in) :: phase !! Angle in rad.
    real(dp) :: theta !! Angle in degrees.
    theta = phase * 180.0_dp / PI
end 



end module
