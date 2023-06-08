project(common_cgf_app C CXX)

include(GWModuleInstallConfig)

set(DRIVEWORKS_PATH "/usr/local/driveworks")
set(DWCGF_GRAPHS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/graphs)
set(DWCGF_SCHE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/schedule)
set(DWCGF_DATA_DIR ${CMAKE_CURRENT_SOURCE_DIR}/data)
set(DWCGF_RIG_TESTER ${CMAKE_CURRENT_SOURCE_DIR}/bin/test_rig.sh)

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

# zs:
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

set(DWCGF_APP_LIST
    Helloworld;
    RawCameraDeployPipe;
    VirtualCameraDeployPipe;
    YUVCameraDeployPipe;
    RawCameraTestPipe;
    VirtualCameraTestPipe;
    YUVCameraTestPipe;
)
foreach(DWCGF_APP_TYPE ${DWCGF_APP_LIST})
    set(DWCGF_FILE_PREFIX DWCGF${DWCGF_APP_TYPE})
    set(DWCGF_RUNNER ${CMAKE_CURRENT_SOURCE_DIR}/bin/run${DWCGF_APP_TYPE}.sh)
    set(DWCGF_YAML ${CMAKE_CURRENT_SOURCE_DIR}/schedule/${DWCGF_FILE_PREFIX}__standardSchedule.yaml)
    set(DWCGF_STM ${CMAKE_CURRENT_SOURCE_DIR}/schedule/${DWCGF_FILE_PREFIX}__standardSchedule.stm)
    # app2yaml
    add_custom_command(
        OUTPUT ${DWCGF_YAML}
        COMMAND ${DRIVEWORKS_PATH}/tools/descriptionScheduleYamlGenerator/descriptionScheduleYamlGenerator.py --app ${DWCGF_GRAPHS_DIR}/app${DWCGF_APP_TYPE}/${DWCGF_FILE_PREFIX}.app.json --output ${DWCGF_FILE_PREFIX}.app.yaml
        WORKING_DIRECTORY ${DWCGF_SCHE_DIR}
        MAIN_DEPENDENCY ${DWCGF_GRAPHS_DIR}/app${DWCGF_APP_TYPE}/${DWCGF_FILE_PREFIX}.app.json
        DEPENDS ${DWCGF_GRAPHS_FILES}
        COMMENT "app2yaml[${DWCGF_APP_TYPE}]...!"
        VERBATIM
    )
    add_custom_target(${PROJECT_NAME}_yaml${DWCGF_APP_TYPE} ALL DEPENDS ${DWCGF_YAML})
    # yaml2stm
    add_custom_command(
        OUTPUT ${DWCGF_STM}
        COMMAND ${DRIVEWORKS_PATH}/tools/stmcompiler -i ${DWCGF_YAML}
        WORKING_DIRECTORY ${DWCGF_SCHE_DIR}
        MAIN_DEPENDENCY ${DWCGF_YAML}
        DEPENDS ${PROJECT_NAME}_yaml${DWCGF_APP_TYPE}
        COMMENT "yaml2stm[${DWCGF_APP_TYPE}]...!"
        VERBATIM
    )
    add_custom_target(${PROJECT_NAME}_stm${DWCGF_APP_TYPE} ALL DEPENDS ${DWCGF_STM})
    # stmvizgraph
    # stmvizschedule
    install(FILES ${DWCGF_YAML} DESTINATION "${GW_MODULE_BINARY_DESTINATION}")
    install(FILES ${DWCGF_STM} DESTINATION "${GW_MODULE_BINARY_DESTINATION}")
    install(PROGRAMS ${DWCGF_RUNNER} DESTINATION "${GW_MODULE_BINARY_DESTINATION}")
endforeach()

# install
# https://blog.csdn.net/qq_38410730/article/details/102837401
set(GW_MODULE_GRAPHS_DESTINATION ${GW_MODULE_INSTALL_PREFIX}/graphs/${PROJECT_NAME})
set(GW_MODULE_SCHE_DESTINATION ${GW_MODULE_INSTALL_PREFIX}/sche/${PROJECT_NAME})
set(GW_MODULE_DATA_DESTINATION ${GW_MODULE_INSTALL_PREFIX}/data/${PROJECT_NAME})
install(DIRECTORY ${DWCGF_GRAPHS_DIR}/ DESTINATION ${GW_MODULE_GRAPHS_DESTINATION})
# todo: 自动删去scheme的那一行，再拷贝过去
install(DIRECTORY ${DWCGF_DATA_DIR}/ DESTINATION ${GW_MODULE_DATA_DESTINATION})
install(PROGRAMS
    ${DWCGF_RIG_TESTER}
    DESTINATION "${GW_MODULE_BINARY_DESTINATION}"
)
