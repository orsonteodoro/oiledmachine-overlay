# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils elisp

DESCRIPTION="On the fly syntax checking for GNU Emacs"
HOMEPAGE="http://www.flycheck.org"
SRC_URI="https://github.com/flycheck/flycheck/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
S="${WORKDIR}/${PN}-${PV}"

DEPEND="virtual/emacs
        app-emacs/let-alist
        app-emacs/dash"
RDEPEND="${DEPEND}"
SITEFILE="50flycheck-gentoo.el"

src_prepare() {
	cp "${FILESDIR}/${SITEFILE}" ./

	eapply_user
}

src_compile() {
	true
}

src_install() {
	elisp-install ${PN} *.el || die
	elisp-site-file-install "${S}/${SITEFILE}" || die
}

pkg_postinst() {
        elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
