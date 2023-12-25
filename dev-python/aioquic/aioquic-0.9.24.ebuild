# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

if [[ "${PV}" =~ 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/aiortc/aioquic.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${PV}"
	IUSE+=" fallback-commit"
else
	SRC_URI="
https://github.com/aiortc/aioquic/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="QUIC and HTTP/3 implementation in Python"
HOMEPAGE="https://github.com/aiortc/aioquic"
LICENSE="
	BSD
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RESTRICT="test" # Not tested yet
# U 22.04
RDEPEND+="
	(
		>=dev-python/pylsqpack-0.3.3[${PYTHON_USEDEP}]
		<dev-python/pylsqpack-0.4.0[${PYTHON_USEDEP}]
	)
	>=dev-python/pyopenssl-22[${PYTHON_USEDEP}]
	>=dev-python/service-identity-23.1.0[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		dev-python/alabaster[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-autodoc-typehints[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-trio[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/coverage-7.2.2[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-util/ruff[${PYTHON_USEDEP}]
	)
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
DOCS=( docs/index.rst README.rst )

distutils_enable_tests "unittest"

src_unpack() {
	if [[ "${PV}" =~ 9999 ]] ; then
		use fallback-commit && EGIT_COMMIT="041de7169fd5ea67762c89007e43de09a3acd7c5"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = '${PV}'" "${S}/src/aioquic/__init__.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
