set(LINKLIBS "ecx")

if((${CMAKE_C_COMPILER_ID} STREQUAL "GNU") OR (${CMAKE_C_COMPILER_ID} STREQUAL "AppleClang") )
    set(LINKLIBS "m" "ecx")
endif()

link_directories(${CMAKE_BINARY_DIR}/src)
include_directories(${CMAKE_SOURCE_DIR}/src ${CMAKE_SOURCE_DIR}/tests)

add_executable(test_eis_r test_eis_r.c test_common.c)
target_link_libraries(test_eis_r ${LINKLIBS})
