# FindSSM
# -----------
#
# Finds the SSM libraries for hardware-accelerated processing of image and video data.
#
# Imported Targets
# ^^^^^^^^^^^^^^^^
#
# This module provides the following imported targets, if found:
#
# ``SSM::SSM``
#   The SSM library.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This will define the following variables:
#
# ``SSM_FOUND``
#   True if the system has the SSM library.
# ``SSM_VERSION``
#   The version of the SSM library that was found.
# ``SSM_INCLUDE_DIRS``
#   Include directories needed to use SSM.
# ``SSM_LIBRARIES``
#   Libraries needed to link to SSM.
#
# Cache Variables
# ^^^^^^^^^^^^^^^
#
# The following cache variables may also be set:
#
# ``SSM_LIBRARY``
#   The path to ``libssm.so`` or ``libssm_framework.so`` or ``libssm_release``.


set(_SSM_FIND_LIBRARY_PATHS)

if(CMAKE_LIBRARY_ARCHITECTURE MATCHES "^(aarch64-linux-gnu|aarch64-unknown-nto-qnx)$")
  if(VIBRANTE_PDK)
    list(APPEND _SSM_FIND_LIBRARY_PATHS
      "/usr/local/driveworks/targets/${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_SYSTEM_NAME}/lib"
    )
  endif()
endif()
# list(APPEND _SSM_FIND_LIBRARY_PATHS "/usr/local/driveworks/lib")

set(_SSM_SSM_SONAME
  "${CMAKE_SHARED_LIBRARY_PREFIX}ssm${CMAKE_SHARED_LIBRARY_SUFFIX}"
)
find_library(SSM_SSM_LIBRARY
  NAMES "${_SSM_SSM_SONAME}"
  PATHS ${_SSM_FIND_LIBRARY_PATHS}
)
set(_SSM_FRAMEWORK_SONAME
  "${CMAKE_SHARED_LIBRARY_PREFIX}ssm_framework${CMAKE_SHARED_LIBRARY_SUFFIX}"
)
find_library(SSM_FRAMEWORK_LIBRARY
  NAMES "${_SSM_FRAMEWORK_SONAME}"
  PATHS ${_SSM_FIND_LIBRARY_PATHS}
)
set(_SSM_RELEASE_SONAME
  "${CMAKE_SHARED_LIBRARY_PREFIX}ssm_release${CMAKE_SHARED_LIBRARY_SUFFIX}"
)
find_library(SSM_RELEASE_LIBRARY
  NAMES "${_SSM_RELEASE_SONAME}"
  PATHS ${_SSM_FIND_LIBRARY_PATHS}
)
unset(_SSM_FIND_LIBRARY_PATHS)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SSM
  FOUND_VAR SSM_FOUND
  REQUIRED_VARS SSM_FRAMEWORK_LIBRARY
  # VERSION_VAR SSM_VERSION
)

if(SSM_FOUND)
  set(SSM_LIBRARIES "${SSM_SSM_LIBRARY} ${SSM_FRAMEWORK_LIBRARY}" "${SSM_RELEASE_LIBRARY}")

  if(NOT TARGET SSM::SSM)
    add_library(SSM::SSM SHARED IMPORTED)
    set_target_properties(SSM::SSM PROPERTIES
      IMPORTED_LOCATION "${SSM_SSM_LIBRARY}"
      IMPORTED_SONAME "${_SSM_SSM_SONAME}"
      # INTERFACE_INCLUDE_DIRECTORIES "${SSM_INCLUDE_DIR}"
    )
    mark_as_advanced(SSM_SSM_LIBRARY)
  endif()
  if(NOT TARGET SSM::FRAMEWORK)
    add_library(SSM::FRAMEWORK SHARED IMPORTED)
    set_target_properties(SSM::FRAMEWORK PROPERTIES
      IMPORTED_LOCATION "${SSM_FRAMEWORK_LIBRARY}"
      IMPORTED_SONAME "${_SSM_FRAMEWORK_SONAME}"
      # INTERFACE_INCLUDE_DIRECTORIES "${SSM_INCLUDE_DIR}"
    )
    mark_as_advanced(SSM_FRAMEWORK_LIBRARY)
  endif()
  if(NOT TARGET SSM::RELEASE)
    add_library(SSM::RELEASE SHARED IMPORTED)
    set_target_properties(SSM::RELEASE PROPERTIES
      IMPORTED_LOCATION "${SSM_RELEASE_LIBRARY}"
      IMPORTED_SONAME "${_SSM_RELEASE_SONAME}"
      # INTERFACE_INCLUDE_DIRECTORIES "${SSM_INCLUDE_DIR}"
    )
    mark_as_advanced(SSM_RELEASE_LIBRARY)
  endif()
endif()

unset(_SSM_SSM_SONAME)
unset(_SSM_FRAMEWORK_SONAME)
unset(_SSM_RELEASE_SONAME)
