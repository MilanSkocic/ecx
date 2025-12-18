module ecx__api
    use ecx__version, only: version
    implicit none
    private

    character(len=:), allocatable, target :: version_f

    public :: get_version


contains

! NAME
!     get_version - Get the version.
! 
! LIBRARY
!     Electrochemistry (libecx, -libecx)
! 
! SYNOPSIS
!     function get_version()result(fptr)
! 
! DESCRIPTION
!     Get the version of library.
! 
!     Parameters: None
! 
! RETURN VALUE
!     Returns a fortran pointer to deferred-length string.
! 
!     character(len=:), pointer :: fptr
! 
! EXAMPLE
! 
!     Minimal example
! 
!         print *, get_version()
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


end module ecx__api
