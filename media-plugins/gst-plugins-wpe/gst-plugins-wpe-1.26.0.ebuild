# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# wpewebkit

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"
WEBKIT_APIS=(
	"2.0;2.40.1"
	"1.1;2.33.1"
	"1.0;2.28.0"
)

inherit cflags-hardened gstreamer-meson

#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="WPE Web browser plugin for GStreamer"
IUSE="
ebuild_revision_10
"
gen_wpe_rdepend() {
	local row
	for row in ${WEBKIT_APIS[@]} ; do
		local api_ver="${row%;*}"
		local wpe_ver="${row#*;}"
		echo "
			(
				>=gui-libs/wpebackend-fdo-1.8:${api_ver}
				>=net-libs/wpe-webkit-${wpe_ver}:${api_ver}
				gui-libs/libwpe:${api_ver}
			)
		"
	done
}
RDEPEND="
	>=x11-libs/libxkbcommon-0.8
	dev-libs/glib:2
	dev-libs/wayland
	~media-libs/gst-plugins-base-${PV}:1.0
	|| (
		$(gen_wpe_rdepend)
	)
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
