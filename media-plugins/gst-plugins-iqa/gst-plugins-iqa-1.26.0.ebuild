# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="Image quality assessment plugin for GStreamer"
RDEPEND="
	media-gfx/dssim
	~media-libs/gst-plugins-base-${PV}:1.0
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}/${PN}-1.24.9-use-dssim3.patch"
)

multilib_src_configure() {
	local emesonargs=(
		-Dgpl=enabled
	)
	gstreamer_multilib_src_configure
}
