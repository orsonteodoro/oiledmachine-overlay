# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_11_5"
	"gcc_slot_12_5"
	"gcc_slot_13_4"
	"gcc_slot_14_3"
	"gcc_slot_15_2"
	"gcc_slot_16_1"
)

_CXX_STANDARD=(
	"cxx_standard_cxx98"
	"cxx_standard_cxx03"
	"cxx_standard_cxx11"
	"cxx_standard_cxx14"
	"cxx_standard_cxx17"
	"cxx_standard_cxx20"
	"cxx_standard_cxx23"
	"cxx_standard_cxx26"
)

DESCRIPTION="Manages libstdc++ versioning"
KEYWORDS="
~alpha ~amd64 ~arm ~hppa ~loong ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
"
IUSE="
${_CXX_STANDARD[@]}
${GCC_COMPAT[@]}
"
#
# Design note review:
#
# cxx98 to cxx17 USE flag sets are designed for LTS correspondance and
# for GPU compatibility.
#
# cxx20 to cxx26 USE flag sets are considered experimental or feature
# incomplete.  These are designed for rolling distros and fringe
# projects.  These sets will try to isolate from the high availability
# requirement for LTS (non compiler defaults) sets to avoid merge
# conflict issues.
#
# Feature completness means that no partial implementations in core and
# associated c++ runtime library.
#
# The minimum slot represents either the distro availability and feature
# completeness of that C++ version, but may represent adoption trends across
# projects.
#
REQUIRED_USE="
	cxx_standard_cxx98? (
		|| (
			gcc_slot_11_5
			gcc_slot_12_5
			gcc_slot_13_4
			gcc_slot_14_3
		)
	)
	cxx_standard_cxx03? (
		|| (
			gcc_slot_11_5
			gcc_slot_12_5
			gcc_slot_13_4
			gcc_slot_14_3
		)
	)
	cxx_standard_cxx11? (
		|| (
			gcc_slot_11_5
			gcc_slot_12_5
			gcc_slot_13_4
			gcc_slot_14_3
		)
	)
	cxx_standard_cxx17? (
		|| (
			gcc_slot_11_5
			gcc_slot_12_5
			gcc_slot_13_4
			gcc_slot_14_3
		)
	)
	cxx_standard_cxx20? (
		|| (
			gcc_slot_13_4
			gcc_slot_14_3
			gcc_slot_15_2
			gcc_slot_16_1
		)
	)
	cxx_standard_cxx23? (
		|| (
			gcc_slot_15_2
			gcc_slot_16_1
		)
	)
	cxx_standard_cxx26? (
		|| (
			gcc_slot_15_2
			gcc_slot_16_1
		)
	)
"
RDEPEND="
	gcc_slot_11_5? (
		>=sys-devel/gcc-11.5:11
	)
	gcc_slot_12_5? (
		>=sys-devel/gcc-12.5:12
	)
	gcc_slot_13_4? (
		>=sys-devel/gcc-13.4:13
	)
	gcc_slot_14_3? (
		>=sys-devel/gcc-14.3:14
	)
	gcc_slot_15_2? (
		>=sys-devel/gcc-15.2:15
	)
	gcc_slot_16_1? (
		>=sys-devel/gcc-16.0.9999:16
	)
"
SLOT="0"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
