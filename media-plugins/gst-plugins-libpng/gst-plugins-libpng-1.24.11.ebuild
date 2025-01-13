# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-good"
GST_PLUGINS_ENABLED="png"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="PNG image encoder/decoder plugin for GStreamer"
RDEPEND="
	>=media-libs/libpng-1.2:0=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
