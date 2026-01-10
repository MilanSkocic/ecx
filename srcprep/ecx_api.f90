module ecx__api
    !! API
    use ecx__version, only: version
    use ecx__common
    use ecx__core
    use ecx__eis
    implicit none
    private

    character(len=:), allocatable, target :: version_f
    character(len=:), allocatable, target :: errmsg_f
    character(len=:), allocatable, target :: errmsg_c

    public :: get_version, kTe, z, mm
    public :: sbv, bv, nernst


contains

$BLOCK comment --file ecx_get_version.3.txt
NAME
    get_version - version getter for the library

LIBRARY
    Electrochemistry library - (-libecx, -lecx) 

SYNOPSIS
    get_version()
    
DESCRIPTION
    This function returns the version of the ecx library.
RETURN VALUE
    character(len=:), pointer :: fptr
$ENDBLOCK
function get_version()result(fptr)
    !! Get the version.
    implicit none
    character(len=:), pointer :: fptr    !! Version of the library.

    if(allocated(version_f))then
        deallocate(version_f)
    endif
    allocate(character(len=len(version)) :: version_f)
    version_f = version
    fptr => version_f
end function


$BLOCK comment --file ecx_kTe.3.txt
NAME
    kTe - thermal voltage

SYNOPSIS
    kTe(T)

DESCRIPTION
    Compute the thermal voltage.

    Parameters:

    o T  Temperature in °C

RETURN VALUE
    real(dp) :: r   Thermal voltage in Volts.
$ENDBLOCK
pure elemental function kTe(T)result(r)
    !! Compute the thermal voltage.
    implicit none
    real(dp), intent(in) :: T        !! Temperature in °C.
    real(dp) :: r                    !! Thermal voltage in V.

    r = (T+T_K) * kB_eV
end function


subroutine z(p, w, zout, e, errstat, errmsg)
    implicit none
    real(dp), intent(in) :: p(:)
    real(dp), intent(in) :: w(:)            !! Angular frequencies in rad.s-1
    character(len=1), intent(in) :: e       !! Electrochemical element: R, C, L, Q, O, T, G
    complex(dp), intent(out) :: zout(:)     !! Complex impedance in Ohms.
    integer(int32), intent(out) :: errstat  !! Error status
    character(len=:), intent(out), pointer :: errmsg  !! Error message


    if(allocated(errmsg_f))then
        deallocate(errmsg_f)
    endif

    errstat = 0
    if(size(p)<3)then
        errmsg_f = "The size of p must be 3."
        errstat = 1
        zout = cmplx(ieee_value(0.0_dp, ieee_quiet_nan), &
                ieee_value(0.0_dp, ieee_quiet_nan), &
                dp)
    else
        select case(e)
            case("R")
                zout = zr(w, p(1))
                errmsg_f = "No error"
            case("C")
                zout = zc(w, p(1))
                errmsg_f = "No error"
            case("L")
                zout = zl(w, p(1))
                errmsg_f = "No error"
            case("W")
                zout = zw(w, p(1))
                errmsg_f = "No error"
            case("Q")
                zout = zq(w, p(1), p(2))
                errmsg_f = "No error"
            case("O")
                zout = zo(w, p(1), p(2), p(3))
                errmsg_f = "No error"
            case("T")
                zout = zt(w, p(1), p(2), p(3))
                errmsg_f = "No error"
            case("G")
                zout = zg(w, p(1), p(2))
                errmsg_f = "No error"
            case DEFAULT
                errstat= 2
                errmsg_f = "Unknown element: "//e
                zout = cmplx(ieee_value(0.0_dp, ieee_quiet_nan), &
                        ieee_value(0.0_dp, ieee_quiet_nan), &
                        dp)
        end select
    endif
    errmsg => errmsg_f
end subroutine

subroutine mm(p, w, zout, n)
    !! Compute the measurement model.
    real(dp), intent(in) :: p(:)
        !! Parameters.
    real(dp), intent(in) :: w(:)
        !! Angular frequencies in rad.s-1
    complex(dp), intent(out) :: zout(:)
        !! Complex impedance in Ohms.
    integer(int32), intent(in) :: n
        !! Number of voigt elements.

    integer(int32) :: i
    integer(int32) :: errstat
    character(len=:), pointer :: errmsg
    complex(dp) :: zr(size(zout))
    complex(dp) :: zc(size(zout))

    if(n<1)then
        errstat = 3
        zout = cmplx(ieee_value(0.0_dp, ieee_quiet_nan), ieee_value(0.0_dp, ieee_quiet_nan), dp)
    else
        if(size(p) == (1+n*2))then
            call z(p, w, zout, "R", errstat, errmsg)
            do i = 1, n-2
                call z(p(i+1:), w, zr, "R", errstat, errmsg)
                call z(p(i+2:), w, zc, "C", errstat, errmsg)
                zout = zout + (zr*zc) / (zr+zc)
            enddo
        else
            errstat = 4
            zout = cmplx(ieee_value(0.0_dp, ieee_quiet_nan), ieee_value(0.0_dp, ieee_quiet_nan), dp)
        endif
    endif


end subroutine


pure function nernst(E0, z, aox, vox, ared, vred, T)result(E)
    !! Compute the Nernst electrochemical potential in V.
    implicit none
    real(dp), intent(in) :: E0
        !! Standard electrochemical potential in V.
    integer(int32), intent(in) :: z
        !! Number of exchanged electrons.
    real(dp), intent(in) :: aox(:)
        !! Activities of the oxidants.
    real(dp), intent(in) :: vox(:)
        !! Coefficients for the oxidants.
    real(dp), intent(in) :: ared(:)
        !! Activities of the reductants
    real(dp), intent(in) :: vred(:)
        !! Coefficients for the reductants.
    real(dp), intent(in) :: T
        !! Temperature in °C.

    real(dp) :: E, ox, red, kTe_

    kTe_ = kTe(T)
    ox = product(aox**vox)
    red = product(ared**vred)

    E = E0 + kTe_/z * log(ox/red)

end function

pure elemental function sbv(U, OCV, j0, aa, ac, za, zc, A, T)result(I)
    !! Compute Butler Volmer equation without mass transport.
    real(dp), intent(in) :: OCV
        !! Open Circuit Voltage in V.
    real(dp), intent(in) :: U
        !! Electrochemical potential in V.
    real(dp), intent(in) :: j0
        !! Exchange current density in A.cm-2.
    real(dp), intent(in) :: aa
        !! Anodic transfer coefficient.
    real(dp), intent(in) :: ac
        !! Cathodic transfer coefficient.
    real(dp), intent(in) :: za
        !! Number of exchnaged electrons in the anodic branch.
    real(dp), intent(in) :: zc
        !! Number of exchnaged electrons in the cathodic branch.
    real(dp), intent(in) :: A
        !! Area in cm2.
    real(dp), intent(in) :: T
        !! Temperature in °C.

    real(dp) :: I

    real(dp) :: kTe_

    kTe_ = kTe(T)

    I = A * j0 * (exp(aa * za * (U - OCV) / kTe_) - exp(-ac * zc * (U - OCV) / kTe_));
end function

pure elemental function bv(U, OCV, j0, jdla, jdlc, aa, ac, za, zc, A, T)result(I)
    !! Compute Butler Volmer equation with mass transport.
    implicit none
    real(dp), intent(in) :: OCV
        !! Open Circuit Voltage in V.
    real(dp), intent(in) :: U
        !! Electrochemical potential in V.
    real(dp), intent(in) :: j0
        !! Exchange current density in A.cm-2.
    real(dp), intent(in) :: jdla
        !! Anodic diffusion limiting current density in A.cm-2.
    real(dp), intent(in) :: jdlc
        !! Cathodic diffusion limiting current density in A.cm-2.
    real(dp), intent(in) :: aa
        !! Anodic transfer coefficient.
    real(dp), intent(in) :: ac
        !! Cathodic transfer coefficient.
    real(dp), intent(in) :: za
        !! Number of exchnaged electrons in the anodic branch.
    real(dp), intent(in) :: zc
        !! Number of exchnaged electrons in the cathodic branch.
    real(dp), intent(in) :: A
        !! Area in cm2.
    real(dp), intent(in) :: T
        !! Temperature in °C.

    real(dp) :: I, kTe_, num, denom

    kTe_ = kTe(T)

    num = sbv(U, OCV, j0, aa, ac, za, zc, 1.0_dp, T)
    denom = 1 + j0 / jdla * exp(aa * za * (U - OCV) / kTe_) + j0 / jdlc * exp(-ac * zc * (U - OCV) / kTe_);

    I = A * num / denom;

end function

end module ecx__api
