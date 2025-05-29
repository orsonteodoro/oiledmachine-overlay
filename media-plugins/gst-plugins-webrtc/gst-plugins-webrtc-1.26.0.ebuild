# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="network plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"
GST_PLUGINS_BUILD_DIR="webrtc webrtcdsp"
GST_PLUGINS_ENABLED="webrtc webrtcdsp"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="WebRTC plugins for GStreamer"
IUSE="
ebuild_revision_11
"
RDEPEND="
	~media-plugins/gst-plugins-sctp-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/webrtc-audio-processing-1.0:0[${MULTILIB_USEDEP}]
	>=net-libs/libnice-0.1.20[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	gstreamer_system_package \
		gstwebrtc_dep:gstreamer-webrtc \
		gstsctp_dep:gstreamer-sctp \
		gstbadaudio_dep:gstreamer-bad-audio
}

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}

multilib_src_install() {
	# TODO: Fix this properly, see bug #907470 and bug #909079.
	insinto "/usr/$(get_libdir)"
	doins "${BUILD_DIR}/ext/webrtc/libgstwebrtc.so"
	doins "${BUILD_DIR}/gst-libs/gst/webrtc/nice/libgstwebrtcnice-1.0.so"*
	insinto "/usr/include/gstreamer-1.0/gst/webrtc/nice"
	doins "${S}/gst-libs/gst/webrtc/nice/"*".h"
	gstreamer_multilib_src_install
}
