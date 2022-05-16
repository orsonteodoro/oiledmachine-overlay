# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild will assist in updating ot-sources to the latest stable

EAPI=7
DESCRIPTION="Virtual for the ot-sources stable ebuilds"
KEYWORDS=\
"~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""
RDEPEND="~sys-kernel/ot-sources-${PV}"
REQUIRED_USE=""
SLOT="0/${PV}"

pkg_postinst() {
	einfo "You still need to call \`emerge --depclean\`."
}
