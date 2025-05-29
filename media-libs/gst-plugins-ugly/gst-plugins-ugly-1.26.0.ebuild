# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="network untrusted-data"
GST_ORG_MODULE="gst-plugins-ugly"

inherit cflags-hardened gstreamer-meson

# Prohibit based on license or patent status
#KEYWORDS="
#~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
#~amd64-linux ~arm64-macos ~x86-linux
#"

DESCRIPTION="A set of ugly plugins that may have patent or licensing issues for GStreamer and distributors"
HOMEPAGE="https://gstreamer.freedesktop.org/"
LICENSE="LGPL-2+" # Some split plugins are LGPL but combining with a GPL library.
IUSE+="
nls orc
ebuild_revision_14
"
RDEPEND="
	~media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	nls? (
		sys-devel/gettext[${MULTILIB_USEDEP}]
	)
	orc? (
		>=dev-lang/orc-0.4.16
	)
"
DEPEND="
	${RDEPEND}
"
DOCS=( "AUTHORS" "ChangeLog" "NEWS" "README.md" "RELEASE" )

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		 $(meson_feature "nls")
		 $(meson_feature "orc")
	)
	gstreamer_multilib_src_configure
}
