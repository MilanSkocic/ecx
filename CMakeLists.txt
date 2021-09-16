cmake_minimum_required(VERSION 3.10)

project(electrox VERSION 1.0 LANGUAGES C)

#set(CMAKE_INSTALL_PREFIX /home/milan/.local)

set(CMAKE_C_STANDARD 99)

add_subdirectory(src)
add_subdirectory(examples)
add_subdirectory(tests)

enable_testing()
add_test(NAME bv COMMAND test_bv)
add_test(NAME eis COMMAND test_eis)
add_test(NAME io COMMAND test_io)
add_test(NAME utilities COMMAND test_utilities)


install(TARGETS static_electrox PUBLIC_HEADER DESTINATION local/include ARCHIVE DESTINATION local/lib)

install(TARGETS shared_electrox PUBLIC_HEADER DESTINATION local/include LIBRARY DESTINATION local/lib)

SET(CPACK_GENERATOR "DEB")
SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "Milan Skocic") #required
SET(CPACK_DEBIAN_PACKAGE_DEPENDS "libc6 (>= 2.3), libgsl-dev (>=2.6), libopenblas-dev (>=0.3)" )
INCLUDE(CPack)