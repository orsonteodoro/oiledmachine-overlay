# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/CImg-v.${PV}"
SRC_URI="
https://github.com/GreycLab/CImg/archive/v.${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="C++ template image processing toolkit"
HOMEPAGE="
	https://cimg.eu/
	https://github.com/GreycLab/CImg
"
LICENSE="
	CeCILL-2
	CeCILL-C
"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="doc examples"

src_install() {
	doheader "CImg.h"
	dodoc "README.txt"
	use doc && dodoc -r "html"
	if use examples; then
		dodoc -r "examples"
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
}
