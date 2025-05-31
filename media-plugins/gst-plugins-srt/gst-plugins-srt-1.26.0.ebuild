# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="network plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Secure reliable transport (SRT) transfer plugin for GStreamer"
IUSE="
ebuild_revision_13
"
RDEPEND="
	>=net-libs/srt-1.3.0:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/glib-utils
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
