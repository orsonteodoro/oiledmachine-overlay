# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="Beats-per-minute detection and pitch controlling plugin for GStreamer"
IUSE="
ebuild_revision_12
"
RDEPEND="
	>=media-libs/libsoundtouch-1.4[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
