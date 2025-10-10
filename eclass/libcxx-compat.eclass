# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: libcxx-compat.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: CLANG_COMPAT templates
# @DESCRIPTION:
# Common macro expanded like array values for CLANG_COMPAT.

if [[ -z ${_LIBCXX_COMPAT_ECLASS} ]] ; then
_LIBCXX_COMPAT_ECLASS=1

# Fewer slots are shown because of LTS issues with Python.
# The distro overlay is denying manifest updates to Python 3.10.x and older in
# the python-utils-r1 eclass.  Only releases associated with full access Python
# will be shown.

# GCC_COMPAT template for ROCm based apps/libs with latest security update
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBCXX_COMPAT_ROCM[@]}
# )
#
LIBCXX_COMPAT_ROCM=(
	"llvm_slot_20" # Support ROCm 6.4, 7.0
        "llvm_slot_21" # Support ROCm 6.4, 7.0
)

# GCC_COMPAT template for CUDA based apps/libs
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBCXX_COMPAT_CUDA[@]}
# )
#
LIBCXX_COMPAT_CUDA=(
	"llvm_slot_18" # Support CUDA 12.6, 12.8, 12.9
	"llvm_slot_19" # Support CUDA 12.8, 12.9
)

# GCC_COMPAT template for CUDA 12.x based apps/libs
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBCXX_COMPAT_CUDA12[@]}
# )
#
LIBCXX_COMPAT_CUDA12=(
	"llvm_slot_18" # Support CUDA 12.6, 12.8, 12.9
	"llvm_slot_19" # Support CUDA 12.8, 12.9
)

# GCC_COMPAT template for GPU based apps/libs
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBCXX_COMPAT_GPU[@]}
# )
#
LIBCXX_COMPAT_GPU=(
	"llvm_slot_18" # Support CUDA 12.6, 12.8, 12.9
	"llvm_slot_19" # Support CUDA 12.8, 12.9
	"llvm_slot_20" # Support ROCm 6.4, 7.0
        "llvm_slot_21" # Support ROCm 6.4, 7.0
)

# GCC_COMPAT template for desktop based LTS distros
#
# Status:  Production ready
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBCXX_COMPAT_LTS[@]}
# )
#
LIBCXX_COMPAT_LTS=(
        "llvm_slot_18" # Support U24
        "llvm_slot_19" # Support D13
)

# GCC_COMPAT template for -std=c++98 projects
#
# Status:  Used in production
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX98[@]}
# )
#
LIBCXX_COMPAT_STDCXX98=(
	"llvm_slot_18" # Support -std=c++98
	"llvm_slot_19" # Support -std=c++98
)

# GCC_COMPAT template for -std=c++03 projects
#
# Status:  Used in production
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX03[@]}
# )
#
LIBCXX_COMPAT_STDCXX03=(
	"llvm_slot_18" # Support -std=c++03
	"llvm_slot_19" # Support -std=c++03
)

# GCC_COMPAT template for -std=c++11 projects
#
# Status:  Used in production
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX11[@]}
# )
#
LIBCXX_COMPAT_STDCXX11=(
	"llvm_slot_18" # Support -std=c++11
	"llvm_slot_19" # Support -std=c++11
)

# GCC_COMPAT template for -std=c++14 projects
#
# Status:  Used in production
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX14[@]}
# )
#
LIBCXX_COMPAT_STDCXX14=(
	"llvm_slot_18" # Support -std=c++14
	"llvm_slot_19" # Support -std=c++14
)

# GCC_COMPAT template for -std=c++17 projects or the compiler default
#
# Status:  Support is still in development
#
#    Missing feature count for core support for lowest common denominator:  0
# Missing feature count for library support for lowest common denominator:  1 red, 2 yellow
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX17[@]}
# )
#
LIBCXX_COMPAT_STDCXX17=(
	"llvm_slot_20" # Support -std=c++17
	"llvm_slot_21" # Support -std=c++17
)

# GCC_COMPAT template for -std=c++20 projects or the compiler default
#
# Status:  Support is still in development
#
#    Missing feature count for core support for lowest common denominator:  1 red, 4 yellow
# Missing feature count for library support for lowest common denominator:  4 red, 1 yellow
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX20[@]}
# )
#
LIBCXX_COMPAT_STDCXX20=(
	"llvm_slot_20" # Support -std=c++20
	"llvm_slot_21" # Support -std=c++20
)

# GCC_COMPAT template for -std=c++23 projects or the compiler default
#
# Status:  Support is still in development
#
#    Missing feature count for core support for lowest common denominator:  4 red, 2 yellow
# Missing feature count for library support for lowest common denominator:  26 red, 6 yellow
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX23[@]}
# )
#
LIBCXX_COMPAT_STDCXX23=(
	"llvm_slot_21" # Support -std=c++23
)

# GCC_COMPAT template for -std=c++26 projects or the compiler default
#
# Status:  Support is still in development
#
#    Missing feature count for core support for lowest common denominator:  9 red, 2 yellow
# Missing feature count for library support for lowest common denominator:  60 red, 1 yellow
#
# Example:
#
# GCC_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX26[@]}
# )
#
LIBCXX_COMPAT_STDCXX26=(
	"llvm_slot_21" # Support -std=c++26
)

fi
