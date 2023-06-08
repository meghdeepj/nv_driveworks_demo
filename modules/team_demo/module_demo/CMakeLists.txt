project(module_demo VERSION 0.1.0 LANGUAGES C CXX)

include(GWModuleInstallConfig)

set(DRIVEWORKS_PATH "/usr/local/driveworks")
set(GW_MODULE_LIB_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(GW_HEADER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)

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
# shared library
#-------------------------------------------------------------------------------
include_directories(
    ${GW_HEADER_DIR}
)
file(GLOB_RECURSE GW_MODULE_LIB_FILES
    ${GW_MODULE_LIB_DIR}/*.hpp
    ${GW_MODULE_LIB_DIR}/*.cpp
    ${GW_MODULE_LIB_DIR}/*.c
    ${GW_MODULE_LIB_DIR}/*.h
)
add_library(${PROJECT_NAME} SHARED ${GW_MODULE_LIB_FILES})
target_include_directories(${PROJECT_NAME} PUBLIC
    ${CUDA_DIR}/include
    ${DW_ROOT}/include
    ${DW_ROOT}/include/3rdparty
    ${DW_ROOT}/include/dwshared/dwfoundation
    ${DW_ROOT}/include/dwshared/dwtrace
)
# 库的版本号，debug标识和平台
set_target_properties(${PROJECT_NAME} PROPERTIES
    VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    # SOVERSION ${PROJECT_VERSION_MAJOR}
)
set_target_properties(${PROJECT_NAME} PROPERTIES
    HEADER_DIR ${GW_HEADER_DIR}
)
gw_add_module(${PROJECT_NAME})
# https://stackoverflow.com/questions/10487256/cmake-how-to-properly-copy-static-librarys-header-file-into-usr-include
# todo: 拷贝自动化

#-------------------------------------------------------------------------------
# unit tests
#-------------------------------------------------------------------------------
if(GTest_FOUND)
    add_executable(${PROJECT_NAME}_test ./test/demo/demo_test.cpp)
    target_include_directories(${PROJECT_NAME}_test PUBLIC ${GTEST_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME}_test PRIVATE ${PROJECT_NAME} GTest::gtest)
    gw_add_tests(TARGET ${PROJECT_NAME}_test TEST_TYPE UNIT)
    gw_add_module(${PROJECT_NAME}_test)
endif()

#-------------------------------------------------------------------------------
# executable
#-------------------------------------------------------------------------------
add_executable(${PROJECT_NAME}_main
    tool/main.cpp
)
target_link_libraries(${PROJECT_NAME}_main
    PRIVATE
    ${PROJECT_NAME}
)
gw_add_module(${PROJECT_NAME}_main)
