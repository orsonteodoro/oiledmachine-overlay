# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"

DESCRIPTION="MOD audio decoder plugin for GStreamer"
RDEPEND="
	media-libs/libmodplug[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
