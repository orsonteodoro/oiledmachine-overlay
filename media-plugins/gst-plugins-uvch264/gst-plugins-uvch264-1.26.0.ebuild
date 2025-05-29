# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="UVC compliant H.264 encoding cameras plugin for GStreamer"
IUSE="
ebuild_revision_12
"
RDEPEND="
	dev-libs/libgudev:=[${MULTILIB_USEDEP}]
	virtual/libusb:1[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	gstreamer_system_library gstbasecamerabin_dep:libgstbasecamerabinsrc
}

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
