# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 eutils

DESCRIPTION="Python implementation of Pocket API"
HOMEPAGE="https://github.com/tapanpandita/pocket/"
SRC_URI="https://pypi.python.org/packages/57/b6/cd79a0e237e733e2f8a196f4e9f4d30d99c769b809c5fbbea9e34400655d/${PN}-${PV}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${P}"

python_compile() {
        distutils-r1_python_compile
}

python_install_all() {
        distutils-r1_python_install_all
}
