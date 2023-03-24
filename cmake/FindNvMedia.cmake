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
# SPDX-FileCopyrightText: Copyright (c) 2022 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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

# FindNvMedia
# -----------
#
# Finds the NvMedia libraries for hardware-accelerated processing of image and video data.
#
# Imported Targets
# ^^^^^^^^^^^^^^^^
#
# This module provides the following imported targets, if found:
#
# ``NvMedia::NvMedia``
#   The NvMedia library.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This will define the following variables:
#
# ``NvMedia_FOUND``
#   True if the system has the NvMedia library.
# ``NvMedia_VERSION``
#   The version of the NvMedia library that was found.
# ``NvMedia_INCLUDE_DIRS``
#   Include directories needed to use NvMedia.
# ``NvMedia_LIBRARIES``
#   Libraries needed to link to NvMedia.
#
# Cache Variables
# ^^^^^^^^^^^^^^^
#
# The following cache variables may also be set:
#
# ``NvMedia_INCLUDE_DIR``
#   The directory containing ``nvmedia_core.h``.
# ``NvMedia_LIBRARY``
#   The path to ``libnvmedia.so`` or ``libnvmedia_core.so``.
# in driveworks
# libnvmedia.so
# libnvmedia_2d.so
# libnvmedia_core.so
# libnvmedia_isp.so
# libnvmediabbfldr_isp.so

# in drive-linux
# NvMedia_2D_LIBRARY
#  libnvmedia2d.so
# NvMedia_Dla_LIBRARY
#  libnvmedia_dla.so
# NvMedia_EglStream_LIBRARY
#  libnvmedia_eglstream.so
# NvMedia_IdeParser_LIBRARY
#  libnvmedia_ide_parser.so
# NvMedia_IdeSci_LIBRARY
#  libnvmedia_ide_sci.so
# NvMedia_IepSci_LIBRARY
#  libnvmedia_iep_sci.so
# NvMedia_IjpdSci_LIBRARY
#  libnvmedia_ijpd_sci.so
# NvMedia_IjpeSci_LIBRARY
#  libnvmedia_ijpe_sci.so
# NvMedia_IofaSci_LIBRARY
#  libnvmedia_iofa_sci.so
# NvMedia_SciOverlay_LIBRARY
#  libnvmedia_sci_overlay.so
# NvMedia_Tensor_LIBRARY
#  libnvmedia_tensor.so
# NvMedia_Ldc_LIBRARY
#  libnvmedialdc.so

set(_NVMEDIA_FIND_LIBRARY_PATHS)
set(_NVMEDIA_FIND_PATH_PATHS)

if(CMAKE_LIBRARY_ARCHITECTURE MATCHES "^(aarch64-linux-gnu|aarch64-unknown-nto-qnx)$")
  if(VIBRANTE_PDK)
    list(APPEND _NVMEDIA_FIND_LIBRARY_PATHS "${VIBRANTE_PDK}/lib-target")
    list(APPEND _NVMEDIA_FIND_PATH_PATHS "${VIBRANTE_PDK}/include/nvmedia_6x")
  endif()
endif()

# list(APPEND _NVMEDIA_FIND_LIBRARY_PATHS "/usr/local/driveworks/lib")
# list(APPEND _NVMEDIA_FIND_PATH_PATHS "/usr/local/driveworks/include")

find_path(NvMedia_INCLUDE_DIR
  NAMES nvmedia_core.h
  PATHS ${_NVMEDIA_FIND_PATH_PATHS}
)
unset(_NVMEDIA_FIND_PATH_PATHS)

set(_NVMEDIA_SONAME
  "${CMAKE_SHARED_LIBRARY_PREFIX}nvmedia${CMAKE_SHARED_LIBRARY_SUFFIX}"
)
find_library(NvMedia_LIBRARY
  NAMES "${_NVMEDIA_SONAME}"
  PATHS ${_NVMEDIA_FIND_LIBRARY_PATHS}
)
if(NOT NvMedia_LIBRARY)
  set(_NVMEDIA_SONAME
    "${CMAKE_SHARED_LIBRARY_PREFIX}nvmedia_core${CMAKE_SHARED_LIBRARY_SUFFIX}"
  )
  find_library(NvMedia_LIBRARY
    NAMES "${_NVMEDIA_SONAME}"
    PATHS ${_NVMEDIA_FIND_LIBRARY_PATHS}
  )
endif()
unset(_NVMEDIA_FIND_LIBRARY_PATHS)

# set(NvMedia_VERSION)
# if(NvMedia_INCLUDE_DIR AND NvMedia_LIBRARY)
#     file(STRINGS "${NvMedia_INCLUDE_DIR}/nvmedia_core.h" _NVMEDIA_VERSION_STRINGS
#         REGEX "^#define NVMEDIA_RELEASE_VERSION_(MAJOR|MINOR)[ ]+[0-9]+$"
#     )
#     string(REGEX REPLACE ".*;#define NVMEDIA_RELEASE_VERSION_MAJOR[ ]+([0-9]+);.*"
#         "\\1" NvMedia_VERSION_MAJOR ";${_NVMEDIA_VERSION_STRINGS};"
#     )
#     string(REGEX REPLACE ".*;#define NVMEDIA_RELEASE_VERSION_MINOR[ ]+([0-9]+);.*"
#         "\\1" NvMedia_VERSION_MINOR ";${_NVMEDIA_VERSION_STRINGS};"
#     )
#     unset(_NVMEDIA_VERSION_STRINGS)
#     set(NvMedia_VERSION "${NvMedia_VERSION_MAJOR}.${NvMedia_VERSION_MINOR}")
# endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NvMedia
  FOUND_VAR NvMedia_FOUND
  REQUIRED_VARS NvMedia_INCLUDE_DIR NvMedia_LIBRARY
  # VERSION_VAR NvMedia_VERSION
)

if(NvMedia_FOUND)
  set(NvMedia_INCLUDE_DIRS "${NvMedia_INCLUDE_DIR}")
  set(NvMedia_LIBRARIES "${NvMedia_LIBRARY}")
  mark_as_advanced(NvMedia_INCLUDE_DIR NvMedia_LIBRARY)

  if(NOT TARGET NvMedia::NvMedia)
    add_library(NvMedia::NvMedia SHARED IMPORTED)
    set_target_properties(NvMedia::NvMedia PROPERTIES
      IMPORTED_LOCATION "${NvMedia_LIBRARY}"
      IMPORTED_SONAME "${_NVMEDIA_SONAME}"
      INTERFACE_INCLUDE_DIRECTORIES "${NvMedia_INCLUDE_DIR}"
    )
  endif()
endif()
unset(_NVMEDIA_SONAME)
