cmake_minimum_required(VERSION 3.10)

project(electrox VERSION "0.1.0" LANGUAGES  "C" "Fortran" DESCRIPTION "Electrochemistry")

set(CMAKE_C_STANDARD 99)

set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -Wall")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -Wall")

message("release = " ${CMAKE_C_FLAGS_RELEASE})
message("debug = " ${CMAKE_C_FLAGS_DEBUG})
message("build type = " ${CMAKE_BUILD_TYPE})
message("prefix = " ${CMAKE_INSTALL_PREFIX})

add_subdirectory(src)
add_subdirectory(examples)
#add_subdirectory(tests)

#enable_testing()
#add_test(NAME bv COMMAND test_bv)
#add_test(NAME eis COMMAND test_eis)
#add_test(NAME io COMMAND test_io)
#add_test(NAME utilities COMMAND test_utilities)


install(TARGETS static_ecx PUBLIC_HEADER DESTINATION include ARCHIVE DESTINATION lib)
install(TARGETS shared_ecx PUBLIC_HEADER DESTINATION include LIBRARY DESTINATION lib)

#SET(CPACK_GENERATOR "DEB")
#SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "Milan Skocic") #required
#SET(CPACK_DEBIAN_PACKAGE_DEPENDS "libc6 (>= 2.3), libgsl-dev (>=2.6), libopenblas-dev (>=0.3)" )
#INCLUDE(CPack)