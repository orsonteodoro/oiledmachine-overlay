# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# TODO package:
# cibuildwheel

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} ) # Upstream tests up to 3.11

inherit distutils-r1

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
S="${WORKDIR}/Arcade-Learning-Environment-${PV}"
SRC_URI="
https://github.com/mgbellemare/Arcade-Learning-Environment/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="The Arcade Learning Environment (ALE) -- a platform for AI research."
HOMEPAGE="
https://github.com/mgbellemare/Arcade-Learning-Environment
"
LICENSE="GPL-2"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cibuildwheel test"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' python3_10 )
	>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
	dev-python/importlib-resources[${PYTHON_USEDEP}]
	media-libs/libsdl2
	sys-libs/zlib
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-61[${PYTHON_USEDEP}]
	>=dev-build/cmake-3.22
	dev-build/ninja
	dev-python/wheel[${PYTHON_USEDEP}]
	cibuildwheel? (
		dev-python/cibuildwheel[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-7.0[${PYTHON_USEDEP}]
		>=sci-libs/gym-0.23[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
