# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="AAC audio encoder plugin for GStreamer"
RDEPEND="
	media-libs/faac[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"