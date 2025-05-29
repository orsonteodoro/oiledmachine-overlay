# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="OSS (Open Sound System) support plugin for GStreamer"
IUSE="
ebuild_revision_12
"
RDEPEND="
"
DEPEND="
	virtual/os-headers
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}

