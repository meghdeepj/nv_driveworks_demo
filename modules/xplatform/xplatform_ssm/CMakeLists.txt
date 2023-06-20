project(xplatform_ssm C CXX)

include(GWModuleInstallConfig)

set(DRIVEWORKS_PATH "/usr/local/driveworks")
set(DWCGF_SSM_FRAMEWORK_DIR ${CMAKE_CURRENT_SOURCE_DIR}/framework)
set(DWCGF_SSM_JSON_DIR  ${CMAKE_CURRENT_SOURCE_DIR}/config)

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
# ssms
#-------------------------------------------------------------------------------
set(DWCGF_SSMS
    demo1;
    # guardian;
)

file(GLOB_RECURSE DWCGF_SSM_JSON
    ${DWCGF_SSM_JSON_DIR}/*.json
)

foreach(SSM ${DWCGF_SSMS})
    set(DWCGF_SSM_GEN_DIR ${CMAKE_CURRENT_SOURCE_DIR}/gen/${SSM})
    set(DWCGF_SSM_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/${SSM})
    set(DWCGF_SSM_GEN_CPP ${CMAKE_CURRENT_SOURCE_DIR}/gen/${SSM}/hierarchy_${SSM}.cpp)
    # parser json2cpp
    add_custom_command(
        OUTPUT ${DWCGF_SSM_GEN_CPP}
        COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/util/parser.py --input ${DWCGF_SSM_JSON_DIR}/${SSM}.json --src ${DWCGF_SSM_GEN_DIR} --include ${DWCGF_SSM_GEN_DIR}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        MAIN_DEPENDENCY ${DWCGF_SSM_JSON_DIR}/${SSM}.json
        DEPENDS ${DWCGF_SSM_JSON}
        COMMENT "json2cpp[${SSM}]...!"
        VERBATIM
    )
    add_custom_target(${PROJECT_NAME}_cpp_${SSM} ALL DEPENDS ${DWCGF_SSM_GEN_CPP})
    # compile gen
    file(GLOB_RECURSE DWCGF_SSM_GEN_FILES
        ${DWCGF_SSM_GEN_DIR}/*.hpp
        ${DWCGF_SSM_GEN_DIR}/*.cpp
        ${DWCGF_SSM_GEN_DIR}/*.cu
        ${DWCGF_SSM_GEN_DIR}/*.cuh
    )
    add_library(${PROJECT_NAME}_gen_${SSM} STATIC ${DWCGF_SSM_GEN_FILES})
    add_dependencies(${PROJECT_NAME}_gen_${SSM} ${PROJECT_NAME}_cpp_${SSM})
    target_link_libraries(${PROJECT_NAME}_gen_${SSM} PRIVATE ${LIBRARIES})
    target_include_directories(${PROJECT_NAME}_gen_${SSM} PUBLIC
        ${DWCGF_SSM_FRAMEWORK_DIR}
        ${DWCGF_SSM_GEN_DIR}/../
        ${CUDA_DIR}/include
        ${DW_ROOT}/include
        ${DW_ROOT}/include/3rdparty
        ${DW_ROOT}/include/dwshared/dwfoundation
        ${DW_ROOT}/include/dwshared/dwtrace
    )
    # compile ssm
    file(GLOB_RECURSE DWCGF_SSM_SRC_FILES
        ${DWCGF_SSM_SRC_DIR}/*.hpp
        ${DWCGF_SSM_SRC_DIR}/*.cpp
        ${DWCGF_SSM_SRC_DIR}/*.cu
        ${DWCGF_SSM_SRC_DIR}/*.cuh
    )
    add_executable(${PROJECT_NAME}_${SSM} ${DWCGF_SSM_SRC_FILES})
    target_link_libraries(${PROJECT_NAME}_${SSM} PRIVATE ${LIBRARIES} ${PROJECT_NAME}_gen_${SSM})
    target_include_directories(${PROJECT_NAME}_${SSM} PUBLIC
        ${DWCGF_SSM_FRAMEWORK_DIR}
        ${DWCGF_SSM_GEN_DIR}/../
        ${DWCGF_SSM_SRC_DIR}/../
        ${CUDA_DIR}/include
        ${DW_ROOT}/include
        ${DW_ROOT}/include/3rdparty
        ${DW_ROOT}/include/dwshared/dwfoundation
        ${DW_ROOT}/include/dwshared/dwtrace
    )
    gw_add_module(${PROJECT_NAME}_${SSM})
endforeach()
