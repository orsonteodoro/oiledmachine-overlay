# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Python bindings for the Plex API."
HOMEPAGE="https://github.com/pkkid/python-plexapi"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
DEPEND+="
	>=dev-python/requests-2.28.2[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	doc? (
		>=dev-python/sphinx-4.3.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx_rtd_theme-1.2.0[${PYTHON_USEDEP}]
	)
	test? (
		<dev-python/pytest-mock-3.10.1[${PYTHON_USEDEP}]
		>=dev-python/coveralls-3.3.1[${PYTHON_USEDEP}]
		>=dev-python/flake8-5.0.4[${PYTHON_USEDEP}]
		>=dev-python/pillow-9.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-cache-1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/recommonmark-0.7.1[${PYTHON_USEDEP}]
		>=dev-python/requests-2.28.2[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.65.0[${PYTHON_USEDEP}]
		>=dev-python/websocket-client-1.5.1[${PYTHON_USEDEP}]
	)"
SRC_URI="
https://github.com/pkkid/python-plexapi/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META-REVDEP:  tizonia
