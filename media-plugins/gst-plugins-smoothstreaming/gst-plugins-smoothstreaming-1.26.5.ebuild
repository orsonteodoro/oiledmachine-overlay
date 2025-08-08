# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="network plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="Smooth Streaming plugin for GStreamer"
IUSE="
ebuild_revision_13
"
RDEPEND="
	>=dev-libs/libxml2-2.8[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	gstreamer_system_package gstcodecparsers_dep:gstreamer-codecparsers
	gstreamer_system_library \
		gstadaptivedemux_dep:gstadaptivedemux \
		gstisoff_dep:gstisoff \
		gsturidownloader_dep:gsturidownloader
}

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}

pkg_postinst() {
einfo
einfo "media-plugins/gst-plugins-adaptivedemux2 provides an alternative smooth"
einfo "streaming demuxer option (mssdemux2)"
einfo
}
