# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-base"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="Visualization elements for GStreamer"
IUSE="
ebuild_revision_10
"
RDEPEND="
	>=media-libs/libvisual-0.4.0:0.4[${MULTILIB_USEDEP}]
	>=media-plugins/libvisual-plugins-0.4.0:0.4[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	gstreamer_system_package audio_dep:gstreamer-audio \
		pbutils_dep:gstreamer-pbutils \
		video_dep:gstreamer-video
}

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
