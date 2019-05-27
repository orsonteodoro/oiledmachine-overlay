# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

KEYWORDS="~amd64"

DESCRIPTION="Rocm cmake modules"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm-cmake"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
COMMIT="cfd021c1c5cfb07979904b23f54152d8a410acb1"
SRC_URI="https://github.com/RadeonOpenCompute/rocm-cmake/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"
S="${WORKDIR}/${PN}-${COMMIT}"

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	#sed -e "s:get_version ( \"1.0.0\" ):get_version ( \"${PV}\" ):" -i CMakeLists.txt || die
	cmake-utils_src_prepare
}
