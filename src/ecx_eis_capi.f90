module ecx__eis_capi
    !! C API for the module EIS.
    use iso_fortran_env
    use iso_c_binding
    use ecx__eis
    implicit none
    

contains

subroutine ecx_eis_capi_z(p, w, z, e, k, n, errstat)bind(C)
    !! Compute the complex impedance for the given element.
    implicit none
    integer(c_size_t), intent(in), value :: n
        !! Size of w
    integer(c_size_t), intent(in), value :: k
        !! Size of p
    character(len=1,kind=c_char), intent(in), value :: e
        !! Electrochemical element: R, C, L, Q, O, T, G
    integer(c_int), intent(inout) :: errstat
        !! Error status
    real(c_double), intent(in) :: p(k)
        !! Parameters.
    real(c_double), intent(in) :: w(n)
        !! Angular frequencies in rad.s-1
    complex(c_double_complex), intent(out) :: z(n)
        !! Complex impedance in Ohms.
    
    call ecx_eis_z(p, w, z, e, errstat)

end subroutine

end module
