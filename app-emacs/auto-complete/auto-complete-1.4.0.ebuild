# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit elisp

DESCRIPTION="Auto-complete package"
HOMEPAGE="http://cx4a.org/software/auto-complete/
	https://github.com/m2ym/auto-complete/"
SRC_URI="https://github.com/auto-complete/auto-complete/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install

	# install dictionaries
	insinto "${SITEETC}/${PN}"
	doins -r dict

	dodoc README.md TODO.md etc/test.txt
	cd doc
	dodoc manual.md changes.md *.png
}
