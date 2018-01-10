# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic toolchain-funcs

DESCRIPTION="Python extension that wraps Google's RE2 library."
HOMEPAGE="https://github.com/facebook/pyre2"
SRC_URI="https://github.com/facebook/pyre2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/re2
	dev-python/cython"
RDEPEND="dev-libs/re2"

S=${WORKDIR}/${PN}-${PV}

python_prepare_all() {
        if (( $(gcc-major-version) >= 6 )) ; then
		sed -i -e 's|-std=c++11|-std=c++14|g' setup.py || die
		append-cxxflags -std=c++14
	fi

	eapply_user

	distutils-r1_python_prepare_all
}

src_compile() {
	distutils-r1_src_compile --cython
}
