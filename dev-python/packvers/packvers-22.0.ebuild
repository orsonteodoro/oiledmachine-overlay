# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="flit"
PYTHON_COMPAT=( "python3_11" )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main2"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/aboutcode-org/packvers.git"
	FALLBACK_COMMIT="b6e9bbc189d7c1b46e875678dac179995d57c8cd" # Dec 7, 2022
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/aboutcode-org/packvers/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Core utilities for Python packages. Fork to support LegacyVersion"
HOMEPAGE="
	https://github.com/aboutcode-org/packvers
	https://pypi.org/project/packvers
"
LICENSE="
	Apache-2.0
	BSD-2
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/furo[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/coverage-5.0.0[${PYTHON_USEDEP},toml(+)]
		>=dev-python/pip-9.0.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-6.2.0[${PYTHON_USEDEP}]
		dev-python/pretend
	)
"
DOCS=( "CHANGELOG" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version = \"22.0\"" "${S}/pyproject.toml" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE" "LICENSE.APACHE" "LICENSE.BSD"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
