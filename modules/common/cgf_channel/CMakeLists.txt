project(common_cgf_channel C CXX)

include(GWModuleInstallConfig)

set(DRIVEWORKS_PATH "/usr/local/driveworks")
set(DWCGF_CHANNEL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/channel)
set(GW_HEADER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)

file(GLOB_RECURSE DWCGF_CHANNEL_FILES
    ${DWCGF_CHANNEL_DIR}/*.hpp
    ${DWCGF_CHANNEL_DIR}/*.cpp
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
# channel shared library
#-------------------------------------------------------------------------------
add_library(${PROJECT_NAME} STATIC ${DWCGF_CHANNEL_FILES})
set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE CXX)
target_link_libraries(${PROJECT_NAME} PRIVATE ${LIBRARIES})
target_include_directories(${PROJECT_NAME}
                           PUBLIC
                           ${CUDA_DIR}/include
                           ${DW_ROOT}/include
                           ${DW_ROOT}/include/3rdparty
                           ${DW_ROOT}/include/dwshared/dwfoundation
                           ${DW_ROOT}/include/dwshared/dwtrace)

set_target_properties(${PROJECT_NAME} PROPERTIES
    HEADER_DIR ${GW_HEADER_DIR}
)

# gw_add_module(${PROJECT_NAME})
