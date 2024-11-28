# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-ugly"

inherit gstreamer-meson

# Prohibit based on license or patent status
#KEYWORDS="
#~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
#~amd64-linux ~arm64-macos ~x86-linux
#"

DESCRIPTION="Basepack of plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
LICENSE="LGPL-2+" # Some split plugins are LGPL but combining with a GPL library.
RDEPEND="
	~media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
DOCS=( "AUTHORS" "ChangeLog" "NEWS" "README.md" "RELEASE" )
