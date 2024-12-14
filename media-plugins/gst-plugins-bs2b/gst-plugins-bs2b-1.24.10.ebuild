# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

DESCRIPTION="bs2b elements for GStreamer"
RDEPEND="
	>=media-libs/libbs2b-3.1.0[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
