# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-ugly"

inherit gstreamer-meson

#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="ATSC A/52 audio decoder plugin for GStreamer"
IUSE="+orc"
RDEPEND="
	media-libs/a52dec[${MULTILIB_USEDEP}]
	orc? (
		>=dev-lang/orc-0.4.16[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	local emesonargs=(
		-Dgpl=enabled
	)
	gstreamer_multilib_src_configure
}