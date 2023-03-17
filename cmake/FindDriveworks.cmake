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
# SPDX-FileCopyrightText: Copyright (c) 2016-2022 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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

# - Try to find Driveworks
# Once done, this will define
#
#  Driveworks_FOUND - system has Driveworks
#  Driveworks_INCLUDE_DIRS - the Driveworks include directories
#  Driveworks_LIBRARIES - link these to use Driveworks

include(LibFindMacros)
include(ArchConfiguration)

# Use pkg-config to get hints about paths
libfind_pkg_check_modules(Driveworks_PKGCONF driveworks)

# Use provided driveworks location hints
if(DRIVEWORKS)
  if(IS_ABSOLUTE ${DRIVEWORKS})
    set(DRIVEWORKS_DIR ${DRIVEWORKS} CACHE STRING "Path to the driveworks library location" FORCE)
  else()
    if("${CMAKE_HOST_SYSTEM}" MATCHES ".*Windows.*")
        set(sep "\\")
    else()
        set(sep "/")
    endif()
    get_filename_component(temp "${SDK_BINARY_DIR}${sep}${DRIVEWORKS}" ABSOLUTE)
    set(DRIVEWORKS_DIR ${temp} CACHE STRING "Path to the driveworks library location" FORCE)
  endif()
    message(STATUS "Driveworks location forced to: ${DRIVEWORKS_DIR}")
else()
    set(DRIVEWORKS_DIR "" CACHE STRING "Path to the driveworks library location")
endif()

# Make sure we support cross-compilation out of the default root path
SET(CMAKE_FIND_ROOT_PATH ${CMAKE_FIND_ROOT_PATH} ${DRIVEWORKS_DIR})

# Include dir
find_path(Driveworks_INCLUDE_DIR
  NAMES dw/core/base/Version.h
  HINTS ${DRIVEWORKS_DIR}/targets/${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_SYSTEM_NAME}/include
        ${Driveworks_PKGCONF_INCLUDE_DIRS}/../targets/${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_SYSTEM_NAME}/include
  PATHS ${CMAKE_CURRENT_SOURCE_DIR}/../targets/${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_SYSTEM_NAME}/include
        ${CMAKE_CURRENT_SOURCE_DIR}/../include
        ${DRIVEWORKS_DIR}/include
)

# Finally the library itself
find_library(Driveworks_LIBRARY
  NAMES driveworks
  HINTS ${DRIVEWORKS_DIR}/targets/${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_SYSTEM_NAME}/lib
        ${Driveworks_PKGCONF_LIBRARY_DIRS}/../targets/${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_SYSTEM_NAME}/lib
  PATHS ${CMAKE_CURRENT_SOURCE_DIR}/../targets/${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_SYSTEM_NAME}/lib
        ${CMAKE_CURRENT_SOURCE_DIR}/../lib
        ${DRIVEWORKS_DIR}/lib
)

# Visualization library
find_library(DriveworksVisualization_LIBRARY
  NAMES driveworks_visualization
  HINTS ${DRIVEWORKS_DIR}/targets/${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_SYSTEM_NAME}/lib
        ${Driveworks_PKGCONF_LIBRARY_DIRS}/../targets/${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_SYSTEM_NAME}/lib
  PATHS ${CMAKE_CURRENT_SOURCE_DIR}/../targets/${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_SYSTEM_NAME}/lib
        ${CMAKE_CURRENT_SOURCE_DIR}/../lib
        ${DRIVEWORKS_DIR}/lib
)

if (NOT DRIVEWORKS AND Driveworks_INCLUDE_DIR AND DRIVEWORKS_DIR STREQUAL "")
    get_filename_component(DRIVEWORKS_FROM_INCLUDE ${Driveworks_INCLUDE_DIR} DIRECTORY)
    message(STATUS "Driveworks found at: ${DRIVEWORKS_FROM_INCLUDE}")
    set(DRIVEWORKS_DIR ${DRIVEWORKS_FROM_INCLUDE} CACHE STRING "Path to the driveworks library location" FORCE)
endif()

# Set the include dir variables and the libraries and let libfind_process do the rest.
# NOTE: Singular variables for this library, plural for libraries this this lib depends on.
set(Driveworks_PROCESS_INCLUDES Driveworks_INCLUDE_DIR)
set(Driveworks_PROCESS_LIBS Driveworks_LIBRARY DriveworksVisualization_LIBRARY)
libfind_process(Driveworks)