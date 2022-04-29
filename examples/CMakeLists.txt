set(ARGP "")

if(APPLE)
    set(ARGP "argp")
endif()

link_directories(${CMAKE_BINARY_DIR}/src)

add_executable(example_kinetics example_kinetics.c)
target_include_directories(example_kinetics PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(example_kinetics electrox ${ARGP})

add_executable(example_eis example_eis.c)
target_include_directories(example_eis PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(example_eis electrox ${ARGP})
