# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-good"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="Speex encoder/decoder plugin for GStreamer"
RDEPEND="
	>=media-libs/speex-1.1.6[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
