# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# wpewebkit

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit secure-version

# See https://github.com/WebKit/WebKit/blob/wpewebkit-2.53.3/Source/cmake/OptionsWPE.cmake
# Force the latest for security
WEBKIT_APIS=(
	"2.0;${WEBKIT_GTK_PV}"
	"1.1;${WEBKIT_GTK_PV}"
)

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"dev-libs/wayland-9999"
	"dev-libs/libxkbcommon-9999"
)

inherit cflags-hardened chkl gstreamer-meson

#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="WPE Web browser plugin for GStreamer"
IUSE="
ebuild_revision_23
"
gen_wpe_rdepend() {
	local row
	for row in "${WEBKIT_APIS[@]}" ; do
		local api_ver="${row%;*}"
		local wpe_ver="${row#*;}"
		echo "
			(
				>=net-libs/wpe-webkit-${wpe_ver}:${api_ver}
				>=gui-libs/wpebackend-fdo-1.8:${api_ver}
				gui-libs/libwpe:${api_ver}
			)
		"
	done
}
RDEPEND="
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/wayland-${WAYLAND_PV}:=
	~media-libs/gst-plugins-base-${PV}:=

	gui-libs/wpebackend-fdo:=
	gui-libs/libwpe:=
	net-libs/wpe-webkit:=
	|| (
		$(gen_wpe_rdepend)
	)
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
