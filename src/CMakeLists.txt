set(ecx_public_headers "${CMAKE_BINARY_DIR}/src/ecx.mod" "${CMAKE_SOURCE_DIR}/src/ecx.h")
set(ecx_sources "codata.f90" "ecx_common.f90" "ecx.f90" "ecx_eis.f90" "ecx_pec.f90" "ecx_capi.f90")

add_library(static_ecx STATIC "${ecx_sources}")
set_target_properties(static_ecx PROPERTIES OUTPUT_NAME ecx)

add_library(shared_ecx SHARED "${ecx_sources}")
set_target_properties(shared_ecx PROPERTIES OUTPUT_NAME ecx)

target_include_directories(static_ecx PUBLIC ${CMAKE_SOURCE_DIR}/src)
target_link_directories(static_ecx PUBLIC ${CMAKE_BINARY_DIR}/src)

target_include_directories(shared_ecx PUBLIC ${CMAKE_SOURCE_DIR}/src)
target_link_directories(shared_ecx PUBLIC ${CMAKE_BINARY_DIR}/src)

set_target_properties(static_ecx PROPERTIES PUBLIC_HEADER ${CMAKE_SOURCE_DIR}/src/ecx.h)
set_target_properties(shared_ecx PROPERTIES PUBLIC_HEADER ${CMAKE_SOURCE_DIR}/src/ecx.h)