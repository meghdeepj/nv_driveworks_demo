project(xplatform_node C CXX)

include(GWModuleInstallConfig)

set(DRIVEWORKS_PATH "/usr/local/driveworks")
set(DWCGF_NODES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/nodes)

file(GLOB_RECURSE DWCGF_NODES_FILES
    ${DWCGF_NODES_DIR}/*.hpp
    ${DWCGF_NODES_DIR}/*.cpp
    ${DWCGF_NODES_DIR}/*.cu
    ${DWCGF_NODES_DIR}/*.cuh
)

if (NOT TARGET driveworks-shared)
    find_package(driveworks-shared REQUIRED CONFIG HINTS ${DRIVEWORKS_PATH}/cmake)
endif()

if (NOT TARGET dwframework)
    find_package(dwframework REQUIRED CONFIG HINTS ${DRIVEWORKS_PATH}/cmake)
endif()

set(LIBRARIES
    ${Driveworks_LIBRARIES}
    driveworks-shared
    dwframework
)

#-------------------------------------------------------------------------------
# internal lib
#-------------------------------------------------------------------------------
get_target_property(GW_HEADER_DIR common_cgf_channel HEADER_DIR)
include_directories(
    ${GW_HEADER_DIR}
    include
)

# todo: close source lib dependency

#-------------------------------------------------------------------------------
# Custom nodes shared library
#-------------------------------------------------------------------------------
cuda_add_library(${PROJECT_NAME} SHARED ${DWCGF_NODES_FILES})
target_link_libraries(${PROJECT_NAME} PRIVATE ${LIBRARIES} common_cgf_channel)
target_include_directories(${PROJECT_NAME}
                           PUBLIC
                           src/
                           ${CUDA_DIR}/include
                           ${DW_ROOT}/include
                           ${DW_ROOT}/include/3rdparty
                           ${DW_ROOT}/include/dwshared/dwfoundation
                           ${DW_ROOT}/include/dwshared/dwtrace)

gw_add_module(${PROJECT_NAME})
