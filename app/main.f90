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
    character(len=:),allocatable  :: help_text(:), version_text(:)
    logical :: flag_abridged
    character(len=3) :: elmt


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
        'OPTIONS                                                         ', &
        '  o --not-abridged  Do not use the abridged value.              ', &
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


    cmd = get_subcommand()
    call set_mode('strict')

    select case (cmd)
        case ("saw")
            call set_args("--abridged:a", help_saw(), version_text)
            flag_abridged = lget('a')
            do i=2, size(unnamed)
                elmt = unnamed(i)
                r = get_saw(elmt,abridged=flag_abridged)
                dr = get_saw(elmt,abridged=flag_abridged, uncertainty=.true.)
                write(output_unit, '(A4, A3, A3, SP, G14.6, A3, ES14.2)') &
                     'SAW_', elmt, " = ", r, "+/-", dr
            end do
        case ("all")
            call set_args(" ", help_text, version_text)
            call  print_periodic_table()
        case default
            call set_args(" ", help_text, version_text)
            do i=1, size(help_text), 1
                write (OUTPUT_UNIT, '(A)') help_text(i)
            end do
    end select

contains

function help_saw()result(res)
    !! Get the help text for the subcommand saw.
    character(len=80), allocatable :: res(:)
    res = [character(len=80) :: &
        'NAME                                                            ', &
        '  saw - th ecxcli subcommand to get the standard atomic weight. ', &
        '                                                                ', &
        'SYNOPSIS                                                        ', &
        '  ecxcli saw [--not-abridged] ELEMENTS ...                      ', &
        '                                                                ', &
        'DESCRIPTION                                                     ', &
        '  Provide the saw either abridged or not.                       ', &
        '  The uncertainty of the saw can be retrieved too.              ', &
        '                                                                ', &
        'OPTIONS                                                         ', &
        '  o --not-abridged  Do not use the abridged value.              ', &
        '                                                                ', &
        'VALID FOR ALL SUBCOMMANDS                                       ', &
        '  o --help     Show help text and exit                          ', & 
        '  o --verbose  Display additional information when available.   ', &
        '  o --version  Show version information and exit.               ', &
        '                                                                ', &
        '' ]

end function

end program
