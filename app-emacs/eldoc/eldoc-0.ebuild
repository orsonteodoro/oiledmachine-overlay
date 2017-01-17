# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils elisp

DESCRIPTION="ElDoc A very simple but effective thing, eldoc-mode is a MinorMode which shows you, in the echo area, the argument list of the function call you are currently writing."
HOMEPAGE=""
SRC_URI=""
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"
IUSE=""
REQUIRED_USE=""
S="${WORKDIR}/${PN}-${PV}"

DEPEND="app-editors/emacs"
RDEPEND="${DEPEND}"
SITEFILE="50${PN}-gentoo.el"
S="${WORKDIR}"

src_prepare() {
	eapply_user
}

src_compile() {
	true
}

src_install() {
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
}

pkg_postinst() {
        elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
