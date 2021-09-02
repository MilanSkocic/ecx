add_library(static_electrox STATIC eis.c kinetics.c utilities.c io.c)
set_target_properties(static_electrox PROPERTIES OUTPUT_NAME electrox)

add_library(shared_electrox SHARED eis.c kinetics.c utilities.c io.c)
set_target_properties(shared_electrox PROPERTIES OUTPUT_NAME electrox)

target_include_directories(static_electrox PUBLIC ${CMAKE_BINARY_DIR}/src)
target_link_libraries(static_electrox PUBLIC m gsl)

target_include_directories(shared_electrox PUBLIC ${CMAKE_BINARY_DIR}/src)
target_link_libraries(shared_electrox PUBLIC m gsl)

set_target_properties(static_electrox PROPERTIES PUBLIC_HEADER ${CMAKE_SOURCE_DIR}/src/electrox.h)
set_target_properties(shared_electrox PROPERTIES PUBLIC_HEADER ${CMAKE_SOURCE_DIR}/src/electrox.h)
