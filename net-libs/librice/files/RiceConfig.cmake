# RiceConfig.cmake - Compatibility layer for WebKitGTK 2.52.1 find_package(Rice 0.1.1 COMPONENTS Io Proto)
# This shim makes librice 0.4.x appear as Rice 0.1.1 to WebKit's FindRice.cmake

cmake_minimum_required(VERSION 3.10)

set(Rice_VERSION "@RICE_VERSION@")
set(Rice_VERSION_MAJOR @RICE_MAJOR_VERSION@)
set(Rice_VERSION_MINOR @RICE_MINOR_VERSION@)
set(Rice_VERSION_PATCH @RICE_PATCH_VERSION@)

find_package(PkgConfig REQUIRED QUIET)

pkg_check_modules(Rice_Io  REQUIRED rice-io)
pkg_check_modules(Rice_Proto REQUIRED rice-proto)

# Set variables that WebKit expects
set(Rice_FOUND TRUE)
set(Rice_INCLUDE_DIRS ${Rice_Io_INCLUDE_DIRS} ${Rice_Proto_INCLUDE_DIRS})
set(Rice_LIBRARIES    ${Rice_Io_LIBRARIES}    ${Rice_Proto_LIBRARIES})

set(Rice_Io_FOUND TRUE)
set(Rice_Io_INCLUDE_DIRS ${Rice_Io_INCLUDE_DIRS})
set(Rice_Io_LIBRARIES    ${Rice_Io_LIBRARIES})

set(Rice_Proto_FOUND TRUE)
set(Rice_Proto_INCLUDE_DIRS ${Rice_Proto_INCLUDE_DIRS})
set(Rice_Proto_LIBRARIES    ${Rice_Proto_LIBRARIES})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Rice
    REQUIRED_VARS Rice_INCLUDE_DIRS Rice_LIBRARIES
    VERSION_VAR Rice_VERSION
    HANDLE_COMPONENTS
)

# Optional: Create nice imported targets
if(Rice_FOUND AND NOT TARGET Rice::Io)
    add_library(Rice::Io INTERFACE IMPORTED)
    set_target_properties(Rice::Io PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Rice_Io_INCLUDE_DIRS}"
        INTERFACE_LINK_LIBRARIES "${Rice_Io_LIBRARIES}"
    )
endif()

if(Rice_FOUND AND NOT TARGET Rice::Proto)
    add_library(Rice::Proto INTERFACE IMPORTED)
    set_target_properties(Rice::Proto PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Rice_Proto_INCLUDE_DIRS}"
        INTERFACE_LINK_LIBRARIES "${Rice_Proto_LIBRARIES}"
    )
endif()
