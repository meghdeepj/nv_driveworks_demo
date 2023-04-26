project(dwcgf_image_pipe C CXX)

include(GWModuleInstallConfig)

set(DRIVEWORKS_PATH "/usr/local/driveworks")
set(DWCGF_GRAPHS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/graphs)
set(DWCGF_NODES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/nodes)
set(DWCGF_CHANNEL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/channel)
set(DWCGF_SCHE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/schedule)
set(DWCGF_DATA_DIR ${CMAKE_CURRENT_SOURCE_DIR}/data)
set(DWCGF_RUNNER ${CMAKE_CURRENT_SOURCE_DIR}/bin/run_cgf.sh)
set(DWCGF_RIG_TESTER ${CMAKE_CURRENT_SOURCE_DIR}/bin/test_rig.sh)

file(GLOB_RECURSE DWCGF_NODES_FILES
    ${DWCGF_NODES_DIR}/*.hpp
    ${DWCGF_NODES_DIR}/*.cpp
    ${DWCGF_NODES_DIR}/*.cu
    ${DWCGF_NODES_DIR}/*.cuh
)
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
# Custom nodes shared library
#-------------------------------------------------------------------------------
add_library(${PROJECT_NAME}_types STATIC ${DWCGF_CHANNEL_FILES})
set_target_properties(${PROJECT_NAME}_types PROPERTIES LINKER_LANGUAGE CXX)
target_link_libraries(${PROJECT_NAME}_types PRIVATE ${LIBRARIES})
target_include_directories(${PROJECT_NAME}_types
                           PUBLIC
                           ${CUDA_DIR}/include
                           ${DW_ROOT}/include
                           ${DW_ROOT}/include/3rdparty
                           ${DW_ROOT}/include/dwshared/dwfoundation
                           ${DW_ROOT}/include/dwshared/dwtrace)

cuda_add_library(${PROJECT_NAME} SHARED ${DWCGF_NODES_FILES})
target_link_libraries(${PROJECT_NAME} PRIVATE ${LIBRARIES} ${PROJECT_NAME}_types)
target_include_directories(${PROJECT_NAME}
                           PUBLIC
                           src/
                           ${CUDA_DIR}/include
                           ${DW_ROOT}/include
                           ${DW_ROOT}/include/3rdparty
                           ${DW_ROOT}/include/dwshared/dwfoundation
                           ${DW_ROOT}/include/dwshared/dwtrace)

# zs:
set(DWCGF_FILE_PREFIX "DWCGFImagePipe")

set(DWCGF_YAML ${CMAKE_CURRENT_SOURCE_DIR}/schedule/${DWCGF_FILE_PREFIX}__standardSchedule.yaml)
set(DWCGF_STM ${CMAKE_CURRENT_SOURCE_DIR}/schedule/${DWCGF_FILE_PREFIX}__standardSchedule.stm)

file(GLOB_RECURSE DWCGF_GRAPHS_FILES
    ${DWCGF_GRAPHS_DIR}/*.yaml
    ${DWCGF_GRAPHS_DIR}/*.json
)
# json-validater execute during configuring time.
execute_process(
    COMMAND ${DRIVEWORKS_PATH}/tools/schema/validate_cgfdescriptors.py --ignore-order --ignore-indentation ${DWCGF_GRAPHS_DIR}
    WORKING_DIRECTORY ${DWCGF_GRAPHS_DIR}
    TIMEOUT 3
    RESULT_VARIABLE _EXIT_CODE
    OUTPUT_VARIABLE _OUTPUT_CODE
    COMMAND_ECHO STDOUT
    # OUTPUT_QUIET
    # ERROR_QUIET
    # ECHO_OUTPUT_VARIABLE
    # https://cmake.org/cmake/help/v3.16/command/execute_process.html
)
message(STATUS "${_OUTPUT_CODE}")
# if(NOT _EXIT_CODE EQUAL 0)
#     message(FATAL_ERROR "validate_cgfdescriptors.py failed: please check the json files.")
# endif()
# app2yaml
add_custom_command(
    OUTPUT ${DWCGF_YAML}
    COMMAND ${DRIVEWORKS_PATH}/tools/descriptionScheduleYamlGenerator/descriptionScheduleYamlGenerator.py --app ${DWCGF_GRAPHS_DIR}/app/${DWCGF_FILE_PREFIX}.app.json --output ${DWCGF_FILE_PREFIX}.app.yaml
    WORKING_DIRECTORY ${DWCGF_SCHE_DIR}
    MAIN_DEPENDENCY ${DWCGF_GRAPHS_DIR}/app/${DWCGF_FILE_PREFIX}.app.json
    DEPENDS ${DWCGF_GRAPHS_FILES}
    COMMENT "app2yaml...!"
    VERBATIM
)
add_custom_target(${PROJECT_NAME}_yaml ALL DEPENDS ${DWCGF_YAML})
# yaml2stm
add_custom_command(
    OUTPUT ${DWCGF_STM}
    COMMAND ${DRIVEWORKS_PATH}/tools/stmcompiler -i ${DWCGF_YAML}
    WORKING_DIRECTORY ${DWCGF_SCHE_DIR}
    MAIN_DEPENDENCY ${DWCGF_YAML}
    DEPENDS ${PROJECT_NAME}_yaml
    COMMENT "yaml2stm...!"
    VERBATIM
)
add_custom_target(${PROJECT_NAME}_stm ALL DEPENDS ${DWCGF_STM})
# stmvizgraph
# stmvizschedule

# install
# https://blog.csdn.net/qq_38410730/article/details/102837401
set(GW_MODULE_GRAPHS_DESTINATION ${GW_MODULE_INSTALL_PREFIX}/graphs/${PROJECT_NAME})
set(GW_MODULE_SCHE_DESTINATION ${GW_MODULE_INSTALL_PREFIX}/sche/${PROJECT_NAME})
set(GW_MODULE_DATA_DESTINATION ${GW_MODULE_INSTALL_PREFIX}/data/${PROJECT_NAME})
gw_add_module(${PROJECT_NAME})
install(FILES ${DWCGF_YAML} DESTINATION "${GW_MODULE_BINARY_DESTINATION}")
install(FILES ${DWCGF_STM} DESTINATION "${GW_MODULE_BINARY_DESTINATION}")
install(DIRECTORY ${DWCGF_GRAPHS_DIR}/ DESTINATION ${GW_MODULE_GRAPHS_DESTINATION})
# todo: 自动删去scheme的那一行，再拷贝过去
install(DIRECTORY ${DWCGF_DATA_DIR}/ DESTINATION ${GW_MODULE_DATA_DESTINATION})
install(PROGRAMS
    ${DWCGF_RUNNER} ${DWCGF_RIG_TESTER}
    DESTINATION "${GW_MODULE_BINARY_DESTINATION}"
)
