# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit cmake python-r1

DESCRIPTION="Multi-Joint dynamics with Contact. A general purpose physics \
simulator."
HOMEPAGE="
https://mujoco.org/
https://github.com/deepmind/mujoco
"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" +examples +simulate +test"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
DEPEND+="
	${PYTHON_DEPS}
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/pyglfw[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.16
"
PDEPEND+="
	dev-python/mujoco
"
SRC_URI="
https://github.com/deepmind/mujoco/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

pkg_setup() {
	python_setup
}

src_configure() {
	local mycmakeargs=(
		-DMUJOCO_BUILD_EXAMPLES=$(usex examples "ON" "OFF")
		-DMUJOCO_BUILD_SIMULATE=$(usex simulate "ON" "OFF")
		-DMUJOCO_BUILD_TESTS=$(usex test "ON" "OFF")
		-DMUJOCO_TEST_PYTHON_UTIL=$(usex test "ON" "OFF")
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
