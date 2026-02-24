program tester
    use iso_fortran_env
    use testdrive, only : run_testsuite, new_testsuite, testsuite_type
    use testdrive, only : new_unittest, unittest_type, error_type, check
    use testsuite__core, only: collect_suite_core
    use testsuite__eis, only: collect_suite_eis
    use testsuite__kinetics, only: collect_suite_kinetics
    implicit none
    type(testsuite_type), allocatable :: testsuites(:)
    character(len=*), parameter :: fmt = '("#", *(1x, a))'
    integer :: stat, is

    stat = 0

    testsuites = [new_testsuite("CORE", collect_suite_core), &
                  new_testsuite("EIS", collect_suite_eis), &
                  new_testsuite("KINETICS", collect_suite_kinetics) &
                  ]
    

    do is = 1, size(testsuites)
        write(error_unit, fmt) "Testing:", testsuites(is)%name
        call run_testsuite(testsuites(is)%collect, error_unit, stat)
    end do

    if (stat > 0) then
        write(error_unit, '(i0, 1x, a)') stat, "test(s) failed!"
        error stop
    end if
end program
