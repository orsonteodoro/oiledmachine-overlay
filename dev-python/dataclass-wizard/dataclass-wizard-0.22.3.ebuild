# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# jsons
# dataclass-factory

MY_PN="${PN}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${PV}"
	EGIT_REPO_URI="https://github.com/rnag/dataclass-wizard.git"
	FALLBACK_COMMIT="2ebc5d8b0c43eabd3dc1846544b191cefb298bfd" # Jan 29, 2024
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/rnag/dataclass-wizard/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="A simple, yet elegant, set of wizarding tools for interacting with Python dataclasses."
HOMEPAGE="https://github.com/rnag/dataclass-wizard"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc test timedelta yaml"
REQUIRED_USE+="
	dev? (
		doc
		timedelta
		test
	)
"
RDEPEND+="
	timedelta? (
		>=dev-python/pytimeparse-1.1.8[${PYTHON_USEDEP}]
	)
	yaml? (
		>=dev-python/pyyaml-5.3[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/bump2version-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/coverage-6.2[${PYTHON_USEDEP}]
		>=dev-python/flake8-3[${PYTHON_USEDEP}]
		>=dev-python/pip-21.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytimeparse-1.1.8[${PYTHON_USEDEP}]
		>=dev-python/tox-3.24.5[${PYTHON_USEDEP}]
		>=dev-python/twine-3.8.0[${PYTHON_USEDEP}]
		>=dev-python/watchdog-2.1.6[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.42.0[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/sphinx-5.3.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-issues-4.0.0[${PYTHON_USEDEP}]
		dev-python/alabaster[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/dataclass-factory-2.12[${PYTHON_USEDEP}]
		>=dev-python/dataclasses-json-0.5.6[${PYTHON_USEDEP}]
		>=dev-python/jsons-1.6.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.6.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-runner-5.3.1[${PYTHON_USEDEP}]
	)
"
DOCS=( "HISTORY.rst" "README.rst" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = '0.22.3'" "${S}/dataclass_wizard/__version__.py" \
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

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
