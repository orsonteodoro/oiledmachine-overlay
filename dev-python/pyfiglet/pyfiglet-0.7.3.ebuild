# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 eutils

DESCRIPTION="FIGlet implementation in python"
HOMEPAGE="https://github.com/pwaller/pyfiglet"
SRC_URI="https://github.com/pwaller/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${P}"

python_prepare_all() {
	eapply_user

	distutils-r1_python_prepare_all
}

python_compile() {
        distutils-r1_python_compile
}

python_install_all() {
        distutils-r1_python_install_all
}
