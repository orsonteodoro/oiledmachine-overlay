# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# bsuite
# dm-meltingpot
# sphinx-autobuild
# sphinx_github_changelog

DISTUTILS_USE_PEP517="setuptools"
PETTINGZOO_PV="1.23"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
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
IUSE+=" bsuite dm-control dm-control-multi-agent doc gym meltingpot openspiel test"
RDEPEND+="
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
	>=sci-libs/gymnasium-1.0.0_alpha1[${PYTHON_USEDEP}]
	bsuite? (
		>=dev-python/bsuite-0.3.5[${PYTHON_USEDEP}]
	)
	gym? (
		>=sci-libs/gym-0.26.2[${PYTHON_USEDEP}]
	)
	meltingpot? (
		>=sci-libs/pettingzoo-${PETTINGZOO_PV}[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/dm-meltingpot-2.2.2[${PYTHON_USEDEP}]
		' python3_11)
	)
	dm-control? (
		>=dev-python/h5py-3.7.0[${PYTHON_USEDEP}]
		>=sci-libs/dm_control-1.0.10[${PYTHON_USEDEP}]
		dev-python/imageio[${PYTHON_USEDEP}]
	)
	dm-control-multi-agent? (
		>=dev-python/h5py-3.7.0[${PYTHON_USEDEP}]
		>=sci-libs/dm_control-1.0.10[${PYTHON_USEDEP}]
		>=sci-libs/pettingzoo-${PETTINGZOO_PV}[${PYTHON_USEDEP}]
		dev-python/imageio[${PYTHON_USEDEP}]
	)
	openspiel? (
		>=dev-python/open_spiel-1.2[${PYTHON_USEDEP}]
		>=sci-libs/pettingzoo-${PETTINGZOO_PV}[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"

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
		>=dev-python/pillow-9.3.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.1.3[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
