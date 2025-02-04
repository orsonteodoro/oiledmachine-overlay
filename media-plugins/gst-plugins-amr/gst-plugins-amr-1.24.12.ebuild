# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-ugly"
GST_PLUGINS_BUILD_DIR="amrnb amrwbdec"
GST_PLUGINS_ENABLED="amrnb amrwbdec"

inherit gstreamer-meson

#KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="AMRNB encoder/decoder and AMRWB decoder plugin for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
LICENSE="GPL-2"
RDEPEND="
	>=media-libs/opencore-amr-0.1.3[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

