# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# flake8-pep3101
# pep8-naming
# pendulum

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/tammoippen/plotille.git"
	FALLBACK_COMMIT="6e13ed9bdb9a0fad818c6aa17b649e0e76ce15ca" # May 6, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	EGIT_COMMIT="6e13ed9bdb9a0fad818c6aa17b649e0e76ce15ca" # May 6, 2024
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/tammoippen/plotille/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Plot in the terminal using braille dots."
HOMEPAGE="
	https://github.com/tammoippen/plotille
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Not tested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/poetry-core[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/flake8-5[${PYTHON_USEDEP}]
		>=dev-python/flake8-bugbear-22[${PYTHON_USEDEP}]
		>=dev-python/flake8-commas-2[${PYTHON_USEDEP}]
		>=dev-python/flake8-comprehensions-3[${PYTHON_USEDEP}]
		>=dev-python/flake8-import-order-0.18[${PYTHON_USEDEP}]
		>=dev-python/flake8-pep3101-1[${PYTHON_USEDEP}]
		>=dev-python/flake8-polyfill-1[${PYTHON_USEDEP}]
		>=dev-python/flake8-quotes-3[${PYTHON_USEDEP}]
		>=dev-python/mock-3[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		>=dev-python/pep8-naming-0.11[${PYTHON_USEDEP}]
		>=virtual/pillow-9[${PYTHON_USEDEP}]
		>=dev-python/pytest-6[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-3[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-2[${PYTHON_USEDEP}]
		>=dev-python/pytest-pythonpath-0.7.3[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/pendulum-2[${PYTHON_USEDEP}]
		' python3_{10..11})
		$(python_gen_cond_dep '
			>=dev-python/pendulum-3[${PYTHON_USEDEP}]
		' python3_12)
	)
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-5.1.0-pep517.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version = \"5.1.0\"" "${S}/pyproject.toml" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
