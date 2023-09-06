module ecx__kinetics_capi
    use iso_fortran_env
    use iso_c_binding
    use ecx__kinetics
    implicit none
    private

contains

pure function ecx_kinetics_capi_nernst(E0, z, aox, vox, nox, ared, vred, nred, T)result(E)bind(C)
    !! Compute the Nernst electrochemical potential in V.
    implicit none
    real(c_double), intent(in), value :: E0
        !! Standard electrochemical potential in V.
    real(c_double), intent(in), value :: z
        !! Number of exchanged electrons.
    integer(c_size_t), intent(in), value :: nox
        !! Number of oxidants.
    integer(c_size_t), intent(in), value :: nred
        !! Number of reductants.
    real(c_double), intent(in) :: aox(nox)
        !! Activities of the oxidants.
    real(c_double), intent(in) :: vox(nox)
        !! Coefficients for the oxidants.
    real(c_double), intent(in) :: ared(nred)
        !! Activities of the reductants
    real(c_double), intent(in) :: vred(nred)
        !! Coefficients for the reductants.
    real(c_double), intent(in), value :: T
        !! Temperature in °C.
    real(c_double) :: E
    E = ecx_kinetics_nernst(E0, z, aox, vox, ared, vred, T)

end function

pure subroutine ecx_kinetics_capi_sbv(U, OCV, j0, aa, ac, za, zc, A, T, I, n)bind(c)
    !! Compute Butler Volmer equation without mass transport.
    ! arguments
    integer(c_size_t), intent(in), value :: n
        !! Size of U and I.
    real(c_double), intent(in), value :: OCV
        !! Open circuit potential in volts.
    real(c_double), intent(in) :: U(n)
        !! Potential in volts.
    real(c_double), intent(in), value :: j0
        !! Exchange current density in A.cm-2.
    real(c_double), intent(in), value :: aa
        !! Anodic transfert coefficient.
    real(c_double), intent(in), value :: ac
        !! Cathodic transfert coefficient.
    real(c_double), intent(in), value :: za
        !! Number of exchanged electrons in anodic branch.
    real(c_double), intent(in), value :: zc
        !! Number of exchanged electrons in cathodic branch.
    real(c_double), intent(in), value :: A
        !! Area in cm2.
    real(c_double), intent(in), value :: T
        !! Temperature in °C.
    real(c_double), intent(out) :: I(n)
        !! Current in A.

    I = ecx_kinetics_sbv(U, OCV, j0, aa, ac, za, zc, A, T)

end subroutine

pure subroutine ecx_kinetics_capi_bv(U, OCV, j0, jdla, jdlc, aa, ac, za, zc, A, T, I, n)bind(c)
    !! Compute Butler Volmer equation without mass transport.
    ! arguments
    integer(c_size_t), intent(in), value :: n
        !! Size of U and I.
    real(c_double), intent(in), value :: OCV
        !! Open circuit potential in volts.
    real(c_double), intent(in) :: U(n)
        !! Potential in volts.
    real(c_double), intent(in), value :: j0
        !! Exchange current density in A.cm-2
    real(real64), intent(in), value :: jdla
        !! Anodic diffusion limiting current density in A.cm-2.
    real(real64), intent(in), value :: jdlc
        !! Cathodic diffusion limiting current density in A.cm-2.
    real(c_double), intent(in), value :: aa
        !! Anodic transfert coefficient.
    real(c_double), intent(in), value :: ac
        !! Cathodic transfert coefficient.
    real(c_double), intent(in), value :: za
        !! Number of exchanged electrons in anodic branch.
    real(c_double), intent(in), value :: zc
        !! Number of exchanged electrons in cathodic branch.
    real(c_double), intent(in), value :: A
        !! Area in cm2.
    real(c_double), intent(in), value :: T
        !! Temperature in °C.
    real(c_double), intent(out) :: I(n)
        !! Current in A.

    I = ecx_kinetics_bv(U, OCV, j0, jdla, jdlc, aa, ac, za, zc, A, T)
end subroutine

end module