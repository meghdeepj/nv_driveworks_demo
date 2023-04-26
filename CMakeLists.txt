cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

#-------------------------------------------------------------------------------
# Set basic configurations
#-------------------------------------------------------------------------------
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(GwSetBuildType) # Set the build type before project is created

set(SDK_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(SDK_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})
set(SDK_BINARY_DIR ${CMAKE_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${SDK_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${SDK_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${SDK_BINARY_DIR}/lib)
message(STATUS "SDK_SOURCE_DIR is: "  ${SDK_SOURCE_DIR})
message(STATUS "SDK_BINARY_DIR is: "  ${SDK_BINARY_DIR})
message(STATUS "CMAKE_RUNTIME_OUTPUT_DIRECTORY is: "  ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
message(STATUS "CMAKE_LIBRARY_OUTPUT_DIRECTORY is: "  ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
message(STATUS "CMAKE_ARCHIVE_OUTPUT_DIRECTORY is: "  ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY})

#-------------------------------------------------------------------------------
# Root project
#-------------------------------------------------------------------------------
project(gw_demo C CXX)

#-------------------------------------------------------------------------------
# CUDA host compiler must be set before CUDA is enabled as a language
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Set CUDA_DIR
#-------------------------------------------------------------------------------
# if (DEFINED CUDA_DIR)
#     if((DEFINED CUDA_TOOLKIT_ROOT_DIR) AND (NOT CUDA_TOOLKIT_ROOT_DIR STREQUAL CUDA_DIR))
#         message(FATAL_ERROR "Cannot set both CUDA_DIR and (legacy) CUDA_TOOLKIT_ROOT_DIR")
#     endif()
# elseif (DEFINED CUDA_TOOLKIT_ROOT_DIR)
#     message(WARNING "Please set CUDA_DIR instead of (legacy) CUDA_TOOLKIT_ROOT_DIR")
#     set(CUDA_DIR  ${CUDA_TOOLKIT_ROOT_DIR} CACHE PATH "CUDA Toolkit location.")
# else()
#     set(CUDA_DIR  "/usr/local/cuda/" CACHE PATH "CUDA Toolkit location.")
# endif()
# if(NOT CMAKE_CUDA_COMPILER)
#     set(CMAKE_CUDA_COMPILER "${CUDA_DIR}/bin/nvcc")
# endif()
# set(CMAKE_CUDA_HOST_COMPILER ${CMAKE_CXX_COMPILER})
# enable_language(CUDA)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CUDA_STANDARD 11)
set(CMAKE_C_STANDARD 99)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

#-------------------------------------------------------------------------------
# System packages
#-------------------------------------------------------------------------------
find_package(EGL)
find_package(Threads REQUIRED)
# 暂不启用单元测试
# find_package(GTest)

#-------------------------------------------------------------------------------
# Basic configuration
#-------------------------------------------------------------------------------
include(ArchConfiguration)
include(GwConfiguration)
include(ResourcesConfiguration)
include(Gw3rdparty)
include(GwInstallConfiguration)
include(GwPackageConfiguration)
include(UploadVibrante)
include(MakeCUDASourceLibs)
if(GTest_FOUND)
    # Don't enable testing until after building dependencies
    enable_testing()
    # in vscode using CTest as a test client
    include(CTest)
    include(GWTest)
endif()

#-------------------------------------------------------------------------------
# CUDA dependency
# Note: needs to be after defining all configurations
#-------------------------------------------------------------------------------
find_package(CUDA)
if(VIBRANTE)
    list(APPEND CUDA_NVCC_FLAGS -lineinfo --gpu-architecture=compute_53)
    list(APPEND CUDA_NVCC_FLAGS --gpu-code=sm_60,sm_62,sm_72,compute_53)
else()
    list(APPEND CUDA_NVCC_FLAGS -lineinfo --gpu-architecture=compute_53)
    if(NOT CUDA_HOST_GPU_CODE_FLAGS)
        list(APPEND CUDA_NVCC_FLAGS --gpu-code=compute_53)
    else()
        # Compile for local host arch only
        list(APPEND CUDA_NVCC_FLAGS ${CUDA_HOST_GPU_CODE_FLAGS})
    endif()
endif()
set(CUDA_NON_PROPAGATED_HOST_FLAGS "-Wold-style-cast") # disable certain CUDA flags to be not propagated
list(APPEND CUDA_NVCC_FLAGS -std=c++11)
include_directories(SYSTEM ${CUDA_TOOLKIT_INCLUDE})
if(NOT CMAKE_CUDA_COMPILER)
    set(CMAKE_CUDA_COMPILER "${CUDA_TOOLKIT_ROOT_DIR}/bin/nvcc")
endif()
set(CMAKE_CUDA_HOST_COMPILER ${CMAKE_CXX_COMPILER})
enable_language(CUDA)

#-------------------------------------------------------------------------------
# DriveWorks SDK
#-------------------------------------------------------------------------------
set(DW_ROOT /usr/local/driveworks)
find_package(CUDART MODULE REQUIRED)
find_package(cuBLAS MODULE REQUIRED)
find_package(driveworks REQUIRED CONFIG HINTS ${DW_ROOT}/cmake)
find_package(driveworks-visualization REQUIRED CONFIG HINTS ${DW_ROOT}/cmake)
find_package(driveworks-shared REQUIRED CONFIG HINTS ${DW_ROOT}/cmake)
find_package(dwdynamicmemory REQUIRED CONFIG HINTS ${DW_ROOT}/cmake)

set(Driveworks_LIBRARIES
    CUDART::CUDART
    cuBLAS::cuBLAS
    driveworks
    driveworks-shared
    driveworks-visualization
    ${CUDA_CUDA_LIBRARY}
)

if(VIBRANTE)
    list(APPEND Driveworks_LIBRARIES ${vibrante_LIBRARIES} ${vibrante_Xlibs_LIBRARIES})
    find_package(cuDLA MODULE)
    if(cuDLA_FOUND)
        list(APPEND Driveworks_LIBRARIES cuDLA::cuDLA)
    endif()
    find_package(cuPVA MODULE)
    if(cuPVA_FOUND)
        list(APPEND Driveworks_LIBRARIES cuPVA::cuPVA)
    endif()
    find_package(NvMedia MODULE)
    if(NvMedia_FOUND)
        include_directories(${NvMedia_INCLUDE_DIR})
        list(APPEND Driveworks_LIBRARIES NvMedia::NvMedia)
    else()
        message(STATUS "Skipping nvmedia settings.")
    endif()
endif()

if (VIBRANTE OR DW_EXPERIMENTAL_FORCE_EGL)
    list(APPEND Driveworks_LIBRARIES ${EGL_LIBRARIES})
endif()

#-------------------------------------------------------------------------------
# gw_demos
#-------------------------------------------------------------------------------
set(SAMPLES dwcgf;)
foreach(SAMPLE ${SAMPLES})
    add_subdirectory(example/${SAMPLE})
endforeach()

set(MODULES module_demo;xplatform;)
foreach(MODULE ${MODULES})
    add_subdirectory(modules/${MODULE})
endforeach()
# Create a symlink '_data' to '<DW-install>/data' in the build folder's root, so that `DataPath`
# can lookup the required path independent of the build folder's location relative to the
# repository's root
if(NOT EXISTS "${DW_ROOT}/data/DATA_ROOT")
    message(WARNING "Expected data root '${DW_ROOT}/data/DATA_ROOT' not available, "
                    "likely because DW sample code was moved from install location or installation is incomplete. "
                    "Samples will likely not run correctly")
endif()

message(STATUS "zs: LINUX is: ${LINUX}")
message(STATUS "zs: VIBRANTE is: ${VIBRANTE}")

install(
    DIRECTORY docker
    DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/target/
    USE_SOURCE_PERMISSIONS
    PATTERN ".gitkeep" EXCLUDE
)
