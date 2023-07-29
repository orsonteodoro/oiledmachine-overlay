# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} ) # Upstream tests up to 3.11
inherit distutils-r1

DESCRIPTION="The Arcade Learning Environment (ALE) -- a platform for AI research."
HOMEPAGE="
https://github.com/mgbellemare/Arcade-Learning-Environment
"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cibuildwheel test"
DEPEND+="
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' python3_10 )
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
	dev-python/importlib-resources[${PYTHON_USEDEP}]
	media-libs/libsdl2
	sys-libs/zlib
"
RDEPEND+="
	${DEPEND}
"
# TODO:  Package
# cibuildwheel
BDEPEND+="
	>=dev-python/setuptools-61[${PYTHON_USEDEP}]
	>=dev-util/cmake-3.22
	dev-util/ninja
	cibuildwheel? (
		dev-python/cibuildwheel[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/gym-0.23[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.0[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/mgbellemare/Arcade-Learning-Environment/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/Arcade-Learning-Environment-${PV}"
RESTRICT="mirror"

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
