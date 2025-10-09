# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: libstdcxx-compat.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: GCC_COMPAT templates
# @DESCRIPTION:
# Common macro expanded like array values for GCC_COMPAT.

if [[ -z ${_LIBSTDCXX_COMPAT_ECLASS} ]] ; then
_LIBSTDCXX_COMPAT_ECLASS=1

#
# Ebuild developer draft/tentative plan for ebuilds.
#
# There are 3 identified cases for *DEPENDs:
#
# 1. LTS only packages
# 2. Pure non-LTS
# 3. Mixed LTS with non LTS
#
# LTS packages are defined as -std=c++17 or earlier.
# Non-LTS packages are defined as -std=c++20 or later.
#
# Goals:
#
# 1. LTS packages are consistently built with the chosen GLIBCXX_ version.
# 2. No versioned symbols errors.
# 3. Ensure proper GPU stack support.
# 4. LTS packages are always unaffected by experimental C++ packages.
# 5. Isolate narcissistic/subversive/disposable bleeding edge C++ standard packages from conforming/collaborative/responsive higher quality LTS packages.
# 6. Fixing the build order.  LTS C++ standard packages get built first, experimental c++ standard packages afterwards.
# 7. Verification that the LTS packages are not contaminated with experimental C++ settings.
#    a.  If contaminated, then force version limit or disable feature.
#
# Proposed solution for USEFLAG conflicts:
#
# 1.  LTS package case:  Use USEDEP without hesitation in *DEPENDs.
# 2.  Pure non-LTS case:  Use USEDEP without hesitation in *DEPENDs.
# 3.  Mixed LTS with non LTS:
#     a.  If the current package is non-LTS, in the same package LTS packages get USEDEP_LTS="gcc_slot_skip(+)" placeholder while non-LTS get USEDEP.
#     b.  If the current package is LTS, in the same package LTS packages get USEDEP while non-LTS get USEDEP_DEV="gcc_slot_skip(+)" placeholder.
#

# GCC_COMPAT template for ROCm based apps/libs with latest security update
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_ROCM[@]}
# )
#
LIBSTDCXX_COMPAT_ROCM=(
	"gcc_slot_12_5" # Support ROCm 6.4, 7.0
        "gcc_slot_13_4" # Support ROCm 6.4, 7.0
)

# GCC_COMPAT template for CUDA based apps/libs
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_CUDA[@]}
# )
#
LIBSTDCXX_COMPAT_CUDA=(
        "gcc_slot_11_5" # Support CUDA 11.8, 12.3, 12.4, 12.5, 12.6, 12.8, 12.9
        "gcc_slot_12_5" # Support CUDA 12.3, 12.4, 12.5, 12.6, 12.8, 12.9
        "gcc_slot_13_4" # Support CUDA 12.4, 12.5, 12.6, 12.8, 12.9
        "gcc_slot_14_3" # Support CUDA 12.8, 12.9
)

# GCC_COMPAT template for CUDA 11.x based apps/libs
#
# Status:  Used in production
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_CUDA11[@]}
# )
#
LIBSTDCXX_COMPAT_CUDA11=(
	"gcc_slot_11_5" # Support CUDA 11.8
)

# GCC_COMPAT template for CUDA 12.x based apps/libs
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_CUDA12[@]}
# )
#
LIBSTDCXX_COMPAT_CUDA12=(
        "gcc_slot_11_5" # Support CUDA 12.3, 12.4, 12.5, 12.6, 12.8, 12.9
        "gcc_slot_12_5" # Support CUDA 12.3, 12.4, 12.5, 12.6, 12.8, 12.9
        "gcc_slot_13_4" # Support CUDA 12.4, 12.5, 12.6, 12.8, 12.9
        "gcc_slot_14_3" # Support CUDA 12.8, 12.9
)

# GCC_COMPAT template for GPU based apps/libs
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_GPU[@]}
# )
#
LIBSTDCXX_COMPAT_GPU=(
        "gcc_slot_11_5" # Support CUDA 11.8, 12.3, 12.4, 12.5, 12.6, 12.8, 12.9
        "gcc_slot_12_5" # Support CUDA 12.3, 12.4, 12.5, 12.6, 12.8, 12.9; ROCm 6.4, 7.0
        "gcc_slot_13_4" # Support CUDA 12.4, 12.5, 12.6, 12.8, 12.9; ROCm 6.4, 7.0
        "gcc_slot_14_3" # Support CUDA 12.8, 12.9
)

# GCC_COMPAT template for desktop based LTS distros
#
# Status:  Production ready
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_LTS[@]}
# )
#
LIBSTDCXX_COMPAT_LTS=(
	"gcc_slot_11_5" # Support U22
        "gcc_slot_12_5" # Support D12
        "gcc_slot_13_4" # Support U24
        "gcc_slot_14_3" # Support D13
)

# GCC_COMPAT template for -std=c++98 projects
#
# Status:  Used in production
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_STDCXX98[@]}
# )
#
LIBSTDCXX_COMPAT_STDCXX98=(
	"gcc_slot_11_5" # Support -std=c++98
        "gcc_slot_12_5" # Support -std=c++98
        "gcc_slot_13_4" # Support -std=c++98
        "gcc_slot_14_3" # Support -std=c++98
)

# GCC_COMPAT template for -std=c++03 projects
#
# Status:  Used in production
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_STDCXX03[@]}
# )
#
LIBSTDCXX_COMPAT_STDCXX03=(
	"gcc_slot_11_5" # Support -std=c++03
        "gcc_slot_12_5" # Support -std=c++03
        "gcc_slot_13_4" # Support -std=c++03
        "gcc_slot_14_3" # Support -std=c++03
)

# GCC_COMPAT template for -std=c++11 projects
#
# Status:  Used in production
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_STDCXX11[@]}
# )
#
LIBSTDCXX_COMPAT_STDCXX11=(
	"gcc_slot_11_5" # Support -std=c++11
        "gcc_slot_12_5" # Support -std=c++11
        "gcc_slot_13_4" # Support -std=c++11
        "gcc_slot_14_3" # Support -std=c++11
)

# GCC_COMPAT template for -std=c++14 projects
#
# Status:  Used in production
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_STDCXX14[@]}
# )
#
LIBSTDCXX_COMPAT_STDCXX14=(
	"gcc_slot_11_5" # Support -std=c++14
        "gcc_slot_12_5" # Support -std=c++14
        "gcc_slot_13_4" # Support -std=c++14
        "gcc_slot_14_3" # Support -std=c++14
)

# GCC_COMPAT template for -std=c++17 projects or the compiler default
#
# Status:  Used in production
#
#    Missing feature count for core support for least common denominator:  0
# Missing feature count for library support for least common denominator:  1
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_STDCXX17[@]}
# )
#
LIBSTDCXX_COMPAT_STDCXX17=(
	"gcc_slot_11_5" # Support -std=c++17
        "gcc_slot_12_5" # Support -std=c++17
        "gcc_slot_13_4" # Support -std=c++17
        "gcc_slot_14_3" # Support -std=c++17
)

#
# Ebuild developer plan for ebuilds that mix LTS (<= -std=c++17) with non-LTS (> -std=c++17) C++ standards:
#
# The LTS packages get USEDEP_LTS but disjoint from non-LTS USEDEP.
#

# GCC_COMPAT template for -std=c++20 projects
#
# Status:  Support is still in development
#
#    Missing feature count for core support for least common denominator:  0
# Missing feature count for library support for least common denominator:  1
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_STDCXX20[@]}
# )
#
LIBSTDCXX_COMPAT_STDCXX20=(
	#"gcc_slot_11_5" # Support -std=c++20 (Observed in downstream projects)
        "gcc_slot_13_4" # Support -std=c++20
        "gcc_slot_14_3" # Support -std=c++20
	"gcc_slot_15_2" # Support -std=c++20
        "gcc_slot_16_1" # Support -std=c++20
)

# GCC_COMPAT template for -std=c++23 projects
#
# Status:  Support is still in development
#
#    Missing feature count for core support for least common denominator:   2
# Missing feature count for library support for least common denominator:  14
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_STDCXX23[@]}
# )
#
LIBSTDCXX_COMPAT_STDCXX23=(
	"gcc_slot_15_2" # Support -std=c++23 (Observed in downstream projects)
	"gcc_slot_16_1" # Support -std=c++23
)

# GCC_COMPAT template for -std=c++26 projects
#
# Status:  Support is still in development
#
#    Missing feature count for core support for least common denominator:  10
# Missing feature count for library support for least common denominator:  54
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_STDCXX26[@]}
# )
#
LIBSTDCXX_COMPAT_STDCXX26=(
	"gcc_slot_15_2" # Support -std=c++26 (Observed in downstream projects)
	"gcc_slot_16_1" # Support -std=c++26
)

# A fix for library packages for the following,
#
#   error "Assumed value of MB_LEN_MAX wrong"
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_MB_LEN_MAX_LIB_FIX[@]}
# )
#
LIBSTDCXX_COMPAT_MB_LEN_MAX_LIB_FIX=(
	"gcc_slot_11_5"
	#"gcc_slot_12_5" # Also fixes it but disabled to prevent ABI incompatibility
)

# A fix for application packages for the following,
#
#   error "Assumed value of MB_LEN_MAX wrong"
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBSTDCXX_COMPAT_MB_LEN_MAX_LIB_FIX[@]}
# )
#
LIBSTDCXX_COMPAT_MB_LEN_MAX_APP_FIX=(
	"gcc_slot_11_5"
	"gcc_slot_12_5"
)

fi
