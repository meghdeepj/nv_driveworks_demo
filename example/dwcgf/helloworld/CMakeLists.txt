################################################################################
#
# Notice
# ALL NVIDIA DESIGN SPECIFICATIONS AND CODE ("MATERIALS") ARE PROVIDED "AS IS"
# NVIDIA MAKES NO REPRESENTATIONS, WARRANTIES, EXPRESSED, IMPLIED, STATUTORY, OR
# OTHERWISE WITH RESPECT TO THE MATERIALS, AND EXPRESSLY DISCLAIMS ANY IMPLIED
# WARRANTIES OF NONINFRINGEMENT, MERCHANTABILITY, OR FITNESS FOR A PARTICULAR
# PURPOSE.
#
# NVIDIA CORPORATION & AFFILIATES assumes no responsibility for the consequences
# of use of such information or for any infringement of patents or other rights
# of third parties that may result from its use. No license is granted by
# implication or otherwise under any patent or patent rights of NVIDIA
# CORPORATION & AFFILIATES. No third party distribution is allowed unless
# expressly authorized by NVIDIA. Details are subject to change without notice.
# This code supersedes and replaces all information previously supplied. NVIDIA
# CORPORATION & AFFILIATES products are not authorized for use as critical
# components in life support devices or systems without express written approval
# of NVIDIA CORPORATION & AFFILIATES.
#
# SPDX-FileCopyrightText: Copyright (c) 2016-2021 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: LicenseRef-NvidiaProprietary
#
# NVIDIA CORPORATION, its affiliates and licensors retain all intellectual
# property and proprietary rights in and to this material, related documentation
# and any modifications thereto. Any use, reproduction, disclosure or
# distribution of this material and related documentation without an express
# license agreement from NVIDIA CORPORATION or its affiliates is strictly
# prohibited.
#
################################################################################

project(dwcgf_helloworld C CXX)

set(SOURCES
    src/nodes/helloworld/HelloWorldNode.hpp
    src/nodes/helloworld/HelloWorldNodeImpl.cpp
    src/nodes/helloworld/HelloWorldNodeImpl.hpp
    src/nodes/helloworld/HelloWorldNode.cpp
    # src/nodes/sum/SumNode.hpp
    # src/nodes/sum/SumNodeImpl.cpp
    # src/nodes/sum/SumNodeImpl.hpp
    # src/nodes/sum/SumNode.cpp
)

set(DRIVEWORKS_PATH "/usr/local/driveworks")

if (NOT TARGET driveworks-shared)
    find_package(driveworks-shared REQUIRED CONFIG HINTS ${DRIVEWORKS_PATH}/cmake)
endif()

if (NOT TARGET dwframework)
    find_package(dwframework REQUIRED CONFIG HINTS ${DRIVEWORKS_PATH}/cmake)
endif()

set(LIBRARIES
    # samples_framework
    ${Driveworks_LIBRARIES}
    driveworks-shared
    dwframework
)

#-------------------------------------------------------------------------------
# Custom nodes shared library
#-------------------------------------------------------------------------------
add_library(${PROJECT_NAME} SHARED ${SOURCES})
target_link_libraries(${PROJECT_NAME} ${LIBRARIES})
target_include_directories(${PROJECT_NAME}
                           PUBLIC
                           ${CUDA_DIR}/include
                           ${DW_ROOT}/include
                           ${DW_ROOT}/include/3rdparty
                           ${DW_ROOT}/include/dwshared/dwfoundation
                           ${DW_ROOT}/include/dwshared/dwtrace)

set(DWCGF_YAML ${CMAKE_CURRENT_SOURCE_DIR}/schedule/DWCGFHelloworld__standardSchedule.yaml)
set(DWCGF_STM ${CMAKE_CURRENT_SOURCE_DIR}/schedule/DWCGFHelloworld__standardSchedule.stm)

# system2yaml
add_custom_command(
    OUTPUT ${DWCGF_YAML}
    COMMAND ${DRIVEWORKS_PATH}/tools/descriptionScheduleYamlGenerator/descriptionScheduleYamlGenerator.py --app ../graphs/app/DWCGFHelloworld.app.json --output DWCGFHelloworld.app.yaml
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/schedule
    MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/graphs/app/DWCGFHelloworld.app.json
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/graphs
)
add_custom_target(${PROJECT_NAME}_yaml ALL DEPENDS ${DWCGF_YAML})
# yaml2stm
add_custom_command(
    OUTPUT ${DWCGF_STM}
    COMMAND ${DRIVEWORKS_PATH}/tools/stmcompiler -i ${DWCGF_YAML}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/schedule
    MAIN_DEPENDENCY ${DWCGF_YAML}
    DEPENDS
)
add_custom_target(${PROJECT_NAME}_stm ALL DEPENDS ${DWCGF_STM})
# stmvizgraph
# stmvizschedule

# install
sdk_add_sample(${PROJECT_NAME})
set(DWCGF_GRAPH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/graphs)
set(DWCGF_SCHE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/schedule)
set(SDK_GRAPHS_DESTINATION ${CMAKE_INSTALL_PREFIX})
set(SDK_SCHE_DESTINATION ${CMAKE_INSTALL_PREFIX})
install(FILES ${DWCGF_YAML} DESTINATION "${SDK_SAMPLE_DESTINATION}")
install(FILES ${DWCGF_STM} DESTINATION "${SDK_SAMPLE_DESTINATION}")
install(DIRECTORY ${DWCGF_GRAPH_DIR} DESTINATION ${SDK_GRAPHS_DESTINATION})
