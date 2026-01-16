module ecx__capi
    use ecx__common
    use ecx__core
    use ecx__api

    character(len=:), allocatable, target :: errmsg_c
    character(len=:), allocatable, target :: version_c

contains

$BLOCK comment --file ecx_capi_get_version.3.txt
NAME
    ecx_get_version - version getter for the library (C API)

LIBRARY
    Electrochemistry library - (-libecx, -lecx) 

SYNOPSIS
    char* ecx_get_version(void);
    
DESCRIPTION
    This function returns the version of the ecx library.

RETURN VALUE
    char *

SEE ALSO
    ecx(3), ecx_get_version(3)
$ENDBLOCK
function capi_get_version()bind(c, name="ecx_get_version")result(cptr)
    !! C API - Get the version.
    implicit none
    
    ! Returns   
    type(c_ptr) :: cptr
        !! Pointer to version string.

    character(len=:), pointer :: fptr
    fptr => get_version() 

    if(allocated(version_c))then
        deallocate(version_c)
    endif
    allocate(character(len=len(fptr)+1) :: version_c)

    version_c = fptr // c_null_char
    cptr = c_loc(version_c)
end function


! CORE -------------------------------------------------------------------------
pure subroutine capi_nm2eV(lambda, E, n)bind(C, name="ecx_core_nm2eV") 
    !! C API - Convert wavelength to energy
    integer(c_size_t), intent(in), value :: n !! Size of lambda and E.
    real(c_double), intent(in) :: lambda(n) !! Wavelength in nm.
    real(c_double), intent(out) :: E(n) !! Energy in eV.
    E = nm2eV(lambda)
end subroutine

pure subroutine capi_kTe(T, kTe_, n)bind(C, name="ecx_core_kTe") 
    !! Compute the thermal voltage.
    integer(c_size_t), intent(in), value :: n !! Size of T and kTe.
    real(c_double), intent(in) :: T(n)        !! Temperature in °C.
    real(c_double), intent(out) :: kTe_(n)    !! Thermal voltage in V.
    kTe_ = kTe(T)
end subroutine




! EIS -------------------------------------------------------------------------
subroutine capi_z(p, w, zout, e, k, n, errstat, errmsg)bind(C, name="ecx_eis_z") 
    !! Compute the complex impedance for the given element.
    integer(c_size_t), intent(in), value :: n            !! Size of w
    integer(c_size_t), intent(in), value :: k            !! Size of p
    character(len=1,kind=c_char), intent(in), value :: e !! Electrochemical element: R, C, L, Q, O, T, G
    real(c_double), intent(in) :: p(k)                   !! Parameters.
    real(c_double), intent(in) :: w(n)                   !! Angular frequencies in rad.s-1
    complex(c_double_complex), intent(out) :: zout(n)    !! Complex impedance in Ohms.
    integer(c_int), intent(out) :: errstat               !! Error status
    type(c_ptr), intent(out) :: errmsg                   !! errmsg Error message
    
    character(len=:), pointer :: fptr

    call z(p, w, zout, e, errstat, fptr)

    if(allocated(errmsg_c))then
        deallocate(errmsg_c)
    endif
    allocate(character(len=len(fptr)+1) :: errmsg_c)

    errmsg_c = fptr // c_null_char
    errmsg = c_loc(errmsg_c)
end subroutine





! KINETICS -------------------------------------------------------------------------
pure function capi_nernst(E0, z, aox, vox, nox, ared, vred, nred, T)result(E)bind(C, name="ecx_kinetics_nernst")
    !! Compute the Nernst electrochemical potential in V.
    implicit none
    real(c_double), intent(in), value :: E0
        !! Standard electrochemical potential in V.
    integer(c_int), intent(in), value :: z
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
    E = nernst(E0, z, aox, vox, ared, vred, T)
end function

pure subroutine capi_sbv(U, OCV, j0, aa, ac, za, zc, A, T, I, n)bind(c, name="ecx_kinetics_sbv")
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

    I = sbv(U, OCV, j0, aa, ac, za, zc, A, T)
end subroutine

pure subroutine capi_bv(U, OCV, j0, jdla, jdlc, aa, ac, za, zc, A, T, I, n)bind(c, name="ecx_kinetics_bv")
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
    real(c_double), intent(in), value :: jdla
        !! Anodic diffusion limiting current density in A.cm-2.
    real(c_double), intent(in), value :: jdlc
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

    I = bv(U, OCV, j0, jdla, jdlc, aa, ac, za, zc, A, T)
end subroutine

end module ecx__capi
