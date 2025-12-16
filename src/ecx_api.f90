! NAME
!     ecx_api - API for the libray.
! 
! SYNOPSIS
!     use ecx
! 
! DESCRIPTION
!     Fortran API for the library.
!     The API is accessed by importing the library.
! 
! EXAMPLE
!     Minimal program:
! 
!         program example
!             use ecx
!         end program
! 
! SEE ALSO
!     complex(7), ecx(3)
module ecx__api
    use ecx__version, only: version
    implicit none
    private

    character(len=:), allocatable, target :: version_f

    public :: get_version

contains

!> @brief Get version
!! @return fptr
function get_version()result(fptr)
    !! Get the version.
    implicit none

    !! Returns
    character(len=:), pointer :: fptr
        !! Pointer to the version string.

    if(allocated(version_f))then
        deallocate(version_f)
    endif
    allocate(character(len=len(version)) :: version_f)
    version_f = version
    fptr => version_f
end function

end module ecx__api
