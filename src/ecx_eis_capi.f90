module ecx_eis_capi
    use iso_fortran_env
    use iso_c_binding
    use ecx_eis
    implicit none
    private

contains


!> @brief Compute the complex impedance for a resistor. 
!! @param[in] w Angular frequencies in rad.s^-1 as 1d-array.
!! @param[in] R Resistance in Ohms.
!! @param[in] n Size of w and Z.
!! @param[out] Z Complex impedance in Ohms as 1d-array.
pure subroutine ecx_capi_zr(w, R, n, Z)bind(C)
    implicit none

    integer(c_size_t), intent(in), value :: n
    real(c_double), intent(in), value :: R
    real(c_double), intent(in) :: w(n)
    complex(c_double_complex), intent(out) :: Z(n)

    Z(:) = ecx_eis_zr(w, R)

end subroutine

!> @brief Compute the complex impedance for a capacitor. 
!! @param[in] w Angular frequencies in rad.s^-1 as 1d-array.
!! @param[in] C Resistance in Ohms.
!! @param[in] n Size of w and Z.
!! @param[out] Z Complex impedance in Ohms as 1d-array.
pure subroutine ecx_capi_zc(w, C, n, Z)bind(C)
    implicit none

    integer(c_size_t), intent(in), value :: n
    real(c_double), intent(in), value :: C
    real(c_double), intent(in) :: w(n)
    complex(c_double_complex), intent(out) :: Z(n)

    Z(:) = ecx_eis_zc(w, C)
end subroutine


end module
