# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="network plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="AVDTP source/sink and A2DP sink plugin for GStreamer"
IUSE="
ebuild_revision_11
"
RDEPEND="
	>=net-wireless/bluez-5.0[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/gdbus-codegen
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
