module ecx_capi
    use iso_fortran_env
    use iso_c_binding
    use ecx
    implicit none
    private

contains


!> @brief Compute resistance impedance. 
!! @details \f$ Z = R \forall \omega \f$
!! @param[in] w Angular frequencies in rad.s^-1 (rank-1 array)
!! @param[in] R Resistance in Ohms.
!! @param[in] n Size of w and Z.
!! @param[out] Z Complex impedance in Ohms (rank-1 array).

pure subroutine ecx_capi_z_r(w, R, n, Z)bind(C)
    implicit none

    integer(c_size_t), intent(in) :: n
    real(c_double), intent(in) :: R
    real(c_double), dimension(n), intent(in) :: w
    complex(c_double_complex), dimension(n), intent(out) :: Z

    Z(:) = ecx_zr(w, r)
end subroutine

end module