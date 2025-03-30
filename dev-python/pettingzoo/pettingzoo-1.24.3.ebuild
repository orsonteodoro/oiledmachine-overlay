# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# sphinx-github-changelog

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYGAME_PV="2.3.0"
PYMUNK_PV="6.2.0"
PYTHON_COMPAT=( "python3_"{10..11} )
VIRTUALX_REQUIRED="test"

inherit distutils-r1 virtualx

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/Farama-Foundation/PettingZoo/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A standard API for multi-agent reinforcement learning \
environments, with popular reference environments and related utilities"
HOMEPAGE="
	https://pettingzoo.farama.org/
	https://github.com/Farama-Foundation/PettingZoo
"
LICENSE="
	MIT
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" atari butterfly classic doc mpe other sisl test"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.21.0[${PYTHON_USEDEP}]
		atari? (
			>=dev-python/multi-agent-ale-py-0.1.11:0/0.1[${PYTHON_USEDEP}]
			>=dev-python/pygame-'${PYGAME_PV}'[${PYTHON_USEDEP}]
		)
		butterfly? (
			>=dev-python/pygame-'${PYGAME_PV}'[${PYTHON_USEDEP}]
			>=dev-python/pymunk-'${PYMUNK_PV}'[${PYTHON_USEDEP}]
		)
		classic? (
			>=dev-python/pygame-'${PYGAME_PV}'[${PYTHON_USEDEP}]
			>=dev-python/python-chess-1.9.4[${PYTHON_USEDEP}]
		)
		mpe? (
			>=dev-python/pygame-'${PYGAME_PV}'[${PYTHON_USEDEP}]
		)
		sisl? (
			>=dev-python/pygame-'${PYGAME_PV}'[${PYTHON_USEDEP}]
			>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
			>=dev-python/pymunk-'${PYMUNK_PV}'[${PYTHON_USEDEP}]
		)
		other? (
			>=virtual/pillow-8.0.1[${PYTHON_USEDEP}]
		)
	')
	>=dev-python/gymnasium-0.28.0[${PYTHON_SINGLE_USEDEP}]
	classic? (
		>=dev-python/rlcard-1.0.5[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/shimmy-1.2.0[${PYTHON_SINGLE_USEDEP},openspiel]
	)
	sisl? (
		>=dev-python/box2d-py-2.3.5[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-61.0.0[${PYTHON_USEDEP}]
		doc? (
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-autobuild[${PYTHON_USEDEP}]
			dev-python/myst-parser[${PYTHON_USEDEP}]
			dev-python/celshast[${PYTHON_USEDEP},furo]
			dev-python/sphinx-github-changelog[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/pynput-1.7.6[${PYTHON_USEDEP}]
			>=dev-python/pytest-8.0.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-markdown-docs-0.5.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-xdist-3.5.0[${PYTHON_USEDEP}]
			dev-python/black[${PYTHON_USEDEP}]
		)
	')
	test? (
		>=dev-python/autorom-0.6.1[${PYTHON_SINGLE_USEDEP}]
		>=dev-vcs/pre-commit-3.5.0[${PYTHON_SINGLE_USEDEP}]
	)
"

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

python_test() {
	virtx pytest -v --cov=pettingzoo --cov-report term
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
