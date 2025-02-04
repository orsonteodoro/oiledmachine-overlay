# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm64 ~ppc ~ppc64 ~x86"

DESCRIPTION="HTTP client source plugin for GStreamer"
RDEPEND="
	>=net-libs/neon-0.27[${MULTILIB_USEDEP}]
	<=net-libs/neon-0.33.99[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
