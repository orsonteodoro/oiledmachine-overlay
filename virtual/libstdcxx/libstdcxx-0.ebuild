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

DESCRIPTION="Manages libstdc++ versioning"
KEYWORDS="
~alpha ~amd64 ~arm ~hppa ~loong ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
"
IUSE="
${GCC_COMPAT[@]}
cxx98 cxx03 cxx11 cxx14 cxx17 cxx20 cxx23 cxx26
"
REQUIRED_USE="
	cxx98? (
		|| (
			gcc_slot_11_5
			gcc_slot_12_5
			gcc_slot_13_4
			gcc_slot_14_3
		)
	)
	cxx03? (
		|| (
			gcc_slot_11_5
			gcc_slot_12_5
			gcc_slot_13_4
			gcc_slot_14_3
		)
	)
	cxx11? (
		|| (
			gcc_slot_11_5
			gcc_slot_12_5
			gcc_slot_13_4
			gcc_slot_14_3
		)
	)
	cxx17? (
		|| (
			gcc_slot_11_5
			gcc_slot_12_5
			gcc_slot_13_4
			gcc_slot_14_3
		)
	)
	cxx20? (
		|| (
			gcc_slot_13_4
			gcc_slot_14_3
			gcc_slot_15_2
			gcc_slot_16_1
		)
	)
	cxx23? (
		|| (
			gcc_slot_15_2
			gcc_slot_16_1
		)
	)
	cxx26? (
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
