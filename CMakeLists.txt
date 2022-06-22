cmake_minimum_required(VERSION 3.10)

project(electrox VERSION 1.0.1 LANGUAGES "C" DESCRIPTION "Electrochemistry for C users.")
configure_file("./src/config.h.in" "./src/config.h")

set(CMAKE_C_STANDARD 99)

set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -Wall")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -Wall")

message("release = " ${CMAKE_C_FLAGS_RELEASE})
message("debug = " ${CMAKE_C_FLAGS_DEBUG})

add_subdirectory(src)
add_subdirectory(examples)
add_subdirectory(tests)

enable_testing()
add_test(NAME bv COMMAND test_bv)
add_test(NAME eis COMMAND test_eis)
add_test(NAME io COMMAND test_io)
add_test(NAME utilities COMMAND test_utilities)


install(TARGETS static_electrox PUBLIC_HEADER DESTINATION include/electrox ARCHIVE DESTINATION lib)
install(TARGETS shared_electrox PUBLIC_HEADER DESTINATION include/electrox LIBRARY DESTINATION lib)
install(TARGETS celectrox_version RUNTIME DESTINATION bin)
install(TARGETS example_eis example_kinetics RUNTIME DESTINATION bin)

SET(CPACK_GENERATOR "DEB")
SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "Milan Skocic") #required
SET(CPACK_DEBIAN_PACKAGE_DEPENDS "libc6 (>= 2.3), libgsl-dev (>=2.6), libopenblas-dev (>=0.3)" )
INCLUDE(CPack)