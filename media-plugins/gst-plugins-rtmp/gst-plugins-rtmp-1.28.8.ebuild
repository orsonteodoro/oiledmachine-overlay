# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="network plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

CHKL_TIMESTAMPS=(
	"media-video/rtmpdump-9999"
)

inherit cflags-hardened chkl secure-version gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="RTMP source/sink plugin for GStreamer"
IUSE="
ebuild_revision_23
"
RDEPEND="
	>=media-video/rtmpdump-${RTMPDUMP_PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
