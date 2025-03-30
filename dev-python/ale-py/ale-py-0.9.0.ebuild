# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# TODO package:
# cibuildwheel

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..12} ) # Upstream tests up to 3.12

inherit distutils-r1

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/Arcade-Learning-Environment-${PV}"
SRC_URI="
https://github.com/mgbellemare/Arcade-Learning-Environment/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="The Arcade Learning Environment (ALE) is a platform for AI research"
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
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
	')
	media-libs/libsdl2
	sys-libs/zlib
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/pybind11-2.10.0[${PYTHON_USEDEP}]
		>=dev-python/setuptools-61[${PYTHON_USEDEP}]
		cibuildwheel? (
			dev-python/cibuildwheel[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/pytest-7.0[${PYTHON_USEDEP}]
		)
	')
	>=dev-build/cmake-3.22
	dev-build/ninja
	test? (
		>=dev-python/gymnasium-1.0.0_alpha1[${PYTHON_SINGLE_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.9.0-offline-install.patch"
)


distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
