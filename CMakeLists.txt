cmake_minimum_required(VERSION 3.10)

project(progcmake VERSION 1.0 LANGUAGES C)

set(CMAKE_INSTALL_PREFIX /home/milan/.local)

set(CMAKE_C_STANDARD 99)

add_subdirectory(src)
add_subdirectory(examples)
add_subdirectory(tests)

enable_testing()
add_test(NAME bv COMMAND test_bv)
add_test(NAME eis COMMAND test_eis)
add_test(NAME io COMMAND test_io)
add_test(NAME utilities COMMAND test_utilities)


install(TARGETS static_electrox PUBLIC_HEADER DESTINATION include ARCHIVE DESTINATION lib)
install(TARGETS shared_electrox PUBLIC_HEADER DESTINATION include ARCHIVE DESTINATION lib)
