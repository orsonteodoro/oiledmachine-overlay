# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-good"
GST_PLUGINS_BUILD_DIR="gdk_pixbuf"
GST_PLUGINS_ENABLED="gdk-pixbuf"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc x86"

DESCRIPTION="Image decoder, overlay and sink plugin for GStreamer"
RDEPEND="
	>=x11-libs/gdk-pixbuf-2.8.0:2[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
