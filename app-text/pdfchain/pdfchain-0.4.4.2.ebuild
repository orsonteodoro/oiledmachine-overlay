# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Graphical User Interface for PDF Toolkit (PDFtk)"
HOMEPAGE="http://pdfchain.sourceforge.net/"
KEYWORDS="~amd64 ~arm ~x86"
LICENSE="GPL-3"
SLOT="0"
# FIXME:  multilib support
DEPEND="
	>=app-text/pdftk-2.0
	>=dev-cpp/atkmm-1.6[${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.4[${MULTILIB_USEDEP}]
	>=dev-cpp/gtkmm-3.18[${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.0[${MULTILIB_USEDEP}]
	sys-devel/gcc
	virtual/libc
"
RDEPEND="${DEPEND}"
DOCS=( AUTHORS ChangeLog NEWS README )
RESTRICT="mirror"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
S="${WORKDIR}/${P/_/-}"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	econf
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib
