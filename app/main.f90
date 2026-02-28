program ecxcli
!! CLI interface for electrochemistry.
use ieee_arithmetic, only: ieee_is_nan
use iso_fortran_env, only: real64, int32, output_unit
use ecx
use M_CLI2, only: set_args, iget, lget, get_args, dgets
use M_CLI2, only: get_subcommand, set_mode
implicit none

character(len=*), parameter :: name="ecx"
character(len=32) :: cmd
character(len=:),allocatable, target  :: help_text(:), version_text(:)
character(len=:), pointer :: char_fp(:)

nullify(char_fp)

help_text=[character(len=80) :: &
'NAME                                                                  ', &
'  ecx(1) - Command line for ecx                                       ', &
'                                                                      ', &
'SYNOPSIS                                                              ', &
'  ecx SUBCOMMAND [OPTION...] ARG...                                   ', &
'                                                                      ', &
'DESCRIPTION                                                           ', &
'  ecx is command line interface for computing electro-                ', &
'  chemical properties:                                                ', &
'    o EIS         Electrochemical Impedance Z=f(w)                    ', &
'    o Kinetics    j=f(U)                                              ', &
'    o PEC         Iph=f(hv, U)                                        ', &
'                                                                      ', &
'  It can also provide the molar masses, isotope compositions and      ', &
'  nuclide compositions.                                               ', &
'                                                                      ', &
'OPTIONS                                                               ', &
'                                                                      ', &
'all:                                                                  ', &
'  --usage, -u                       Show usage text and exit.         ', &
'  --help, -h                        Show help text and exit.          ', &
'  --verbose, -V                     Display additional information.   ', &
'  --version, -v                     Show version information and exit.', &
'                                                                      ', &
'' ]

version_text=[character(len=80) :: &
    'PROGRAM:      '//name//'                                          ', &
    'DESCRIPTION:  Compute light and heavy water properties.           ', &
    'VERSION:      '//get_version()//'                                 ', &
    'AUTHOR:       M. Skocic                                           ', &
    'LICENSE:      MIT                                                 ', &
    '' ]

cmd = get_subcommand()
call set_mode('strict')
call set_mode('response_file')
call set_args('', help_text, version_text)


contains


end program ecxcli
