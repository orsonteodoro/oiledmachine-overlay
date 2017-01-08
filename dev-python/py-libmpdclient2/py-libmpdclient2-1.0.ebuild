# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 eutils

DESCRIPTION="py-libmpdclient2"
HOMEPAGE="http://incise.org/py-libmpdclient2.html"
SRC_URI="http://incise.org/files/dev/${PN}-${PV}.tgz"
LICENSE="as-is"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}"

python_prepare_all() {
	eapply_user

	distutils-r1_python_prepare_all
}

python_compile() {
        distutils-r1_python_compile
}

python_test() {
        local msg="tests failed under ${EPYTHON}"

        if python_is_python3; then
                "${PYTHON}" test.py || die $msg
        else
                "${PYTHON}" test.py || die $msg
        fi
}

python_install_all() {
        distutils-r1_python_install_all
}
