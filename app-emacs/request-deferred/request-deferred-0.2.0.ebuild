# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils elisp

DESCRIPTION="Request.el -- Easy HTTP request for Emacs Lisp"
HOMEPAGE=""
SRC_URI="https://github.com/tkf/emacs-request/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"
IUSE=""
REQUIRED_USE=""
S="${WORKDIR}/${PN}-${PV}"

DEPEND="virtual/emacs
        app-emacs/deferred"
RDEPEND="${DEPEND}"
SITEFILE="50${PN}-gentoo.el"
S="${WORKDIR}/emacs-request-${PV}"

src_prepare() {
	eapply_user
}

src_compile() {
	true
}

src_install() {
	elisp-install request-deferred request-deferred.el
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
}

pkg_postinst() {
        elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
