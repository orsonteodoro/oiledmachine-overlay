# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python extension that wraps Google's RE2 library."
HOMEPAGE="https://github.com/axiak/pyre2 http://pypi.python.org/pypi/re2/"
SRC_URI="mirror://pypi/r/re2/re2-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/re2
	dev-python/cython"
RDEPEND="dev-libs/re2"

S=${WORKDIR}/re2-${PV}

python_prepare_all() {
	append-cxxflags -std=c++11

	eapply_user

	distutils-r1_python_prepare_all
}

src_compile() {
	distutils-r1_src_compile --cython
}
