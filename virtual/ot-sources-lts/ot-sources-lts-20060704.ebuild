# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild will assist in updating ot-sources to the latest LTS
# (Long Term Support) versions.

EAPI=8

inherit secure-version

DESCRIPTION="Virtual for the ot-sources LTS ebuilds for"
KEYWORDS="
~alpha ~amd64 ~arm ~hppa ~loong ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
"
IUSE="
5_10 5_15 6_1 6_6 6_12 6_18
ebuild_revision_1
"
RDEPEND="
	5_10? (
		~sys-kernel/ot-sources-${LINUX_KERNEL_5_10_PV}
	)
	5_15? (
		~sys-kernel/ot-sources-${LINUX_KERNEL_5_15_PV}
	)
	6_1? (
		~sys-kernel/ot-sources-${LINUX_KERNEL_6_1_PV}
	)
	6_6? (
		~sys-kernel/ot-sources-${LINUX_KERNEL_6_6_PV}
	)
	6_12? (
		~sys-kernel/ot-sources-${LINUX_KERNEL_6_12_PV}
	)
	6_18? (
		~sys-kernel/ot-sources-${LINUX_KERNEL_6_18_PV}
	)
"
SLOT="0/$(ver_cut 1-2 ${PV})"

pkg_postinst() {
	einfo "You still need to call \`emerge --depclean\`."
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
