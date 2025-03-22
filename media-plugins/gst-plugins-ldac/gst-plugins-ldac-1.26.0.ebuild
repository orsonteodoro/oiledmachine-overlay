# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

DESCRIPTION="LDAC plugin for GStreamer"
RDEPEND="
	media-libs/libldac[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
