program ecxbin
    use ieee_arithmetic, only: ieee_is_nan
    use iso_fortran_env, only: real64
    use ecx
    use ciaaw, only: ciaaw_version => get_version, get_saw
    use FLAP
    implicit none
    
    type(command_line_interface) :: cli
    integer :: error
    logical :: flag_man = .false.
    logical :: flag_abridged = .true.
    character(len=3) :: elmt
    real(real64) :: m

    call cli%init(progname = "ecxcli",                                         &
                 description = "Command line for ecx.",                        &
                 version = ciaaw_version())
    call cli%add(switch='--man', switch_ab="-m", help='man page file name',    &
                 required=.false., act="store_true", def="F", hidden=.true.)

    call cli%add_group(group="saw", description="Standard Atomic Weights")
    call cli%add(group="saw", positional=.true., position=1, required=.true., help="Get the standard atomic weight.")
    call cli%add(group="saw", switch="--abridged", switch_ab="-a", required=.false., act="store_false", def="T", help="Get the abridged standard atomic weight.")

    call cli%parse(error=error)
    
    if(error /= 0) then; stop error; end if

    call cli%get(switch="--man", val=flag_man, error=error)
    if(error /= 0)then; stop error; end if
    
    if(flag_man) then; call cli%save_man_page(man_file="./ecx.1"); end if 

    call cli%get(group="saw", position=1, val=elmt, error=error)
    call cli%get(group="saw", switch="--abridged", val=flag_abridged)
    if(error /= 0)then; stop error; end if
    
    m = get_saw(elmt, abridged=flag_abridged)

    if(ieee_is_nan(m))then
        print *, "Invalid element: "//elmt
    end if

    if(m == -1.0_real64)then
        print *, "Element "//elmt//" does not have a SAW."
    end if

end program
