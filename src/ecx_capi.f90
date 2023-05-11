module ecx_capi
    use iso_fortran_env
    use iso_c_binding
    use ecx_eis
    implicit none
    private

contains


!> @brief Compute resistance impedance. 
!! @details \f$ Z = R \forall \omega \f$
!! @param[in] w Angular frequencies in rad.s^-1 (rank-1 array)
!! @param[in] R Resistance in Ohms.
!! @param[in] n Size of w and Z.
!! @param[out] Z Complex impedance in Ohms (rank-1 array).
pure subroutine ecx_capi_zr(w, R, n, Z)bind(C)
    implicit none

    integer(c_size_t), intent(in), value :: n
    real(c_double), intent(in), value :: R
    real(c_double), intent(in) :: w(n)
    complex(c_double_complex), intent(out) :: Z(n)

    Z(:) = ecx_eis_zr(w, r)

end subroutine

end module