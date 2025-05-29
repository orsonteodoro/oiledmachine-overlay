# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="network plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

DESCRIPTION="SRTP encoder/decoder plugin for GStreamer"
IUSE="
ebuild_revision_12
"
RDEPEND="
	>=net-libs/libsrtp-2.1.0:2=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/glib-utils
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
