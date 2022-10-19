!!
!> @file eis.f90
!!


!!
!> @brief Compute resistance impedance. 
!! @details \f$ Z = R \forall \omega \f$
!! @param[in] w Angular frequencies in rad.s^-1.
!! @param[in] R Resistance in Ohms.
!! @param[in] N Size of the impedance array.
!! @param[out] Z Complex impedance array in Ohms.
subroutine impedance_resistance(w, R, N, Z)
    use iso_c_binding

    integer(c_size_t), intent(in) :: N
    real(c_double), intent(in) :: R
    real(c_double), intent(in), dimension(N) :: w
    complex(c_double_complex), intent(out), dimension(N) :: Z

    integer(c_size_t) :: i

    do i=1, N
        Z(i) = complex(R, 0.0)
    enddo

end subroutine