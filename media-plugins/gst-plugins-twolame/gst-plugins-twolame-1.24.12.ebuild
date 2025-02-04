# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-good"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="MPEG2 encoder plugin for GStreamer"
RDEPEND="
	>=media-sound/twolame-0.3.10[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
