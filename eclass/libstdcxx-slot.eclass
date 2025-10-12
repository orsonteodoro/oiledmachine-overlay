# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: libstdcxx-slot.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Slotify C++ packages
# @DESCRIPTION:
# This eclass tries to solve the libstdc++ version symbols issue.
# Only apply this eclass to C++ packages.

if [[ -z ${_LIBSTDCXX_SLOT_ECLASS} ]] ; then
_LIBSTDCXX_SLOT_ECLASS=1

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
# 5. Isolate narcissistic/subversive/disposable bleeding edge C++ standard
#    packages from conforming/collaborative/responsive higher quality LTS
#    packages.
# 6. Fixing the build order.  LTS C++ standard packages get built first,
#    experimental c++ standard packages afterwards.
# 7. Verification that the LTS packages are not contaminated with experimental
#    C++ settings.
#    a.  If contaminated, then force version limit or disable feature.
#
# Proposed solution for USEFLAG conflicts:
#
# 1.  LTS package case:  Use LIBSTDCXX_USEDEP without hesitation in *DEPENDs.
# 2.  Pure non-LTS case:  Use LIBSTDCXX_USEDEP without hesitation in *DEPENDs.
# 3.  Mixed LTS with non LTS:
#     a.  If the current package is non-LTS, in the same package LTS packages
#         get LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)" placeholder while non-LTS
#         get LIBSTDCXX_USEDEP.
#     b.  If the current package is LTS, in the same package LTS packages get
#         LIBSTDCXX_USEDEP while non-LTS get
#         LIBSTDCXX_USEDEP_DEV="gcc_slot_skip(+)" placeholder.
#

# @ECLASS_VARIABLE: LIBSTDCXX_USEDEP
# @DESCRIPTION:
# Add to C++ packages that have GLIBCXX symbol.
# To find whether you should add LIBSTDCXX_USEDEP, do
#
#   grep "GLIBCXX" /usr/lib64/*OpenImage*
#
# Example:
#
# GCC_COMPAT=(
#	"gcc_slot_14_3" # CY2026 Draft is GCC 14.2
#	"gcc_slot_11_5" # CY2025 is GCC 11.2.1
# )
#
# # Sometimes the IUSE changes through the eclass does not work.  Force it in
# # the ebuild to use the USE flag it in RDEPEND.
#
# IUSE+=" ${GCC_COMPAT[@]}"
# inherit libstdcxx-slot
#
# RDEPEND=(
#	>=media-libs/openimageio-2.2.14[${LIBSTDCXX_USEDEP}]
#	media-libs/openimageio:=
# )
#
# pkg_setup() {
#	libstdcxx-slot_verify
# }
#

# See also https://github.com/gcc-mirror/gcc/blob/master/libstdc%2B%2B-v3/config/abi/pre/gnu.ver
# GCC version to libstdc++ version mappings
GCC_8_1="3.4.25"
GCC_8_2="3.4.25"
GCC_8_3="3.4.25"
GCC_8_4="3.4.25"
GCC_8_5="3.4.25"
GCC_9_1="3.4.26"
GCC_9_2="3.4.27"
GCC_9_3="3.4.28"
GCC_9_4="3.4.28"
GCC_9_5="3.4.28"
GCC_10_1="3.4.28"
GCC_10_2="3.4.28"
GCC_10_3="3.4.28"
GCC_10_4="3.4.28"
GCC_10_5="3.4.28"
GCC_11_1="3.4.29"
GCC_11_2="3.4.29"
GCC_11_3="3.4.29"
GCC_11_4="3.4.29"
GCC_11_5="3.4.29"
GCC_12_1="3.4.30"
GCC_12_2="3.4.30"
GCC_12_3="3.4.30"
GCC_12_4="3.4.30"
GCC_12_5="3.4.30"
GCC_13_1="3.4.31"
GCC_13_2="3.4.32"
GCC_13_3="3.4.32"
GCC_13_4="3.4.32"
GCC_14_1="3.4.33"
GCC_14_2="3.4.33"
GCC_14_3="3.4.33"
GCC_15_1="3.4.34"
GCC_15_2="3.4.34"
GCC_16_1="3.4.35"

# @ECLASS_VARIABLE: _ALL_GCC_COMPAT
# @DESCRIPTION:
# All GCC point versions available by distro repo.
# Live is not supported
_ALL_GCC_COMPAT=(
	"16_1"
	"15_2"
	"15_1"
	"14_3"
	"14_2"
	"14_1"
	"13_4"
	"13_3"
	"13_2"
	"13_1"
	"13_1"
	"12_5"
	"12_4"
	"12_3"
	"12_2"
	"12_2"
	"11_5"
	"11_4"
	"11_3"
	"11_2"
	"11_1"
	"10_5"
	"10_4"
	"10_3"
	"10_2"
	"10_1"
	"9_5"
	"9_4"
	"9_3"
	"9_2"
	"9_1"
	"8_5"
	"8_4"
	"8_3"
	"8_2"
	"8_1"
)

# @FUNCTION: _libstdcxx_slot_set_globals
# @DESCRIPTION:
# Init globals
_libstdcxx_slot_set_globals() {
	if [[ -z "${GCC_COMPAT}" ]] ; then
eerror "QA:  GCC_COMPAT must be defined"
		die
	fi

	local iuse=""
	local usedep=""
	local usedep2=""
	local x
	for x in ${_ALL_GCC_COMPAT[@]} ; do
		if [[ ${GCC_COMPAT[@]} =~ (^|" ")"gcc_slot_${x}"($|" ") ]] ; then
			iuse="${iuse} gcc_slot_${x}"
			usedep="${usedep},gcc_slot_${x}(-)?"
			usedep2="${usedep2},gcc_slot_${x}(+)?"
		fi
	done
	required_use="
		^^ (
			${iuse}
		)
	"

	IUSE="
		${IUSE}
		${iuse}
	"
	REQUIRED_USE="
		${REQUIRED_USE}
		${required_use}
	"
	RDEPEND="
		${RDEPEND}
		virtual/libstdcxx[${usedep2}]
	"

	if [[ "${LIBSTDCXX_USEDEP_SKIP}" == "1" ]] ; then
	# Skip resolution but mark packages as having C++ version symbols.
		LIBSTDCXX_USEDEP="gcc_slot_skip(+)"
	else
		LIBSTDCXX_USEDEP="${usedep:1}"
	fi
}
_libstdcxx_slot_set_globals
unset -f _libstdcxx_slot_set_globals

# @FUNCTION: _switch_gcc_to_continue_message
# @DESCRIPTION:
# Request indirect libstdc++ changes message
_switch_gcc_to_continue_message() {
	local slot="${1}"
eerror
eerror "You must do the following to continue:"
eerror
eerror "eselect gcc set ${CHOST}-${slot}"
eerror "source /etc/profile"
eerror
}

_GLIBCXX_VER_VERIFIED=0
# @FUNCTION: libstdcxx-slot_verify
# @DESCRIPTION:
# Verify libstdc++ version before compiling
libstdcxx-slot_verify() {
	local gcc_slot=$(gcc-config -c | cut -f 5 -d "-")
	local actual_gcc_version=$(${CHOST}-gcc-${gcc_slot} --version | head -n 1 | cut -f 5 -d " ")
	local actual_gcc_ver2=$(ver_cut 1-2 "${actual_gcc_version}")
	local k="GCC_${actual_gcc_ver2/./_}"
	local actual_libstdcxx_ver="${!k}"
	local x
	for x in ${_ALL_GCC_COMPAT[@]} ; do
		if [[ ${GCC_COMPAT[@]} =~ (^|" ")"gcc_slot_${x}"($|" ") ]] ; then
			local k="GCC_${x/./_}"
			local expected_libstdcxx_ver="${!k}"
			if ver_test "${actual_libstdcxx_ver}" -ne "${expected_libstdcxx_ver}" && has "gcc_slot_${x}" ${IUSE} && use "gcc_slot_${x}" ; then
				_switch_gcc_to_continue_message ${x%_*}
				die
			fi
		fi
	done
	export _GLIBCXX_VER_VERIFIED=1
}

# @FUNCTION: libstdcxx-slot_pkg_postinst
# @DESCRIPTION:
# Event handler for check libstdc++ slot verification
libstdcxx-slot_pkg_postinst() {
	if (( ${_GLIBCXX_VER_VERIFIED} != 1 )) ; then
eerror "QA:  You must call libstdcxx-slot_verify in pkg_setup"
		die
	fi
}

EXPORT_FUNCTIONS pkg_postinst

fi
