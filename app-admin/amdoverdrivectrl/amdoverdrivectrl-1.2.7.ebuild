# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

WX_GTK_VER="2.8"

inherit eutils wxwidgets flag-o-matic

DESCRIPTION="This tool let's you control the frequency and fan settings of your AMD/ATI video card."
HOMEPAGE="http://sourceforge.net/projects/amdovdrvctrl"
SRC_URI="mirror://sourceforge/project/amdovdrvctrl/C%2B%2B%20sources/AMDOverdriveCtrl.${PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/AMDOverdriveCtrl"
DOCS=( "create_deb/AUTHORS" "create_deb/changelog" "documentation/QuickStartGuide.pdf" )

RDEPEND="x11-libs/amd-adl-sdk
	x11-libs/wxGTK:2.8[X]"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/fix-makefile-1.2.7.patch"
	emake clean
}

src_configure() {
	append-cflags -fabi-version=9
	append-cxxflags -fabi-version=9
	econf
}
