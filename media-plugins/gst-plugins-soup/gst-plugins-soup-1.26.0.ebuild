# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Checks at runtime which libsoup was linked in and picks the appropriate one.
# Need both here to guarantee consumers will work.
# May be able to get rid of 2.4 later if it's possible to build 2.4 support
# from 3.0 headers.

CFLAGS_HARDENED_USE_CASES="network plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"

DESCRIPTION="HTTP client source/sink plugin for GStreamer"
IUSE="
ebuild_revision_13
"
RDEPEND="
	>=net-libs/libsoup-2.48:2.4[${MULTILIB_USEDEP}]
	>=net-libs/libsoup-3:3.0[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
