# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: $

EAPI=5

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://git.code.sf.net/p/${PN}/code.git"
		EGIT_PROJECT="${PN}.git"
		AUTOTOOLS_AUTORECONF=1
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
		S="${WORKDIR}/${P/_/-}"
		;;
esac
inherit autotools-multilib ${VCS_ECLASS} flag-o-matic

DESCRIPTION="Graphical User Interface for PDF Toolkit (PDFtk)"
HOMEPAGE="http://pdfchain.sourceforge.net/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="app-portage/elt-patches
	app-text/pdftk
	>=dev-cpp/gtkmm-3.6.0"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	append-cflags -std=c++11
	append-cxxflags -std=c++11

	econf
}
