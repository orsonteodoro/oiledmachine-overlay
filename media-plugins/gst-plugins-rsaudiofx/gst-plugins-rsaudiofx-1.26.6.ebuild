# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="A redirect ebuild for gst-plugins-audiofx"
LICENSE="metapackage"
SLOT="1.0"
RDEPEND="
	~media-libs/gst-plugins-rs-${PV}:1.0[audiofx]
"
DEPEND="
	${RDEPEND}
"
