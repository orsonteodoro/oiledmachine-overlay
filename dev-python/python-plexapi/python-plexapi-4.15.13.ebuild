# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} ) # CI only tests 3.8

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/pkkid/python-plexapi/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Python bindings for the Plex API."
HOMEPAGE="https://github.com/pkkid/python-plexapi"
LICENSE="BSD"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" alert doc test"
RDEPEND+="
	>=dev-python/requests-2.28.2[${PYTHON_USEDEP}]
	alert? (
		>=dev-python/websocket-client-1.3.3[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/twine[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-7.1.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-2.0.0[${PYTHON_USEDEP}]
	)
	test? (
		<dev-python/pytest-mock-3.12.0[${PYTHON_USEDEP}]
		>=dev-python/coveralls-4.0.1[${PYTHON_USEDEP}]
		>=dev-python/flake8-7.0.0[${PYTHON_USEDEP}]
		>=virtual/pillow-10.3.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.2.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-cache-1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-5.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.14.0[${PYTHON_USEDEP}]
		>=dev-python/recommonmark-0.7.1[${PYTHON_USEDEP}]
		>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.12.1[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.66.4[${PYTHON_USEDEP}]
		>=dev-python/websocket-client-1.8.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META-REVDEP:  tizonia
