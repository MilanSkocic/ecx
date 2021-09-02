link_directories(${CMAKE_BINARY_DIR}/src)

add_executable(test_bv test_bv.c)
target_include_directories(test_bv PUBLIC ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(test_bv m electrox gsl)

add_executable(test_eis test_eis.c)
target_include_directories(test_eis PUBLIC ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(test_eis m electrox gsl)

add_executable(test_io test_io.c)
target_include_directories(test_io PUBLIC ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(test_io m electrox gsl)