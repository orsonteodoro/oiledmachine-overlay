# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild will assist in updating blender to the latest stable automatically.

EAPI=8
DESCRIPTION="Virtual for Blender® stable"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="~media-gfx/blender-${PV}"
REQUIRED_USE=""
SLOT="0/$(ver_cut 1-2 ${PV})"

pkg_postinst() {
	einfo "You still need to \`emerge --depclean\`."
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
