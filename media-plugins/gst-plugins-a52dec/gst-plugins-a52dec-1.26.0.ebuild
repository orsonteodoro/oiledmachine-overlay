# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-ugly"

inherit cflags-hardened gstreamer-meson

#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="ATSC A/52 audio decoder plugin for GStreamer"
IUSE="
+orc
ebuild_revision_13
"
RDEPEND="
	media-libs/a52dec[${MULTILIB_USEDEP}]
	media-libs/gst-plugins-ugly:1.0[${MULTILIB_USEDEP},orc?]
	orc? (
		>=dev-lang/orc-0.4.16[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		-Dgpl=enabled
	)
	gstreamer_multilib_src_configure
}
