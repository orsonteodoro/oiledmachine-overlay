# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild will assist in updating ot-sources to the latest LTS
# (Long Term Support) versions.

EAPI=8

KERNEL_SLOTS=(
	"kernel_slot_5_10"
	"kernel_slot_5_15"
	"kernel_slot_6_1"
	"kernel_slot_6_6"
	"kernel_slot_6_12"
	"kernel_slot_6_18"
)

inherit secure-version

DESCRIPTION="Virtual for the ot-sources LTS ebuilds for"
KEYWORDS="
~alpha ~amd64 ~arm ~hppa ~loong ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
"
IUSE="
${KERNEL_SLOTS[@]}
ebuild_revision_2
"
REQUIRED_USE="
	|| (
		${KERNEL_SLOTS[@]}
	)
"
RDEPEND="
	kernel_slot_5_10? (
		~sys-kernel/ot-sources-${LINUX_KERNEL_5_10_PV}
	)
	kernel_slot_5_15? (
		~sys-kernel/ot-sources-${LINUX_KERNEL_5_15_PV}
	)
	kernel_slot_6_1? (
		~sys-kernel/ot-sources-${LINUX_KERNEL_6_1_PV}
	)
	kernel_slot_6_6? (
		~sys-kernel/ot-sources-${LINUX_KERNEL_6_6_PV}
	)
	kernel_slot_6_12? (
		~sys-kernel/ot-sources-${LINUX_KERNEL_6_12_PV}
	)
	kernel_slot_6_18? (
		~sys-kernel/ot-sources-${LINUX_KERNEL_6_18_PV}
	)
"
SLOT="0/$(ver_cut 1-2 ${PV})"

pkg_postinst() {
	einfo "You still need to call \`emerge --depclean\`."
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
