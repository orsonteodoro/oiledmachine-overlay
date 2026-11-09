# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: libcxx-compat.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: LLVM_COMPAT templates
# @DESCRIPTION:
# Common macro expanded like array values for LLVM_COMPAT.

# The libcxx in this eclass is a misnomer.  It can be applied to the requirement
# for the compiler only.  The eclass is intended to centralize the C++ string
# literals to setup up C++ support.

case ${EAPI:-0} in
	8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

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

# LLVM_COMPAT templates for CUDA
#
# Status:  Production ready
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_CXX17_CUDA_11_8[@]/llvm_slot_}
# )
#

LIBCXX_COMPAT_CXX11_CUDA_12_6=( # LTS
	"llvm_slot_18"
)

LIBCXX_COMPAT_CXX11_CUDA_12_8=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
)

LIBCXX_COMPAT_CXX11_CUDA_12_9=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
)

LIBCXX_COMPAT_CXX14_CUDA_12_6=( # LTS
	"llvm_slot_18"
)

LIBCXX_COMPAT_CXX14_CUDA_12_8=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
)

LIBCXX_COMPAT_CXX14_CUDA_12_9=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
)

# For latest CUDA 12
LIBCXX_COMPAT_CXX17_CUDA_12=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
)

# For latest CUDA 13
LIBCXX_COMPAT_CXX17_CUDA_13=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
	"llvm_slot_21"
	"llvm_slot_22"
)

LIBCXX_COMPAT_CXX17_CUDA_12_6=( # LTS
	"llvm_slot_18"
)

LIBCXX_COMPAT_CXX17_CUDA_12_8=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
)

LIBCXX_COMPAT_CXX17_CUDA_12_9=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
)

LIBCXX_COMPAT_CXX17_CUDA_13_0=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
)

LIBCXX_COMPAT_CXX17_CUDA_13_1=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
)

LIBCXX_COMPAT_CXX17_CUDA_13_2=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
	"llvm_slot_21"
)

LIBCXX_COMPAT_CXX17_CUDA_13_3=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
	"llvm_slot_21"
)

LIBCXX_COMPAT_CXX17_CUDA_13_4=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
	"llvm_slot_21"
	"llvm_slot_22"
)

LIBCXX_COMPAT_CXX17_CUDA_13_5=( # LTS
	"llvm_slot_18"
	"llvm_slot_19"
	"llvm_slot_21"
	"llvm_slot_22"
)

# For latest CUDA 12
LIBCXX_COMPAT_CXX20_CUDA_12=( # LTS + rolling
	"llvm_slot_18"
	"llvm_slot_19"
)

# For latest CUDA 13
LIBCXX_COMPAT_CXX20_CUDA_13=( # LTS + rolling
	"llvm_slot_18"
	"llvm_slot_19"
	"llvm_slot_21"
)

LIBCXX_COMPAT_CXX20_CUDA_12_6=( # LTS + rolling
	"llvm_slot_18"
)

LIBCXX_COMPAT_CXX20_CUDA_12_8=( # LTS + rolling
	"llvm_slot_18"
	"llvm_slot_19"
)

LIBCXX_COMPAT_CXX20_CUDA_12_9=( # LTS + rolling
	"llvm_slot_18"
	"llvm_slot_19"
)

LIBCXX_COMPAT_CXX20_CUDA_13_0=( # LTS + rolling
	"llvm_slot_18"
	"llvm_slot_19"
)

LIBCXX_COMPAT_CXX20_CUDA_13_1=( # LTS + rolling
	"llvm_slot_18"
	"llvm_slot_19"
)

LIBCXX_COMPAT_CXX20_CUDA_13_2=( # LTS + rolling
	"llvm_slot_18"
	"llvm_slot_19"
	"llvm_slot_21"
)

LIBCXX_COMPAT_CXX20_CUDA_13_3=( # LTS + rolling
	"llvm_slot_18"
	"llvm_slot_19"
	"llvm_slot_21"
)

LIBCXX_COMPAT_CXX20_CUDA_13_4=( # LTS + rolling
	"llvm_slot_18"
	"llvm_slot_19"
	"llvm_slot_21"
	"llvm_slot_22"
)

LIBCXX_COMPAT_CXX20_CUDA_13_5=( # LTS + rolling
	"llvm_slot_18"
	"llvm_slot_19"
	"llvm_slot_21"
	"llvm_slot_22"
)

# For latest CUDA 13
LIBCXX_COMPAT_CXX23_CUDA_13=( # Rolling
	"llvm_slot_21"
	"llvm_slot_22"
)

LIBCXX_COMPAT_CXX23_CUDA_13_3=( # Rolling
	"llvm_slot_21"
)

LIBCXX_COMPAT_CXX23_CUDA_13_4=( # Rolling
	"llvm_slot_22"
)

LIBCXX_COMPAT_CXX23_CUDA_13_5=( # Rolling
	"llvm_slot_22"
)

# For latest 12 on a c++11 or earlier project
LIBCXX_COMPAT_CXX11_CUDA=(
	"llvm_slot_18" # Support CUDA 12.6, 12.8, 12.9, 13.0, 13.1, 13.2, 13.3
	"llvm_slot_19" # Support CUDA 12.8, 12.9, 13.0, 13.1, 13.2, 13.3
	"llvm_slot_21" # Support CUDA 13.2, 13.3
)

# For latest CUDA 12 on a c++14 or earlier project
LIBCXX_COMPAT_CXX14_CUDA=(
	"llvm_slot_18" # Support CUDA 12.6, 12.8, 12.9, 13.0, 13.1, 13.2, 13.3
	"llvm_slot_19" # Support CUDA 12.8, 12.9, 13.0, 13.1, 13.2, 13.3
	"llvm_slot_21" # Support CUDA 13.2, 13.3
)

# For latest CUDA 12 on a c++17 or earlier project
LIBCXX_COMPAT_CXX17_CUDA=(
	"llvm_slot_18" # Support CUDA 12.6, 12.8, 12.9, 13.0, 13.1, 13.2, 13.3
	"llvm_slot_19" # Support CUDA 12.8, 12.9, 13.0, 13.1, 13.2, 13.3
	"llvm_slot_21" # Support CUDA 13.2, 13.3
)

# For latest CUDA 12 on a c++20 or earlier project
LIBCXX_COMPAT_CXX20_CUDA=(
#	"llvm_slot_18" # Support CUDA 12.6, 12.8, 12.9, 13.0, 13.2, 13.3
#	"llvm_slot_19" # Support CUDA 12.8, 12.9, 13.0, 13.1, 13.2, 13.3
	"llvm_slot_21" # Support CUDA 13.2, 13.3
)

# For latest CUDA 13 on a c++23 or earlier project
LIBCXX_COMPAT_CXX23_CUDA=(
	"llvm_slot_21" # Support CUDA 13.3
)

# LLVM_COMPAT templates for ROCm for building libs.
#
# Status:  Production ready
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_ROCM_LIB[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_ROCM_LIB=( # Skip
	# Disable ROCm when building libs
)

# LLVM_COMPAT templates for ROCm for building pure applications or Python
# packages with private libraries.
#
# Status:  Production ready
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_ROCM_APP[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_ROCM_APP=( # Live
# Align to ROCm/llvm-project
	"llvm_slot_24"
)

# LLVM_COMPAT templates for ROCm
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_CXX20_ROCM[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_ROCM=( # Live
# Align to ROCm/llvm-project
	"llvm_slot_24"
)

#
# C++ standard support for GPU SDKs:
#
# CUDA:  c++11 <= x <= C++23
# ROCm:  c++11 <= x <= C++20
#
# ROCm C++ standards supported:  https://rocm.docs.amd.com/projects/HIP/en/docs-10.1.0/how-to/kernel_language_cpp_support.html

LIBCXX_COMPAT_CXX17_GPU=( # LTS
	"llvm_slot_18" # Support CUDA 12.6, 12.8, 12.9, 13.0, 13.1, 13.2, 13.3
	"llvm_slot_19" # Support CUDA 12.8, 12.9, 13.0, 13.1, 13.2, 13.3
	"llvm_slot_21" # Support CUDA 13.2, 13.3
	"llvm_slot_22" # Support CUDA 13.4, 13.5
)

LIBCXX_COMPAT_CXX20_GPU=( # LTS + rolling
	"llvm_slot_18" # Support CUDA 12.6, 12.8, 12.9, 13.0, 13.1, 13.2, 13.3
	"llvm_slot_19" # Support CUDA 12.8, 12.9, 13.0, 13.1, 13.2, 13.3
	"llvm_slot_21" # Support CUDA 13.2, 13.3
	"llvm_slot_22" # Support CUDA 13.4, 13.5
)

LIBCXX_COMPAT_CXX23_GPU=( # Rolling
	"llvm_slot_21" # Support CUDA 13.2, 13.3
	"llvm_slot_22" # Support CUDA 13.4, 13.5
)

# LIBCXX_COMPAT_LTS template for desktop based LTS distros
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
	"llvm_slot_21" # Support U26
	"llvm_slot_22" # Available in U26
)

# LIBCXX_COMPAT_ROLLING template for desktop based LTS distros
#
# Status:  Production ready
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_ROLLING[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_ROLLING=(
	"llvm_slot_21" # Support F43
	"llvm_slot_22" # Support F44, G23
	"llvm_slot_23" # Support F45
)

# LLVM_COMPAT template for Rust with LTS compilers
#
# Rust <= 1.93.1 is LTS
#
# Status:  Production ready
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_RUST_LTS[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_RUST_LTS=( # Tagged aligned with LTS
	# Based on Rust versions used in LTS distros
	"llvm_slot_18"
	"llvm_slot_19"
	"llvm_slot_21"
	"llvm_slot_22"
)

# LLVM_COMPAT template for Rust with Rolling compilers
#
# Rust > 1.93.1 is rolling
#
# Status:  Production ready
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_RUST_ROLLING[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_RUST_ROLLING=( # Tagged aligned with rolling
	# Based on Rust versions used in Rolling distros
	"llvm_slot_22"
	"llvm_slot_23"
)

# LLVM_COMPAT template for Rust with Rolling compilers
#
# Example:
#
# LLVM_COMPAT=(
#     ${LIBCXX_COMPAT_RUST_ROLLING[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_RUST_LIVE=( # Untagged
	# Based on https://github.com/rust-lang/rust/blob/main/.gitmodules#L28
	"llvm_slot_23"
)

# LLVM_COMPAT template for Rust with both LTS and Rolling compilers
#
# Status:  Production ready
#
# Example:
#
# LLVM_COMPAT_RUST=(
#     ${LIBCXX_COMPAT_RUST[@]/llvm_slot_}
# )
#
LIBCXX_COMPAT_RUST=( # LTS + rolling
	# Based on live and earlier tagged releases for https://github.com/rust-lang/rust/blob/main/.gitmodules#L28
	"llvm_slot_18"
	"llvm_slot_19"
	"llvm_slot_21"
	"llvm_slot_22"
	"llvm_slot_23"
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
LIBCXX_COMPAT_STDCXX98=( # LTS
	"llvm_slot_18" # Support -std=c++98
	"llvm_slot_19" # Support -std=c++98
	"llvm_slot_21" # Support -std=c++98
	"llvm_slot_22" # Support -std=c++98
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
LIBCXX_COMPAT_STDCXX03=( # LTS
	"llvm_slot_18" # Support -std=c++03
	"llvm_slot_19" # Support -std=c++03
	"llvm_slot_21" # Support -std=c++03
	"llvm_slot_22" # Support -std=c++03
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
LIBCXX_COMPAT_STDCXX11=( # LTS
	"llvm_slot_18" # Support -std=c++11
	"llvm_slot_19" # Support -std=c++11
	"llvm_slot_21" # Support -std=c++11
	"llvm_slot_22" # Support -std=c++11
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
LIBCXX_COMPAT_STDCXX14=( # LTS
	"llvm_slot_18" # Support -std=c++14
	"llvm_slot_19" # Support -std=c++14
	"llvm_slot_21" # Support -std=c++14
	"llvm_slot_22" # Support -std=c++14
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
LIBCXX_COMPAT_STDCXX17=( # LTS
	# Set to LTS distros equivalent to reduce misalignment in dependencies
	"llvm_slot_18" # Support -std=c++17.  Defaults:  U24
	"llvm_slot_19" # Support -std=c++17.  Defaults:  D13
	"llvm_slot_21" # Support -std=c++17.  Defaults:  U26, F43; Available:  D13
	"llvm_slot_22" # Support -std=c++17.  Available:  U26; Available:  F44, F45
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
LIBCXX_COMPAT_STDCXX20=( # LTS + rolling
	# From 2 previous LTS releases to newest rolling release
	"llvm_slot_18" # Support -std=c++17.  Defaults:  U24
	"llvm_slot_19" # Support -std=c++17.  Defaults:  D13
	"llvm_slot_21" # Support -std=c++20.  Defaults:  U26, F43; Available:  D13, 4.3y
	"llvm_slot_22" # Support -std=c++20.  Defaults:  F44, G23
	"llvm_slot_23" # Support -std=c++20.  Defaults:  F45
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
LIBCXX_COMPAT_STDCXX23=( # Rolling
	# Oldest rolling supported
	"llvm_slot_21" # Support -std=c++23.  Defaults:  F43
	"llvm_slot_22" # Support -std=c++23.  Defaults:  F44, G23
	"llvm_slot_23" # Support -std=c++23.  Defaults:  F45
)

# LLVM_COMPAT template for -std=c++26 projects or the compiler default
#
# Status:  Support is still in development.  C++26 draft rejected (*disapproved*)
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
LIBCXX_COMPAT_STDCXX26=( # Rolling
	# Newest rolling supported
	"llvm_slot_23" # Support -std=c++26.  Defaults:  F45
)

fi
