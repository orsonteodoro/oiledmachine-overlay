# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

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

distutils_src_compile_pre_hook() {
	#Force regeneration of cpp with cython
	rm src/re2.cpp || die
}

src_compile() {
	distutils_src_compile --cython
}
