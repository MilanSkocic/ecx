module ecx_constants
    use codata
    implicit none
    private

    real(real64), parameter, public :: c = speed_of_light_in_vacuum
    real(real64), parameter, public :: PI = 3.141592653589793238462643383279502884d0

end module