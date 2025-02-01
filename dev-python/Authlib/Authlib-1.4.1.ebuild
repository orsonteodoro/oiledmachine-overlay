# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN,,}"

DISTUTILS_USE_PEP517="setuptools"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/lepture/authlib/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="The ultimate Python library in building OAuth and OpenID Connect servers"
HOMEPAGE="
	https://authlib.org/
	https://github.com/lepture/authlib
	https://pypi.org/project/Authlib/
"
LICENSE="
	custom
	BSD
"
# custom - https://github.com/lepture/authlib/tree/v1.4.1?tab=readme-ov-file#license
# custom - https://github.com/lepture/authlib/blob/v1.4.1/COMMERCIAL-LICENSE
SLOT="0"
IUSE="test"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	>=dev-python/cryptography-3.2[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )

python_test() {
	py.test -v -v || die
}

distutils_enable_tests "pytest"
