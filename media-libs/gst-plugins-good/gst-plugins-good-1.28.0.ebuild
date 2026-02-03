# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Old media-libs/gst-plugins-ugly is a blocker for xingmux moving from ugly->good.

# TODO package:
# amrnb
# amrwbdec

CFLAGS_HARDENED_USE_CASES="network security-critical untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE HO IO IU UAF UM"
GST_ORG_MODULE="gst-plugins-good"
#MITIGATION_DATE="Dec 3, 2024" # Advisory date
#MITIGATION_URI="https://gstreamer.freedesktop.org/security/"
#SEVERITY_LABEL="CVSS 4.0"
#VULNERABILITIES_FIXED=(
#)

inherit cflags-hardened gstreamer-meson vf

KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
~amd64-linux ~arm64-macos ~x86-linux
"

DESCRIPTION="A set of good plugins that meet licensing, code quality, and support needs of GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
LICENSE="LGPL-2.1+"
IUSE="
nls +orc
ebuild_revision_26
"
RDEPEND="
	>=dev-libs/glib-2.64.0:2[${MULTILIB_USEDEP}]
	dev-libs/glib:=
	app-arch/bzip2[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	media-libs/gst-plugins-base:=
	nls? (
		sys-devel/gettext[${MULTILIB_USEDEP}]
	)
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

pkg_setup() {
	if [[ -n "${MITIGATION_URI}" ]] ; then
einfo "Security announcement date:  ${MITIGATION_DATE}"
einfo "Security vulnerabilities fixed:  ${MITIGATION_URI}"
	fi
	vf_show
	gstreamer-meson_pkg_setup
}

multilib_src_configure() {
	cflags-hardened_append
	# gst/matroska can use bzip2
	GST_PLUGINS_NOAUTO="bz2"
	local emesonargs=(
		$(meson_feature "nls")
		-Dbz2=enabled
	)
	gstreamer_multilib_src_configure
}
