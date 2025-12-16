! NAME
!     ecx - Main module for the ECX library.
! 
! SYNOPSIS
!     use ecx
! 
! DESCRIPTION
! 
!     Available modules:
!     o ecx__api        API
!     o ecx__capi       C API
! 
!     The ECX library allows to compute:
!     o kinetics        Nernst, Tafel
!     o impedance       EIS, DIA
!     o photocurrent    Iph
! 
! EXAMPLE
!     Minimal program:
! 
!         program example
!             use ecx
!         end program
! 
! SEE ALSO
!     complex(7)
module ecx
    use ecx__core
    use ecx__kinetics
    use ecx__eis
    use ecx__pec
    use ecx__api
    use ecx__capi
end module
