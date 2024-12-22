# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild will assist in updating ot-sources to the latest LTS
# (Long Term Support) versions.

EAPI=8
DESCRIPTION="Virtual for the ot-sources LTS ebuilds for"
KEYWORDS="
~alpha ~amd64 ~arm ~hppa ~loong ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
"
IUSE=" 5_4 5_10 5_15 6_1 6_6 6_12"
RDEPEND="
	5_4? (
		~sys-kernel/ot-sources-5.4.287
	)
	5_10? (
		~sys-kernel/ot-sources-5.10.231
	)
	5_15? (
		~sys-kernel/ot-sources-5.15.174
	)
	6_1? (
		~sys-kernel/ot-sources-6.1.120
	)
	6_6? (
		~sys-kernel/ot-sources-6.6.66
	)
	6_12? (
		~sys-kernel/ot-sources-6.12.5
	)
"
SLOT="0/$(ver_cut 1-2 ${PV})"

pkg_postinst() {
	einfo "You still need to call \`emerge --depclean\`."
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
