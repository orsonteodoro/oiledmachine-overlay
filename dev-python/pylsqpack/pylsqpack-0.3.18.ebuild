# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

PROPERTIES="live"
if [[ "${PV}" =~ "9999" || 1 ]] ; then
# Enter always because
# git metadata is always required.
	EGIT_REPO_URI="https://github.com/aiortc/pylsqpack.git"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${PV}"
	EGIT_COMMIT="8d6acefcfdd1d4feebc2c0653f51407ecc577263"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/aiortc/pylsqpack/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Python bindings for ls-qpack"
HOMEPAGE="https://github.com/aiortc/pylsqpack"
LICENSE="
	BSD
"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RDEPEND+="
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
	)
	test? (
		dev-python/black[${PYTHON_USEDEP}]
		dev-util/ruff
	)
"
RESTRICT="mirror"
DOCS=( "docs/index.rst" "README.rst" )

src_unpack() {
	if [[ "${PV}" =~ "9999" || 1 ]] ; then
# git metadata is always required.
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = \"${PV}\"" "${S}/src/pylsqpack/__init__.py" \
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

distutils_enable_tests "unittest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
