# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/efficios/barectf.git"
	FALLBACK_COMMIT="a3ccab79d8fc99c90403adcc33aa2e6ba4878b84" # May 16, 2023
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/efficios/barectf/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${P}"

DESCRIPTION="Generator of ANSI C tracers which output CTF data streams"
HOMEPAGE="
https://barectf.org/
https://github.com/efficios/barectf
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	>=dev-python/jinja2-3.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.3[${PYTHON_USEDEP}]
	>=dev-python/termcolor-1.1[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/pylint-2.13[${PYTHON_USEDEP}]
	dev-python/flake8[${PYTHON_USEDEP}]
	dev-python/mypy[${PYTHON_USEDEP}]
	dev-python/poetry-core[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-6[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.adoc" )

distutils_enable_tests "pytest"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version = '${PV}'" "${S}/pyproject.toml" \
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
