# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${PV}"
	EGIT_REPO_URI="https://github.com/aiortc/aioquic.git"
	FALLBACK_COMMIT="072eb4b61ec5713661fadb345ce93dcb2a507213" # Mar 12, 2024
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/aiortc/aioquic/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="QUIC and HTTP/3 implementation in Python"
HOMEPAGE="https://github.com/aiortc/aioquic"
LICENSE="
	BSD
"
RESTRICT="mirror test" # Not tested yet
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RDEPEND+="
	(
		>=dev-python/pylsqpack-0.3.3[${PYTHON_USEDEP}]
		<dev-python/pylsqpack-0.4.0[${PYTHON_USEDEP}]
	)
	>=dev-python/cryptography-42.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-24[${PYTHON_USEDEP}]
	>=dev-python/service-identity-24.1.0[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
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
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-util/ruff
	)
"
DOCS=( "docs/index.rst" "README.rst" )

distutils_enable_tests "unittest"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
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
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
