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

# install后加上包名或项目名，类似于ROS: 这个实现比较困难，ld path复杂
# https://stackoverflow.com/questions/58997230/cmake-project-fails-to-find-shared-library
# https://stackoverflow.com/questions/43330165/how-to-link-a-shared-library-with-cmake-with-relative-path
# https://stackoverflow.com/questions/70605379/how-to-correctly-set-rpath-to-shared-library-with-cmake
# readelf -d ./executable | grep path

set(BUILD_RPATH_USE_ORIGIN TRUE)

set(SDK_RUNTIME_DESTINATION  "bin")
set(SDK_LIBRARY_DESTINATION  "lib")

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX
        "${SDK_BINARY_DIR}/../install" CACHE PATH
        "Install path prefix, prepended onto install directories." FORCE
    )
endif()

# /opt/gw_demo/bin is the path in the target system
if(CMAKE_LIBRARY_ARCHITECTURE MATCHES "^aarch64-(linux-gnu|unknown-nto-qnx)$")
    set(CMAKE_INSTALL_RPATH /opt/gw_demo/bin /usr/local/driveworks/lib \$ORIGIN \$ORIGIN/../lib)
else()
    set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${SDK_RUNTIME_DESTINATION}" \$ORIGIN \$ORIGIN/../lib)
endif()

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH ON)

if(CMAKE_LIBRARY_ARCHITECTURE STREQUAL aarch64-linux-gnu)
    message(STATUS
        "**** Please copy the contents of `${CMAKE_INSTALL_PREFIX}/${SDK_RUNTIME_DESTINATION}' "
        "on the host filesystem to `/opt/gw_demo/bin' on the "
        "target filesystem. ****"
    )
elseif(CMAKE_LIBRARY_ARCHITECTURE STREQUAL aarch64-unknown-nto-qnx)
    message(STATUS
        "**** Please mount `${CMAKE_INSTALL_PREFIX}/${SDK_RUNTIME_DESTINATION}' "
        "on the host filesystem onto `/opt/gw_demo/bin' on "
        "the target filesystem using NFS. ****"
    )
else()
    message(STATUS
        "**** Samples will be installed to `${CMAKE_INSTALL_PREFIX}/${SDK_RUNTIME_DESTINATION}' "
        "on the host filesystem. ****"
        )
endif()
