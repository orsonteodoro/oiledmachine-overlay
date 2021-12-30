# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild will assist in updating blender to the latest LTS automatically.

EAPI=7
DESCRIPTION="Virtual for Blender LTS"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="~media-gfx/blender-${PV}"
REQUIRED_USE=""
SLOT="0/${PV}"

pkg_postinst() {
	einfo "You still need to \`emerge --depclean\`."
}
