!!
!> @file eis.f90
!!


!!
!> @brief Compute resistance impedance in vectorized form. 
!! @details \f$ Z = p_0 \forall \omega \f$
!! @param[in] p Pointer to the resistance in Ohms.
!! @param[in] w Pointer to th angular frequencies in rad.s^-1.
!! @param[out] Z Pointer to the complex impedance in Ohms.
subroutine resistance(Z, N, R)
    use iso_c_binding
    integer(c_size_t), intent(in) :: N
    real(8), intent(in) :: R
    real(8), intent(out), dimension(N) :: Z

    Z(:) = R

end subroutine