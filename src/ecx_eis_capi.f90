module ecx__eis_capi
    use iso_fortran_env
    use iso_c_binding
    use ecx__eis
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
!! @param[in] C Capacitance in Farad.
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

!> @brief Compute the complex impedance for a inductor. 
!! @param[in] w Angular frequencies in rad.s^-1 as 1d-array.
!! @param[in] L Inductance in Henry.
!! @param[in] n Size of w and Z.
!! @param[out] Z Complex impedance in Ohms as 1d-array.
pure subroutine ecx_capi_zl(w, L, n, Z)bind(C)
    implicit none

    integer(c_size_t), intent(in), value :: n
    real(c_double), intent(in), value :: L
    real(c_double), intent(in) :: w(n)
    complex(c_double_complex), intent(out) :: Z(n)

    Z(:) = ecx_eis_zl(w, L)
end subroutine

!> @brief Compute the complex impedance for a CPE. 
!! @param[in] w Angular frequencies in rad.s^-1 as 1d-array.
!! @param[in] Q Resistance in S.s^-a
!! @param[in] a CPE exponent
!! @param[out] Z Complex impedance in Ohms as 1d-array.
pure subroutine ecx_capi_zcpe(w, Q, a, n, Z)bind(C)
    implicit none

    integer(c_size_t), intent(in), value :: n
    real(c_double), intent(in), value :: Q
    real(c_double), intent(in), value :: a
    real(c_double), intent(in) :: w(n)
    complex(c_double_complex), intent(out) :: Z(n)

    Z(:) = ecx_eis_zcpe(w, Q, a)
end subroutine

!> @brief Compute the complex impedance for a finite length warburg
!! @param[in] w Angular frequencies in rad.s^-1 as 1d-array.
!! @param[in] s Pseudo-Resistance in Ohms.s^(1/2).
!! @param[out] Z Complex impedance in Ohms as 1d-array.
pure subroutine ecx_capi_zw(w, s, n, Z)bind(C)
    implicit none

    integer(c_size_t), intent(in), value :: n
    real(c_double), intent(in), value :: s
    real(c_double), intent(in) :: w(n)
    complex(c_double_complex), intent(out) :: Z(n)

    Z(:) = ecx_eis_zw(w, s)
end subroutine

end module
