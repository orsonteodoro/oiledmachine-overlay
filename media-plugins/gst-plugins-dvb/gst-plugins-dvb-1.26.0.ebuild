# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"

DESCRIPTION="DVB device capture plugin for GStreamer"
IUSE="
ebuild_revision_10
"
RDEPEND="
"
DEPEND="
	virtual/os-headers
"

src_prepare() {
	default
	gstreamer_system_package gstmpegts_dep:gstreamer-mpegts
}

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
