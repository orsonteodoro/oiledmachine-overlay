# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: libcxx-slot.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Slotify C++ packages
# @DESCRIPTION:
# This eclass tries to help keep LLVM slots updated not neglected.
# Only apply this eclass to C++ packages.

if [[ -z ${_LIBCXX_SLOT_ECLASS} ]] ; then
_LIBCXX_SLOT_ECLASS=1

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
# 1. LTS packages are consistently built with the chosen llvm_slot_x_y_z version.
# 2. No runtime errors in binary packages or prebuilt distro packages because of missing symbols.
# 3. LTS packages are always unaffected by experimental C++ packages.
# 4. Isolate narcissistic/subversive/disposable bleeding edge C++ standard
#    packages from conforming/collaborative/responsive higher quality LTS
#    packages.
# 5. Fixing the build order.  LTS C++ standard packages get built first,
#    experimental c++ standard packages afterwards.
# 6. Verification that the LTS packages are not contaminated with experimental
#    C++ settings.
#    a.  If contaminated, then force version limit or disable feature.
#
# Proposed solution for USEFLAG conflicts:
#
# 1.  LTS package case:  Use LIBCXX_USEDEP without hesitation in *DEPENDs.
# 2.  Pure non-LTS case:  Use LIBCXX_USEDEP without hesitation in *DEPENDs.
# 3.  Mixed LTS with non LTS:
#     a.  If the current package is non-LTS, in the same package LTS packages
#         get LIBCXX_USEDEP_LTS="llvm_slot_skip(+)" placeholder while non-LTS
#         get LIBCXX_USEDEP.
#     b.  If the current package is LTS, in the same package LTS packages get
#         LIBCXX_USEDEP while non-LTS get
#         LIBCXX_USEDEP_DEV="llvm_slot_skip(+)" placeholder.
#

# @ECLASS_VARIABLE: LIBCXX_SLOT_CONFIG
# @DESCRIPTION:
# Controls the defaults for IUSE and RDEPEND.
# Valid values: core, core+lib, lib
# core - Only show the interface relevant to compiler.
# core+lib - Show the interface relevant to compiler and the libc++ library (C++ runtime library).
# lib - Show only the relevant interface for the libc++ library (C++ runtime library).

# @ECLASS_VARIABLE: LIBCXX_USEDEP
# @DESCRIPTION:
# Add to C++ packages that have libc++ ldd linkage.
# To find whether you should add LIBCXX_USEDEP, do
#
#   grep "libc++.so" /usr/lib64/libc++.so.1
#
# Example:
#
# LLVM_COMPAT=(
#	"llvm_slot_18" # U24
#	"llvm_slot_19" # D13
# )
# CXX_STANDARD="17" # It can be 98, 03, 11, 14, 17, 20, 23, 26
#
# # Sometimes the IUSE changes through the eclass does not work.  Force it in
# # the ebuild to use the USE flag it in RDEPEND.
#
# IUSE+=" ${LLVM_COMPAT[@]}"
# inherit libcxx-slot
#
# RDEPEND=(
#	>=media-libs/openimageio-2.2.14[${LIBCXX_USEDEP}]
#	media-libs/openimageio:=
# )
#
# pkg_setup() {
#	libcxx-slot_verify
# }
#

# See also https://github.com/llvm/llvm-project/blob/llvmorg-18.1.0/libcxx/include/__config#L65
# Clang version to libc++ version mappings
CLANG_11_0_1="11000"
CLANG_11_1_0="11000"
CLANG_12_0_0="12000"
CLANG_12_0_1="12000"
CLANG_13_0_0="13000"
CLANG_13_0_1="13000"
CLANG_14_0_0="14000"
CLANG_14_0_1="14000"
CLANG_14_0_2="14000"
CLANG_14_0_3="14000"
CLANG_14_0_4="14000"
CLANG_14_0_5="14000"
CLANG_14_0_6="14000"
CLANG_15_0_0="15000"
CLANG_15_0_1="15001"
CLANG_15_0_2="15002"
CLANG_15_0_3="15003"
CLANG_15_0_4="15004"
CLANG_15_0_5="15005"
CLANG_15_0_6="15006"
CLANG_15_0_7="15007"
CLANG_16_0_1="160001"
CLANG_16_0_0="160000"
CLANG_16_0_1="160001"
CLANG_16_0_2="160002"
CLANG_16_0_3="160003"
CLANG_16_0_4="160004"
CLANG_16_0_5="160005"
CLANG_16_0_6="160006"
CLANG_17_0_0="170000"
CLANG_17_0_1="170001"
CLANG_17_0_2="170002"
CLANG_17_0_3="170003"
CLANG_17_0_4="170004"
CLANG_17_0_5="170005"
CLANG_17_0_6="170006"
CLANG_18_1_0="180100"
CLANG_18_1_1="180100"
CLANG_18_1_2="180100"
CLANG_18_1_3="180100"
CLANG_18_1_4="180100"
CLANG_18_1_5="180100"
CLANG_18_1_6="180100"
CLANG_18_1_7="180100"
CLANG_18_1_8="180100"
CLANG_19_1_0="190100"
CLANG_19_1_1="190101"
CLANG_19_1_2="190102"
CLANG_19_1_3="190103"
CLANG_19_1_4="190104"
CLANG_19_1_5="190105"
CLANG_19_1_6="190106"
CLANG_19_1_7="190107"
CLANG_20_1_0="200100"
CLANG_20_1_1="200100"
CLANG_20_1_2="200100"
CLANG_20_1_3="200100"
CLANG_20_1_4="200100"
CLANG_20_1_5="200100"
CLANG_20_1_6="200100"
CLANG_20_1_7="200100"
CLANG_20_1_8="200100"
CLANG_21_1_0="210100"
CLANG_21_1_1="210101"
CLANG_21_1_2="210101"
CLANG_21_1_3="210103"
CLANG_20_0_0="220000"


# @ECLASS_VARIABLE: _ALL_LLVM_COMPAT
# @DESCRIPTION:
# All Clang point versions available by distro repo.
# Live is not supported
_ALL_LLVM_COMPAT=(
	{11..20}
)
_ALL_LLVM_COMPAT2=(
	"20_0_0"
	"21_1_3"
	"21_1_2"
	"21_1_1"
	"21_1_0"
	"20_1_8"
	"20_1_7"
	"20_1_6"
	"20_1_5"
	"20_1_4"
	"20_1_3"
	"20_1_2"
	"20_1_1"
	"20_1_0"
	"19_1_7"
	"19_1_6"
	"19_1_5"
	"19_1_4"
	"19_1_3"
	"19_1_2"
	"19_1_1"
	"19_1_0"
	"18_1_8"
	"18_1_7"
	"18_1_6"
	"18_1_5"
	"18_1_4"
	"18_1_3"
	"18_1_2"
	"18_1_1"
	"18_1_0"
	"17_0_6"
	"17_0_5"
	"17_0_4"
	"17_0_3"
	"17_0_2"
	"17_0_1"
	"17_0_0"
	"16_0_6"
	"16_0_5"
	"16_0_4"
	"16_0_3"
	"16_0_2"
	"16_0_1"
	"16_0_0"
	"15_0_7"
	"15_0_6"
	"15_0_5"
	"15_0_4"
	"15_0_3"
	"15_0_1"
	"15_0_0"
	"14_0_6"
	"14_0_5"
	"14_0_4"
	"14_0_3"
	"14_0_2"
	"14_0_1"
	"14_0_0"
	"13_0_1"
	"13_0_0"
	"12_0_1"
	"12_0_0"
	"11_1_0"
	"11_0_1"
)

# @FUNCTION: _libcxx_slot_set_globals
# @DESCRIPTION:
# Init globals
_libcxx_slot_set_globals() {
	if [[ -z "${LLVM_COMPAT}" ]] ; then
eerror "QA:  LLVM_COMPAT must be defined"
		die
	fi

	local iuse=""
	local usedep=""
	local x
	for x in ${_ALL_LLVM_COMPAT[@]} ; do
		if [[ ${LLVM_COMPAT[@]} =~ (^|" ")"${x}"($|" ") ]] ; then
			iuse="${iuse} llvm_slot_${x}"
			usedep="${usedep},llvm_slot_${x}(-)?"
		fi
	done
	local required_use=""
	if [[ "${LIBCXX_SLOT_CONFIG:-core+lib}" =~ ("core+lib"|"lib") ]] ; then
		required_use="
			^^ (
				${iuse}
			)
		"
	else
		required_use=""
	fi

	if [[ -z "${CXX_STANDARD}" ]] ; then
eerror "QA:  CXX_STANDARD is undefined."
eerror "Valid values:  98, 03, 11, 14, 17, 20, 23, 26"
		die
	fi

	local rdepend
	if [[ "${CXX_STANDARD}" == "98" ]] ; then
		rdepend="
			libcxx? (
				virtual/libcxx[cxx98]
			)
		"
	elif [[ "${CXX_STANDARD}" == "03" ]] ; then
		rdepend="
			libcxx? (
				virtual/libcxx[cxx03]
			)
		"
	elif [[ "${CXX_STANDARD}" == "11" ]] ; then
		rdepend="
			libcxx? (
				virtual/libcxx[cxx11]
			)
		"
	elif [[ "${CXX_STANDARD}" == "14" ]] ; then
		rdepend="
			libcxx? (
				virtual/libcxx[cxx14]
			)
		"
	elif [[ "${CXX_STANDARD}" == "17" ]] ; then
		rdepend="
			libcxx? (
				virtual/libcxx[cxx17]
			)
		"
	elif [[ "${CXX_STANDARD}" == "20" ]] ; then
		rdepend="
			libcxx? (
				virtual/libcxx[cxx20]
			)
		"
	elif [[ "${CXX_STANDARD}" == "23" ]] ; then
		rdepend="
			libcxx? (
				virtual/libcxx[cxx23]
			)
		"
	elif [[ "${CXX_STANDARD}" == "26" ]] ; then
		rdepend="
			libcxx? (
				virtual/libcxx[cxx23]
			)
		"
	else
eerror "QA:  CXX_STANDARD is invalid."
eerror "Valid values:  98, 03, 11, 14, 17, 20, 23, 26"
		die
	fi

	IUSE="
		${IUSE}
		${iuse}
	"
	if [[ "${LIBCXX_SLOT_CONFIG:-core+lib}" =~ ("core+lib"|"lib") ]] ; then
		IUSE="
			${IUSE}
			libcxx
		"
	fi
	REQUIRED_USE="
		${REQUIRED_USE}
		${required_use}
	"
	if [[ "${LIBCXX_SLOT_CONFIG:-core+lib}" =~ ("core+lib"|"lib") ]] ; then
		RDEPEND="
			${RDEPEND}
			${rdepend}
		"
	fi

	if [[ "${LIBCXX_USEDEP_SKIP}" == "1" ]] ; then
	# Skip resolution but mark packages as having C++ version symbols.
		LIBCXX_USEDEP="llvm_slot_skip(+)"
	else
		LIBCXX_USEDEP="${usedep:1}"
	fi
}
_libcxx_slot_set_globals
unset -f _libcxx_slot_set_globals

# @FUNCTION: _switch_gcc_to_continue_message
# @DESCRIPTION:
# Request indirect libc++ changes message
_switch_clang_to_continue_message() {
	local slot="${1}"
eerror
eerror "You must do the following to continue:"
eerror
eerror "Contents of /etc/portage/env/clang-${slot}.conf:"
eerror "CC=\"clang-${slot}\""
eerror "CXX=\"clang++-${slot}\""
eerror "CPP=\"${CC} -E\""
eerror "AR=\"llvm-ar\""
eerror "NM=\"llvm-nm\""
eerror "OBJCOPY=\"llvm-objcopy\""
eerror "OBJDUMP=\"llvm-objdump\""
eerror "READELF=\"llvm-readelf\""
eerror "STRIP=\"llvm-strip\""
eerror
eerror "Contents of /etc/portage/package.env:"
eerror "${CATEGORY}/${PN} clang-${slot}.conf"
eerror
}

_LIBCXX_VER_VERIFIED=0
# @FUNCTION: libcxx-slot_verify
# @DESCRIPTION:
# Verify libc++ version before compiling
libcxx-slot_verify() {
	export _LIBCXX_VER_VERIFIED=1
	tc-is-clang || return
	local llvm_slot=$(${CC} --version | head -n 1 | cut -f 3 -d " " | cut -f 1 -d ".")

	# Verify core compiler
	local x
	for x in ${_ALL_LLVM_COMPAT[@]} ; do
		if [[ ${LLVM_COMPAT[@]} =~ (^|" ")"llvm_slot_${x}"($|" ") ]] ; then
			if ver_test "${llvm_slot}" -ne "${x}" && has "llvm_slot_${x}" ${IUSE} && use "llvm_slot_${x}" ; then
				_switch_clang_to_continue_message ${x%_*}
				die
			fi
		fi
	done

	# Verification of libc++ already done in virtual/libcxx
}

# @FUNCTION: libcxx-slot_pkg_postinst
# @DESCRIPTION:
# Event handler for check libc++ slot verification
libcxx-slot_pkg_postinst() {
	if (( ${_LIBCXX_VER_VERIFIED} != 1 )) ; then
eerror "QA:  You must call libcxx-slot_verify in pkg_setup"
		die
	fi
}

EXPORT_FUNCTIONS pkg_postinst

fi
