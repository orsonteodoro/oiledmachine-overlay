# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )
VIRTUALX_REQUIRED="test"
inherit distutils-r1 virtualx

SRC_URI="
https://github.com/Farama-Foundation/PettingZoo/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A standard API for multi-agent reinforcement learning \
environments, with popular reference environments and related utilities"
HOMEPAGE="
https://pettingzoo.farama.org/
"
LICENSE="
	MIT
	Apache-2.0
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" atari butterfly classic doc mpe other sisl test"
PYGAME_PV="2.3.0"
PYMUNK_PV="6.2.0"
DEPEND+="
	>=dev-python/numpy-1.21.0[${PYTHON_USEDEP}]
	>=dev-python/gymnasium-0.28.0[${PYTHON_USEDEP}]
	atari? (
		!=dev-python/multi-agent-ale-py-0.6*
		>=dev-python/multi-agent-ale-py-0.1.11[${PYTHON_USEDEP}]
		>=dev-python/pygame-${PYGAME_PV}[${PYTHON_USEDEP}]
	)
	butterfly? (
		>=dev-python/pygame-${PYGAME_PV}[${PYTHON_USEDEP}]
		>=dev-python/pymunk-${PYMUNK_PV}[${PYTHON_USEDEP}]
	)
	classic? (
		>=dev-python/python-chess-1.9.4[${PYTHON_USEDEP}]
		>=dev-python/pygame-${PYGAME_PV}[${PYTHON_USEDEP}]
		>=dev-python/rlcard-1.0.5[${PYTHON_USEDEP}]
		>=dev-python/shimmy-1.2.0[${PYTHON_USEDEP},openspiel]
	)
	mpe? (
		>=dev-python/pygame-${PYGAME_PV}[${PYTHON_USEDEP}]
	)
	sisl? (
		>=dev-python/pygame-${PYGAME_PV}[${PYTHON_USEDEP}]
		>=dev-python/pymunk-${PYMUNK_PV}[${PYTHON_USEDEP}]
		>=dev-python/box2d-py-2.3.5[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
	)
	other? (
		>=dev-python/pillow-8.0.1[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-61.0.0
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-autobuild[${PYTHON_USEDEP}]
		dev-python/myst-parser[${PYTHON_USEDEP}]
		dev-python/celshast[${PYTHON_USEDEP},furo]
		dev-python/sphinx-github-changelog[${PYTHON_USEDEP}]
	)
	test? (
		$(python_gen_any_dep '
			dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]
		')
		dev-python/autorom[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/pynput[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"
# TODO ebuild-package needs to be created:
# celshast
S="${WORKDIR}/${P}"
RESTRICT="mirror"

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

python_test() {
	virtx pytest -v --cov=pettingzoo --cov-report term
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
