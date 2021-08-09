# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild will assist in updating ot-sources to the latest LTS
# (Long Term Support) version.

EAPI=7
DESCRIPTION="Virtual for the ot-sources LTS ebuilds for"
KEYWORDS=\
"~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="4_14 5_4 5_10"
RDEPEND="
	4_14? ( ~sys-kernel/ot-sources-4.14.243 )
	5_4? ( ~sys-kernel/ot-sources-5.4.139 )
	5_10? ( ~sys-kernel/ot-sources-5.10.57 )
"
REQUIRED_USE=""
SLOT="0/${PV}"

pkg_postinst() {
	einfo "You still need to call \`emerge --depclean\`."
}
