module cecx__version
    !! version
    use iso_c_binding, only: c_loc, c_ptr, c_null_char
    use ecx__version, only: get_version
    implicit none
    private

    character(len=:), allocatable, target :: version_c
    
    public :: cecx_get_version

contains

function cecx_get_version()bind(c)result(cptr)
    !! Get the version.
    implicit none
    
    ! Returns   
    type(c_ptr) :: cptr
        !! Pointer to version string.

    character(len=:), pointer :: fptr
    fptr => get_version() 

    if(allocated(version_c))then
        deallocate(version_c)
    endif
    allocate(character(len=len(fptr)+1) :: version_c)

    version_c = fptr // c_null_char
    cptr = c_loc(fptr)
end function

end module cecx__version
