# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

DESCRIPTION="Ladspa elements for Gstreamer"
RDEPEND="
	media-libs/ladspa-sdk[${MULTILIB_USEDEP}]
	media-libs/liblrdf[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
