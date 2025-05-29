# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin network untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="MPEG-DASH plugin for GStreamer"
IUSE="
ebuild_revision_11
"
RDEPEND="
	>=dev-libs/libxml2-2.8[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	gstreamer_system_library \
		gstadaptivedemux_dep:gstadaptivedemux \
		gsturidownloader_dep:gsturidownloader \
		gstisoff_dep:gstisoff
}

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}

pkg_postinst() {
einfo
einfo "media-plugins/gst-plugins-adaptivedemux2 provides an alternative DASH"
einfo "demuxer option (dashdemux2)"
einfo
}
