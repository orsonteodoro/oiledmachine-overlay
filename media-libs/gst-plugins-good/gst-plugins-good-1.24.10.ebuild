# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Old media-libs/gst-plugins-ugly is a blocker for xingmux moving from ugly->good.

GST_ORG_MODULE="gst-plugins-good"

inherit gstreamer-meson

KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
~amd64-linux ~arm64-macos ~x86-linux
"

DESCRIPTION="A set of good plugins that meet licensing, code quality, and support needs of GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
LICENSE="LGPL-2.1+"
IUSE="+orc"
RDEPEND="
	!<media-libs/gst-plugins-ugly-1.24.9
	>=dev-libs/glib-2.64.0[${MULTILIB_USEDEP}]
	app-arch/bzip2[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	orc? (
		>=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-lang/nasm-2.13
	virtual/pkgconfig
"

DOCS=( "AUTHORS" "ChangeLog" "NEWS" "README.md" "RELEASE" )

multilib_src_configure() {
	# gst/matroska can use bzip2
	GST_PLUGINS_NOAUTO="bz2"
	local emesonargs=(
		-Dbz2=enabled
	)
	gstreamer_multilib_src_configure
}
