# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

if [[ "${PV}" =~ 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rnag/dataclass-wizard.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${PV}"
	IUSE+=" fallback-commit"
else
	SRC_URI="
https://github.com/rnag/dataclass-wizard/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A simple, yet elegant, set of wizarding tools for interacting with Python dataclasses."
HOMEPAGE="https://github.com/rnag/dataclass-wizard"
LICENSE="
	Apache-2.0
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc extras timedelta yaml"
DEPEND+="
	>=dev-python/absl-py-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/dm-tree-0.1.6[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.22.0[${PYTHON_USEDEP}]
	timedelta? (
		>=dev-python/pytimeparse-1.1.7
	)
	yaml? (
		>=dev-python/pyyaml-5.3
	)
"
RDEPEND+="
	${DEPEND}
"
# Missing:
# dataclasses-json
# jsons
# dataclass-factory
BDEPEND+="
	>=dev-python/bump2version-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/coverage-6.2[${PYTHON_USEDEP}]
	>=dev-python/flake8-3[${PYTHON_USEDEP}]
	>=dev-python/pip-21.3.1[${PYTHON_USEDEP}]
	>=dev-python/pytimeparse-1.1.8[${PYTHON_USEDEP}]
	>=dev-python/tox-3.24.5[${PYTHON_USEDEP}]
	>=dev-python/twine-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.37.1[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-4.4.0[${PYTHON_USEDEP}]
		dev-python/alabaster[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-7.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.6.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-runner-5.3.1[${PYTHON_USEDEP}]
	)
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
DOCS=( HISTORY.rst README.rst )

src_unpack() {
	if [[ "${PV}" =~ 9999 ]] ; then
		use fallback-commit && EGIT_COMMIT="e3fe0760422613eaf79e0236840a50f27caec064"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = '1.6'" "${S}/dm_env/_metadata.py" \
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

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
