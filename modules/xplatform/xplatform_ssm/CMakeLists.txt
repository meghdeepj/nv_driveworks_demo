project(xplatform_ssm C CXX)

include(GWModuleInstallConfig)

set(DRIVEWORKS_PATH "/usr/local/driveworks")

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

foreach(SSM ${DWCGF_SSMS})
    set(DWCGF_SSM_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/${SSM})
    set(DWCGF_SSM_INC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include/${SSM})
    file(GLOB_RECURSE DWCGF_SSM_FILES
        ${DWCGF_SSM_SRC_DIR}/*.hpp
        ${DWCGF_SSM_SRC_DIR}/*.cpp
        ${DWCGF_SSM_SRC_DIR}/*.cu
        ${DWCGF_SSM_SRC_DIR}/*.cuh
    )
    add_executable(${PROJECT_NAME}_${SSM} ${DWCGF_SSM_FILES})
    target_link_libraries(${PROJECT_NAME}_${SSM} PRIVATE ${LIBRARIES})
    target_include_directories(${PROJECT_NAME}_${SSM} PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/framework
        ${DWCGF_SSM_INC_DIR}
        ${CUDA_DIR}/include
        ${DW_ROOT}/include
        ${DW_ROOT}/include/3rdparty
        ${DW_ROOT}/include/dwshared/dwfoundation
        ${DW_ROOT}/include/dwshared/dwtrace
    )
    gw_add_module(${PROJECT_NAME}_${SSM})
endforeach()
