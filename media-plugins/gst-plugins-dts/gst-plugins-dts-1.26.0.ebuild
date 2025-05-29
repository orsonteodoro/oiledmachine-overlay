# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"

DESCRIPTION="DTS audio decoder plugin for GStreamer"
IUSE="
+orc
ebuild_revision_12
"
RDEPEND="
	media-libs/libdca[${MULTILIB_USEDEP}]
	orc? (
		>=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}]
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
