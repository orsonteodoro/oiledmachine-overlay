# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

SRC_URI="
https://github.com/pkkid/python-plexapi/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

DESCRIPTION="Python bindings for the Plex API."
HOMEPAGE="https://github.com/pkkid/python-plexapi"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" alert doc test"
RDEPEND+="
	>=dev-python/requests-2.28.2[${PYTHON_USEDEP}]
	alert? (
		>=dev-python/websocket-client-1.3.3
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
		>=dev-python/sphinx_rtd_theme-2.0.0[${PYTHON_USEDEP}]
	)
	test? (
		<dev-python/pytest-mock-3.12.0[${PYTHON_USEDEP}]
		>=dev-python/coveralls-3.3.1[${PYTHON_USEDEP}]
		>=dev-python/flake8-6.1.0[${PYTHON_USEDEP}]
		>=dev-python/pillow-10.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-cache-1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/recommonmark-0.7.1[${PYTHON_USEDEP}]
		>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.11.0[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.66.1[${PYTHON_USEDEP}]
		>=dev-python/websocket-client-1.7.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META-REVDEP:  tizonia
