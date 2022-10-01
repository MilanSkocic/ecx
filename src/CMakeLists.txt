add_executable(generator generate_codata.c)

add_custom_command(
    TARGET generator PRE_BUILD 
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/src/codata.txt ${CMAKE_BINARY_DIR}/src/codata.txt
    COMMENT "Copying codata.txt to build directory"
)
add_custom_command(TARGET generator POST_BUILD 
                   COMMAND generator
                   COMMENT "Generating c code for codata.")

add_library(static_electrox STATIC eis.c kinetics.c utilities.c io.c)
set_target_properties(static_electrox PROPERTIES OUTPUT_NAME electrox)

add_library(shared_electrox SHARED eis.c kinetics.c utilities.c io.c)
set_target_properties(shared_electrox PROPERTIES OUTPUT_NAME electrox)

target_include_directories(static_electrox PUBLIC ${CMAKE_BINARY_DIR}/src)
target_link_libraries(static_electrox PUBLIC m gsl openblas)

target_include_directories(shared_electrox PUBLIC ${CMAKE_BINARY_DIR}/src)
target_link_libraries(shared_electrox PUBLIC m gsl openblas)

set_target_properties(static_electrox PROPERTIES PUBLIC_HEADER ${CMAKE_SOURCE_DIR}/src/electrox.h)
set_target_properties(shared_electrox PROPERTIES PUBLIC_HEADER ${CMAKE_SOURCE_DIR}/src/electrox.h PUBLIC_HEADER ${CMAKE_BINARY_DIR}/src/electrox_codata.h)


link_directories(${CMAKE_BINARY_DIR}/src)

add_executable(celectrox-config config.c)
target_include_directories(celectrox-config PRIVATE ${CMAKE_SOURCE_DIR}/src ${CMAKE_BINARY_DIR}/src)
target_link_libraries(celectrox-config electrox)