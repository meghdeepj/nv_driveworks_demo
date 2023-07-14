project(team_node C CXX)

include(GWModuleInstallConfig)

set(DRIVEWORKS_PATH "/usr/local/driveworks")
set(DWCGF_NODES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/nodes)

file(GLOB_RECURSE DWCGF_NODES_FILES
    ${DWCGF_NODES_DIR}/*.hpp
    ${DWCGF_NODES_DIR}/*.cpp
)

if (NOT TARGET driveworks-shared)
    find_package(driveworks-shared REQUIRED CONFIG HINTS ${DRIVEWORKS_PATH}/cmake)
endif()

if (NOT TARGET dwframework)
    find_package(dwframework REQUIRED CONFIG HINTS ${DRIVEWORKS_PATH}/cmake)
endif()

find_package(NvSCI MODULE REQUIRED COMPONENTS NvSciSync)

set(LIBRARIES
    # samples_framework
    ${Driveworks_LIBRARIES}
    driveworks-shared
    dwframework
    NvSCI::NvSciSync
)

#-------------------------------------------------------------------------------
# ros2 packages
#-------------------------------------------------------------------------------
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)

#-------------------------------------------------------------------------------
# internal lib
#-------------------------------------------------------------------------------
get_target_property(GW_MODULE_HEADER_DIR module_demo HEADER_DIR)
get_target_property(GW_CHANNEL_HEADER_DIR common_cgf_channel HEADER_DIR)
get_target_property(GW_CHANNEL_SRC_DIR common_cgf_channel SRC_DIR)
include_directories(
    ${GW_MODULE_HEADER_DIR}
    ${GW_CHANNEL_HEADER_DIR}
)

#-------------------------------------------------------------------------------
# Custom nodes shared library
#-------------------------------------------------------------------------------
# zs: bug: must be compiled with channel src files
file(GLOB_RECURSE DWCGF_CHANNEL_FILES
    ${GW_CHANNEL_SRC_DIR}/*.cpp
)
add_library(${PROJECT_NAME} SHARED ${DWCGF_NODES_FILES} ${DWCGF_CHANNEL_FILES})
ament_target_dependencies(${PROJECT_NAME} "rclcpp" "std_msgs" )
target_link_libraries(${PROJECT_NAME} ${LIBRARIES} module_demo)
target_include_directories(${PROJECT_NAME}
                           PUBLIC
                           ${CUDA_DIR}/include
                           ${DW_ROOT}/include
                           ${DW_ROOT}/include/3rdparty
                           ${DW_ROOT}/include/dwshared/dwfoundation
                           ${DW_ROOT}/include/dwshared/dwtrace)

gw_add_module(${PROJECT_NAME})
# todo: add it to gw_add_module()
set_property(TARGET ${PROJECT_NAME} APPEND PROPERTY INSTALL_RPATH \$ORIGIN/../module_demo/)

ament_package()
