# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

DESCRIPTION="An API conversion tool for popular external reinforcement \
learning environments"
HOMEPAGE="
https://github.com/Farama-Foundation/Shimmy
"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" atari dm-control dm-control-multi-agent doc gym openspiel test"
PETTINGZOO_PV="1.23"
DEPEND+="
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
	>=dev-python/gymnasium-0.27.0[${PYTHON_USEDEP}]
	atari? (
		>=dev-python/ale-py-0.8.1[${PYTHON_USEDEP}]
	)
	gym? (
		>=dev-python/gym-0.26.2[${PYTHON_USEDEP}]
	)
	dm-control? (
		>=dev-python/dm-control-1.0.10[${PYTHON_USEDEP}]
		>=dev-python/h5py-3.7.0[${PYTHON_USEDEP}]
		dev-python/imageio[${PYTHON_USEDEP}]
	)
	dm-control-multi-agent? (
		>=dev-python/dm-control-1.0.10[${PYTHON_USEDEP}]
		>=dev-python/h5py-3.7.0[${PYTHON_USEDEP}]
		>=dev-python/pettingzoo-${PETTINGZOO_PV}[${PYTHON_USEDEP}]
		dev-python/imageio[${PYTHON_USEDEP}]
	)
	openspiel? (
		>=dev-python/open_spiel-1.2[${PYTHON_USEDEP}]
		>=dev-python/pettingzoo-${PETTINGZOO_PV}[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
# TODO:  package
# sphinx-autobuild
# sphinx_github_changelog

BDEPEND+="
	doc? (
		>=dev-python/pygame-2.3.0[${PYTHON_USEDEP}]
		dev-python/celshast[${PYTHON_USEDEP}]
		dev-python/myst-parser[${PYTHON_USEDEP}]
		dev-python/moviepy[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-autobuild[${PYTHON_USEDEP}]
		dev-python/sphinx_github_changelog[${PYTHON_USEDEP}]
		dev-python/sphinxext-opengraph[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/autorom-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/pillow-9.3.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.1.3[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/Farama-Foundation/Shimmy/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
