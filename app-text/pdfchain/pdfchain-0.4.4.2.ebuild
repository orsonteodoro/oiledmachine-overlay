# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION="Graphical User Interface for PDF Toolkit (PDFtk)"
HOMEPAGE="http://pdfchain.sourceforge.net/"
KEYWORDS="~amd64 ~arm ~x86"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
S="${WORKDIR}/${P/_/-}"
LICENSE="GPL-3"
SLOT="0"
IUSE=""
inherit autotools-multilib flag-o-matic toolchain-funcs
DEPEND=">=app-text/pdftk-2.0
	>=dev-cpp/atkmm-1.6[${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.4[${MULTILIB_USEDEP}]
	>=dev-cpp/gtkmm-3.18[${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.0[${MULTILIB_USEDEP}]
	sys-devel/gcc
	virtual/libc"
RDEPEND="${DEPEND}"
DOCS=( AUTHORS ChangeLog NEWS README )
RESTRICT="mirror"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	econf
}
