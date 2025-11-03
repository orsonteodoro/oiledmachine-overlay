# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"
GST_PLUGINS_BUILD_DIR="amrnb amrwbdec"
GST_PLUGINS_ENABLED="amrnb amrwbdec"

inherit cflags-hardened gstreamer-meson

#KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="AMRNB encoder/decoder and AMRWB decoder plugin for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
LICENSE="GPL-2"
IUSE="
ebuild_revision_13
"
RDEPEND="
	>=media-libs/opencore-amr-0.1.3[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
