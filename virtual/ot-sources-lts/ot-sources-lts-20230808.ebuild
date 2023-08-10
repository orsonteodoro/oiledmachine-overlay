# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild will assist in updating ot-sources to the latest LTS
# (Long Term Support) version.

EAPI=8
DESCRIPTION="Virtual for the ot-sources LTS ebuilds for"
KEYWORDS="
~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
"
IUSE="4_14 5_4 5_10 5_15 6_1"
RDEPEND="
	4_14? (
		~sys-kernel/ot-sources-4.14.321
	)
	5_4? (
		~sys-kernel/ot-sources-5.4.252
	)
	5_10? (
		~sys-kernel/ot-sources-5.10.189
	)
	5_15? (
		~sys-kernel/ot-sources-5.15.125
	)
	6_1? (
		~sys-kernel/ot-sources-6.1.44
	)
"
SLOT="0/$(ver_cut 1-2 ${PV})"

pkg_postinst() {
	einfo "You still need to call \`emerge --depclean\`."
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
