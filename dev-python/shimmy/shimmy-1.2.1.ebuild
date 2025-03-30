# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# sphinx-autobuild
# sphinx_github_changelog

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PETTINGZOO_PV="1.23"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/Farama-Foundation/Shimmy/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="An API conversion tool for popular external reinforcement \
learning environments"
HOMEPAGE="
https://github.com/Farama-Foundation/Shimmy
"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" atari bsuite dm-control dm-control-multi-agent doc gym meltingpot openspiel test"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
		atari? (
			>=dev-python/ale-py-0.8.1[${PYTHON_USEDEP}]
		)
		dm-control? (
			>=dev-python/h5py-3.7.0[${PYTHON_USEDEP}]
			>=dev-python/dm-control-1.0.10[${PYTHON_USEDEP}]
			dev-python/imageio[${PYTHON_USEDEP}]
		)
		dm-control-multi-agent? (
			>=dev-python/h5py-3.7.0[${PYTHON_USEDEP}]
			>=dev-python/dm-control-1.0.10[${PYTHON_USEDEP}]
			dev-python/imageio[${PYTHON_USEDEP}]
		)
	')
	>=dev-python/gymnasium-0.27.0[${PYTHON_SINGLE_USEDEP}]
	bsuite? (
		>=dev-python/bsuite-0.3.5[${PYTHON_SINGLE_USEDEP}]
	)
	dm-control-multi-agent? (
		>=dev-python/pettingzoo-${PETTINGZOO_PV}[${PYTHON_SINGLE_USEDEP}]
	)
	gym? (
		>=dev-python/gym-0.26.2[${PYTHON_SINGLE_USEDEP}]
	)
	meltingpot? (
		>=dev-python/pettingzoo-${PETTINGZOO_PV}[${PYTHON_SINGLE_USEDEP}]
	)
	openspiel? (
		>=dev-python/pettingzoo-${PETTINGZOO_PV}[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/open-spiel-1.2[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		doc? (
			>=dev-python/pygame-2.3.0[${PYTHON_USEDEP}]
			dev-python/celshast[${PYTHON_USEDEP}]
			dev-python/myst-parser[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-autobuild[${PYTHON_USEDEP}]
			dev-python/sphinx_github_changelog[${PYTHON_USEDEP}]
			dev-python/sphinxext-opengraph[${PYTHON_USEDEP}]
		)
		test? (
			>=virtual/pillow-9.3.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-7.1.3[${PYTHON_USEDEP}]
		)
	')
	doc? (
		dev-python/moviepy[${PYTHON_SINGLE_USEDEP}]
	)
	test? (
		>=dev-python/autorom-0.6.0[${PYTHON_SINGLE_USEDEP}]
	)
"

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
