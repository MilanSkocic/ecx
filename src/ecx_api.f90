! NAME
!     ecx_api - API for the libray.
! 
! SYNOPSIS
!     use ecx
! 
! DESCRIPTION
!     Fortran API.
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

!-------------------------------------------------------------------------------
! NAME
!     get_version - Get the version.
! 
! LIBRARY
!     Electrochemistry (libecx, -libecx)
! 
! SYNOPSIS
!     get_version()
! 
! DESCRIPTION
!     Get the version of library as Fortran pointer.
! 
! RETURN VALUE
!     The version as a character(len=:), pointer.
! 
! EXAMPLE
! 
!
function get_version()result(fptr)
    implicit none
    character(len=:), pointer :: fptr

    if(allocated(version_f))then
        deallocate(version_f)
    endif
    allocate(character(len=len(version)) :: version_f)
    version_f = version
    fptr => version_f
end function
!-------------------------------------------------------------------------------

end module ecx__api
