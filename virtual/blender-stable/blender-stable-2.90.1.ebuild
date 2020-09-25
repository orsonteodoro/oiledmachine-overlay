# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild will assist in updating blender to the latest stable automatically.

EAPI=7
DESCRIPTION="Virtual for Blender stable"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="~sys-kernel/ot-sources-${PV}"
REQUIRED_USE=""
SLOT="0/${PV}"

pkg_postinst() {
	einfo "You still need to \`emerge --depclean\`."
}
