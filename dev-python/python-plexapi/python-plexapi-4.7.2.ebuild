# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python bindings for the Plex API."
HOMEPAGE="https://github.com/pkkid/python-plexapi"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE+=" doc test"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+=" ${PYTHON_DEPS}
	dev-python/requests[${PYTHON_USEDEP}]"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	doc? (
		>=dev-python/sphinx-4.2.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx_rtd_theme-1.0.0[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/coveralls-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-3.9.2[${PYTHON_USEDEP}]
		>=dev-python/pillow-8.3.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-6.2.5[${PYTHON_USEDEP}]
		>=dev-python/pytest-cache-1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-3.0.0[${PYTHON_USEDEP}]
		<dev-python/pytest-mock-3.6.2[${PYTHON_USEDEP}]
		>=dev-python/recommonmark-0.7.1[${PYTHON_USEDEP}]
		>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.9.3[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.62.3[${PYTHON_USEDEP}]
		>=dev-python/websocket-client-1.2.1[${PYTHON_USEDEP}]
	)"
SRC_URI="
https://github.com/pkkid/python-plexapi/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
