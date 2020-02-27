# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Compiler infrastructure and toolchain library for WebAssembly"
HOMEPAGE="https://github.com/WebAssembly/binaryen"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1 ${PV})"
RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
CMAKE_MIN_VERSION="2.8.7"
CMAKE_BUILD_TYPE="Release"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit cmake-utils python-any-r1
EGIT_COMMIT="b17e84b491a309c9f15e7a502f115ece19404b11"
SRC_URI="\
https://github.com/WebAssembly/binaryen/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	sed -r -i \
		-e '/INSTALL.+src\/binaryen-c\.h/d' \
		CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIB=OFF
		-DENABLE_WERROR=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	insinto "/usr/include/${PN}"
	doins "${S}/src/"*.h
	for hdir in asmjs emscripten-optimizer ir support; do
		insinto "/usr/include/${PN}/${hdir}"
		doins "${S}/src/${hdir}/"*.h
	done
}
