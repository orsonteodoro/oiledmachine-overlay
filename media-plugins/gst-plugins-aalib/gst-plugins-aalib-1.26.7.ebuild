# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="aalib text console plugin for GStreamer"
IUSE="
ebuild_revision_13
"
RDEPEND="
	media-libs/aalib[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-good-${PV}:1.0[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
RDEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
