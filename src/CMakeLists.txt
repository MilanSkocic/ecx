set(ECX_PUBLIC_HEADERS "${CMAKE_SOURCE_DIR}/src/ecx.h"
                       "${CMAKE_SOURCE_DIR}/src/ecx_types.h"
                       "${CMAKE_SOURCE_DIR}/src/ecx_eis_capi.h"
                       "${CMAKE_SOURCE_DIR}/src/ecx_pec_capi.h"
                       "${CMAKE_BINARY_DIR}/src/ecx_eis.mod" 
                       "${CMAKE_BINARY_DIR}/src/ecx_pec.mod")
set(ECX_SOURCES "codata.f90" 
                "ecx_eis.f90" 
                "ecx_eis_capi.f90"
                "ecx_pec.f90")

add_library(static_ecx STATIC "${ECX_SOURCES}")
set_target_properties(static_ecx PROPERTIES OUTPUT_NAME ecx)

add_library(shared_ecx SHARED "${ECX_SOURCES}")
set_target_properties(shared_ecx PROPERTIES OUTPUT_NAME ecx)

target_include_directories(static_ecx PUBLIC ${CMAKE_SOURCE_DIR}/src)
target_link_directories(static_ecx PUBLIC ${CMAKE_BINARY_DIR}/src)

target_include_directories(shared_ecx PUBLIC ${CMAKE_SOURCE_DIR}/src)
target_link_directories(shared_ecx PUBLIC ${CMAKE_BINARY_DIR}/src)

set_target_properties(static_ecx PROPERTIES PUBLIC_HEADER "${ECX_PUBLIC_HEADERS}")
set_target_properties(shared_ecx PROPERTIES PUBLIC_HEADER "${ECX_PUBLIC_HEADERS}")