# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"
GST_PLUGINS_BUILD_DIR="ximage"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="X11 video capture stream plugin for GStreamer"
IUSE="
ebuild_revision_13
"
RDEPEND="
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXdamage[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXtst[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		-Dximagesrc=enabled
		-Dximagesrc-navigation=enabled
		-Dximagesrc-xshm=enabled
		-Dximagesrc-xfixes=enabled
		-Dximagesrc-xdamage=enabled
	)
	gstreamer_multilib_src_configure
}
