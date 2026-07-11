# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened secure-version gstreamer-meson

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Bar codes detection in video streams for GStreamer"
IUSE="
ebuild_revision_23
"
RDEPEND="
	>=media-gfx/zbar-${ZBAR_PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
