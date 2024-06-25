module capi__eis
    !! EIS: CAPI.
    use iso_c_binding, only: c_size_t, &
                             c_int,    &
                             c_double, &
                             c_double_complex, &
                             c_char,   &
                             c_ptr,    &
                             c_null_char, &
                             c_loc
    use ecx__eis
    implicit none
    
    character(len=:), allocatable, target :: errmsg_c

contains
    
subroutine capi_z(p, w, zout, e, k, n, errstat, errmsg)bind(C, name="ecx_eis_z")
    !! Compute the complex impedance for the given element.

    integer(c_size_t), intent(in), value :: n
        !! Size of w
    integer(c_size_t), intent(in), value :: k
        !! Size of p
    character(len=1,kind=c_char), intent(in), value :: e
        !! Electrochemical element: R, C, L, Q, O, T, G
    real(c_double), intent(in) :: p(k)
        !! Parameters.
    real(c_double), intent(in) :: w(n)
        !! Angular frequencies in rad.s-1
    complex(c_double_complex), intent(out) :: zout(n)
        !! Complex impedance in Ohms.
    integer(c_int), intent(out) :: errstat
        !! Error status
    type(c_ptr), intent(out) :: errmsg
        !! errmsg Error message
    
    character(len=:), pointer :: fptr

    call z(p, w, zout, e, errstat, fptr)

    if(allocated(errmsg_c))then
        deallocate(errmsg_c)
    endif
    allocate(character(len=len(fptr)+1) :: errmsg_c)

    errmsg_c = fptr // c_null_char
    errmsg = c_loc(errmsg_c)

end subroutine

end module
