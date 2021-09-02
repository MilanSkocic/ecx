link_directories(${CMAKE_BINARY_DIR}/src)

add_executable(example1 example1.c)
target_include_directories(example1 PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(example1 electrox)

add_executable(example2 example2.c)
target_include_directories(example2 PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(example2 electrox)
