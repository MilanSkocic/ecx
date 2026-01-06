program ecxcli
    use ieee_arithmetic, only: ieee_is_nan
    use iso_fortran_env, only: real64, output_unit
    use ecx
    use ciaaw, only: ciaaw_version => get_version, get_saw, print_periodic_table
    use M_CLI2
    implicit none

    integer :: i
    real(real64) :: r, dr
    character(len=32) :: cmd
    character(len=:),allocatable, target  :: help_text(:), version_text(:), usage_text(:)
    character(len=:), pointer :: char_fp(:)
    character(len=3) :: elmt
    
    nullify(char_fp)

    help_text=[character(len=80) :: &
        'NAME                                                            ', &
        '  ecxcli(1) - Command line for ecx                              ', &
        '                                                                ', &
        'SYNOPSIS                                                        ', &
        '  ecxcli SUBCOMMAND [OPTIONS ...] ARGS ...                      ', &
        '                                                                ', &
        'DESCRIPTION                                                     ', &
        '  ecxcli is command line interface for computing electro-       ', &
        '  chemical properties:                                          ', &
        '    o EIS         Electrochemical Impedance Z=f(w)              ', &
        '    o Kinetics    j=f(U)                                        ', &
        '    o PEC         Iph=f(hv, U)                                  ', &
        '                                                                ', &
        '  It can also provide the molar masses, isotope compositions and', &
        '  nuclide compositions.', &
        '                                                                ', &
        'SUBCOMMANDS                                                     ', &
        '  o all  Get the whole periodic table.                          ', &
        '  o saw  Get the standard atomic weight.                        ', &
        !'  o ice  Get the isotopic composition of the element.           ', &
        !'  o naw  Get the nuclide atomic weight.                         ', &
        '                                                                ', &
        '  Enter ecxcli SUBCOMMAND --help for detailed descriptions.     ', &
        '                                                                ', &
        'OPTIONS                                                         ', &
        '  o --abridged, -a     Use the abridged value.                  ', &
        '  o --uncertainty, -u  Use the uncertainty.                     ', &
        '  o --pprint           Nice formatting.                         ', &
        '                                                                ', &
        'VALID FOR ALL SUBCOMMANDS                                       ', &
        '  o --help     Show help text and exit                          ', & 
        '  o --verbose  Display additional information when available.   ', &
        '  o --version  Show version information and exit.               ', &
        '                                                                ', &
        '' ]

    version_text=[character(len=80) :: &
        'PROGRAM:      ecxcli                ', &
        'DESCRIPTION:  Command line for ecx  ', &
        'VERSION:      '//get_version()//'   ', &
        'AUTHOR:       M. Skocic             ', &
        'LICENSE:      MIT                   ', &
        '' ]

    usage_text=[character(len=80) :: &
        'Usage: ecxcli SUBCOMMAND [OPTIONS...]|[--help|--version] ELEMENTS...', &
        '' ]

    cmd = get_subcommand()
    call set_mode('strict')

    select case (cmd)
        case ("saw")
            call set_args("--abridged:a --uncertainty:u --pprint", get_help_saw(), version_text)
            if(size(unnamed) == 1) then
                write(output_unit, "(A)") "Enter at least one element."
                char_fp => usage_text
                call print_text(char_fp)
                stop
            end if
            do i=2, size(unnamed)
                elmt = unnamed(i)
                if(lget("pprint"))then
                    r = get_saw(elmt,abridged=lget("a"))
                    dr = get_saw(elmt, abridged=lget("a"), uncertainty=.true.)
                    write(output_unit, '(A4, A3, A3, SP, G14.6, A3, ES14.2)') &
                     'SAW_', elmt, " = ", r, "+/-", dr
                else
                    r = get_saw(elmt,abridged=lget("a"), uncertainty=lget("u"))
                    write(output_unit, '(G0.16)') r
                end if
            end do
        case ("all")
            call set_args(" ", help_text, version_text)
            call  print_periodic_table()
        case default
            call set_args(" ", help_text, version_text)
            char_fp => usage_text
            call print_text(char_fp)
    end select

contains

function get_help_saw()result(res)
    !! Get the help text for the subcommand saw.
    character(len=80), allocatable :: res(:)
    res = [character(len=80) :: &
        'NAME                                                            ', &
        '  saw - th ecxcli subcommand to get the standard atomic weight. ', &
        '                                                                ', &
        'SYNOPSIS                                                        ', &
        '  ecxcli saw [OPTIONS ...] ELEMENTS ...                      ', &
        '                                                                ', &
        'DESCRIPTION                                                     ', &
        '  Provide the saw either abridged or not.                       ', &
        '  The uncertainty of the saw can be retrieved too.              ', &
        '                                                                ', &
        'OPTIONS                                                         ', &
        '  o --abridged, -a     Use the abridged value.                  ', &
        '  o --uncertainty, -u  Use the uncertainty.                     ', &
        '  o --pprint           Nice formatting.                         ', &
        '                                                                ', &
        'VALID FOR ALL SUBCOMMANDS                                       ', &
        '  o --help     Show help text and exit                          ', & 
        '  o --verbose  Display additional information when available.   ', &
        '  o --version  Show version information and exit.               ', &
        '                                                                ', &
        'EXAMPLE                                                         ', &
        '  Minimal example                                               ', &
        '      ecxcli saw H                                              ', &
        '      ecxcli saw -a -u O                                        ', &
        '      ecxcli saw H C B O Zr Nb --pprint                         ', &
        '      ecxcli saw -a H C B O Zr Nb --pprint                      ', &
        '                                                                ', &
        '' ]
end function

subroutine print_text(char_fp)
    character(len=:), pointer, intent(in) :: char_fp(:)
    integer :: i
    do i=1, size(char_fp), 1
        write (OUTPUT_UNIT, '(A)') char_fp(i)
    end do
end subroutine


end program
