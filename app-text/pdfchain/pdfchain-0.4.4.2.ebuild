# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# FIXME:  multilib support

inherit flag-o-matic multilib-minimal toolchain-funcs

KEYWORDS="~amd64 ~arm ~x86"
S="${WORKDIR}/${P/_/-}"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

DESCRIPTION="Graphical User Interface for PDF Toolkit (PDFtk)"
HOMEPAGE="http://pdfchain.sourceforge.net/"
LICENSE="GPL-3"
RESTRICT="mirror"
SLOT="0"
RDEPEND="
	>=app-text/pdftk-2.0
	>=dev-cpp/atkmm-1.6[${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.4[${MULTILIB_USEDEP}]
	>=dev-cpp/gtkmm-3.18[${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.0[${MULTILIB_USEDEP}]
	sys-devel/gcc
	virtual/libc
"
DEPEND="
	${RDEPEND}
"
DOCS=( "AUTHORS" "ChangeLog" "NEWS" "README" )

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	econf
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib
