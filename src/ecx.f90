! SPDX-License-Identifier: MIT

!=======================================================================
! MODULE: ECX
!=======================================================================
module ecx
!! Main module for ecx.
use ecx__api
use ecx__capi
implicit none(type,external)
private

character(len=*), parameter :: v = "0.1.0"
character(len=:), allocatable, target :: vf
character(len=:), allocatable, target :: vc


!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
! PUBLIC
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
public :: version, capi_version
public :: kTe, z, mm
public :: sbv, bv, nernst
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


contains
!-----------------------------------------------------------------------
! FUNCTION: VERSION()
!-----------------------------------------------------------------------
function version()result(fptr)
!! Get the version.
character(len=:), pointer :: fptr !! Pointer to a string (=>version).
if(allocated(vf))then
    deallocate(vf)
endif
allocate(character(len=len(v)) :: vf)
vf = v
fptr => vf
end function version
!-----------------------------------------------------------------------
function capi_version()bind(C,name="iapws_version")result(cptr)
!! C API - Get the version
type(c_ptr) :: cptr !! C pointer to a string indicating the version.
character(len=:), pointer :: fptr
fptr => version()
if(allocated(vc))then
    deallocate(vc)
endif
allocate(character(len=len(fptr)+1) :: vc)
vc = fptr // c_null_char
cptr = c_loc(vc)
end function capi_version
!-----------------------------------------------------------------------

end module
