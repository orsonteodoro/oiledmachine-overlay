# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin network untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="iSAC plugin for GStreamer"
IUSE="
ebuild_revision_2
"
RDEPEND="
	>=media-libs/webrtc-audio-processing-1.0[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
