# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"
GST_PLUGINS_BUILD_DIR="raw1394"
GST_PLUGINS_ENABLED="dv1394"

inherit cflags-hardened gstreamer-meson

DESCRIPTION="A FireWire DV/HDV capture plugin for GStreamer"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
IUSE="
ebuild_revision_10
"
RDEPEND="
	>=media-libs/libiec61883-1.0.0[${MULTILIB_USEDEP}]
	>=sys-libs/libraw1394-2.0.0[${MULTILIB_USEDEP}]
	>=sys-libs/libavc1394-0.5.4[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
