program ecxcli
    !! CLI interface for electrochemistry.
    use ieee_arithmetic, only: ieee_is_nan
    use iso_fortran_env, only: real64, int32, output_unit
    use ecx
    use M_CLI2, only: set_args, iget, lget, get_args, dgets
    use M_CLI2, only: args=>unnamed, get_subcommand, set_mode
    implicit none

    character(len=*), parameter :: name="iapws"
    integer :: i
    integer(int32) :: zmass
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
        '  ecxcli SUBCOMMAND [OPTION...] ARG...                      ', &
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
        'OPTIONS                                                         ', &
        '                                                                ', &
        'all:                                                                  ', &
        '  --usage, -u                       Show usage text and exit.                   ', &
        '  --help, -h                        Show help text and exit.                    ', &
        '  --verbose, -V                     Display additional information when available.', &
        '  --version, -v                     Show version information and exit.          ', &
        '                                                                ', &
        '' ]

    version_text=[character(len=80) :: &
        'PROGRAM:      '//name//'                                              ', &
        'DESCRIPTION:  Compute light and heavy water properties.               ', &
        'VERSION:      '//get_version()//'                                     ', &
        'AUTHOR:       M. Skocic                                               ', &
        'LICENSE:      MIT                                                     ', &
        '' ]

    usage_text=[character(len=80) :: &
        'Usage: ecxcli SUBCOMMAND [OPTIONS...]|[--help|--version] ELEMENTS...', &
        '' ]

    cmd = get_subcommand()
    call set_mode('strict')
    call set_mode('response_file')
    call set_args('', help_text, version_text)


contains


subroutine print_text(char_fp)
    character(len=:), pointer, intent(in) :: char_fp(:)
    integer :: i
    do i=1, size(char_fp), 1
        write (OUTPUT_UNIT, '(A)') char_fp(i)
    end do
end subroutine


end program
