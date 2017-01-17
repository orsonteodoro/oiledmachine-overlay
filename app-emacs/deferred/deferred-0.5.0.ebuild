# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils elisp

DESCRIPTION="deferred.el provides facilities to manage asynchronous tasks."
HOMEPAGE=""
COMMIT="9668749635472a63e7a9282e2124325405199b79"
SRC_URI="https://github.com/kiwanami/emacs-deferred/archive/${COMMIT}.zip -> ${P}.zip"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"
IUSE=""
REQUIRED_USE=""
S="${WORKDIR}/${PN}-${COMMIT}"

DEPEND="virtual/emacs"
RDEPEND="${DEPEND}"
SITEFILE="50${PN}-gentoo.el"
S="${WORKDIR}/emacs-deferred-${COMMIT}"

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
