# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: libcxx-compat.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: LLVM_COMPAT templates
# @DESCRIPTION:
# Common macro expanded like array values for LLVM_COMPAT.

if [[ -z ${_LIBCXX_COMPAT_ECLASS} ]] ; then
_LIBCXX_COMPAT_ECLASS=1

#
# QA standards:
#
# Only add "Observed in downstream projects" if observed from remote CI logs
# and the slot is feature incomplete.
#
# If a USE flag slot is marked "Observed in downstream projects", the lower
# bounds for that slot may be changed to allow it but only if widely observed
# across many projects.
#

# Fewer slots are shown because of LTS issues with Python.
# The distro overlay is denying manifest updates to Python 3.10.x and older in
# the python-utils-r1 eclass.  Only releases associated with full access Python
# will be shown.

# CLANG_COMPAT contains "llvm_slot_" prefix.
# LLVM_COMPAT contains just the slot number.

# LLVM_COMPAT template for desktop based LTS distros
#
# Status:  Production ready
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_LTS[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_LTS=(
        "llvm_slot_18" # Support U24
        "llvm_slot_19" # Support D13
)

# LLVM_COMPAT template for -std=c++98 projects
#
# Status:  Used in production
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX98[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_STDCXX98=(
	"llvm_slot_18" # Support -std=c++98
	"llvm_slot_19" # Support -std=c++98
)

# LLVM_COMPAT template for -std=c++03 projects
#
# Status:  Used in production
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX03[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_STDCXX03=(
	"llvm_slot_18" # Support -std=c++03
	"llvm_slot_19" # Support -std=c++03
)

# LLVM_COMPAT template for -std=c++11 projects
#
# Status:  Used in production
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_STDCXX11=(
	"llvm_slot_18" # Support -std=c++11
	"llvm_slot_19" # Support -std=c++11
)

# LLVM_COMPAT template for -std=c++14 projects
#
# Status:  Used in production
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX14[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_STDCXX14=(
	"llvm_slot_18" # Support -std=c++14
	"llvm_slot_19" # Support -std=c++14
)

# LLVM_COMPAT template for -std=c++17 projects or the compiler default
#
# Status:  Support is still in development
#
#    Missing feature count for core support for lowest common denominator:  0
# Missing feature count for library support for lowest common denominator:  1 red, 2 yellow
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_STDCXX17=(
	"llvm_slot_20" # Support -std=c++17
	"llvm_slot_21" # Support -std=c++17
)

# LLVM_COMPAT template for -std=c++20 projects or the compiler default
#
# Status:  Support is still in development
#
#    Missing feature count for core support for lowest common denominator:  1 red, 4 yellow
# Missing feature count for library support for lowest common denominator:  4 red, 1 yellow
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX20[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_STDCXX20=(
	"llvm_slot_20" # Support -std=c++20
	"llvm_slot_21" # Support -std=c++20
)

# LLVM_COMPAT template for -std=c++23 projects or the compiler default
#
# Status:  Support is still in development
#
#    Missing feature count for core support for lowest common denominator:  4 red, 2 yellow
# Missing feature count for library support for lowest common denominator:  26 red, 6 yellow
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_STDCXX23=(
	"llvm_slot_21" # Support -std=c++23
)

# LLVM_COMPAT template for -std=c++26 projects or the compiler default
#
# Status:  Support is still in development
#
#    Missing feature count for core support for lowest common denominator:  9 red, 2 yellow
# Missing feature count for library support for lowest common denominator:  60 red, 1 yellow
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_STDCXX26[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_STDCXX26=(
	"llvm_slot_21" # Support -std=c++26
)

fi
