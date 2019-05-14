# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit eutils

MY_PV="3.8"

COMMIT="d3600278e52ddba8d6d6032fa40cf662fef52e0c"

DESCRIPTION="Google from the terminal"
HOMEPAGE="https://github.com/jarun/googler"
SRC_URI="https://github.com/jarun/${PN}/archive/${COMMIT}.zip -> ${P}.zip"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}-${COMMIT}"

export PREFIX="/usr"
export DOCDIR="/usr/share/${P}"

src_install() {
	default
	rm -rf "${D}/usr/share/doc/googler"
}
