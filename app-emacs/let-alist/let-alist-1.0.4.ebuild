# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils elisp

DESCRIPTION="Easily let-bind values of an assoc-list by their names"
HOMEPAGE=""
SRC_URI="http://elpa.gnu.org/packages/let-alist-${PV}.el"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"
IUSE=""
REQUIRED_USE=""
S="${WORKDIR}/${PN}-${PV}"

DEPEND="virtual/emacs"
RDEPEND="${DEPEND}"
SITEFILE="50${PN}-gentoo.el"
S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
	mkdir -p "${S}"
	cd "${S}"
	cp "${DISTDIR}/${A}" ./${PN}.el
}

src_prepare() {
	eapply_user
}

src_compile() {
	true
}

src_install() {
	elisp-install ${PN} *.el
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
}

pkg_postinst() {
        elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
