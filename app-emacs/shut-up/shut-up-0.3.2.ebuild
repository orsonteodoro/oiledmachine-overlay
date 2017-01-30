# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils elisp

DESCRIPTION="Emacs, shut up would you!"
HOMEPAGE=""
SRC_URI="https://github.com/cask/shut-up/archive/v${PV}.tar.gz -> ${P}.tar.gz"
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
