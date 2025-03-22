# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="Calculate Chromaprint fingerprint from audio files for GStreamer"
RDEPEND="
	media-libs/chromaprint[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
