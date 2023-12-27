# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Importer library to import assets from 3D files"
HOMEPAGE="https://github.com/assimp/assimp"
THIRD_PARTY_LICENSES="
	Apache-2.0
	BSD
	Boost-1.0
	JSON
	LGPL-3
	MIT
	Unlicense
	ZLIB
"
LICENSE="
	${THIRD_PARTY_LICENSES}
	BSD
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="samples static-libs test"
RDEPEND="
	dev-libs/boost:=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP},minizip]
	samples? (
		media-libs/freeglut[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.14
	test? (
		dev-cpp/gtest
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.2.2-disable-failing-tests.patch"
	"${FILESDIR}/${PN}-5.3.1-fix-version.patch"
)
DOCS=( CodeConventions.md Readme.md )

src_prepare() {
	if use x86 ; then
		eapply "${FILESDIR}/${PN}-5.2.4-drop-failing-tests-for-abi_x86_32.patch"
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DASSIMP_ASAN=OFF
		-DASSIMP_BUILD_ASSIMP_TOOLS=ON
		-DASSIMP_BUILD_DOCS=OFF
		-DASSIMP_BUILD_SAMPLES=$(usex samples)
		-DASSIMP_BUILD_STATIC_LIB=$(usex static-libs)
		-DASSIMP_BUILD_TESTS=$(usex test)
		-DASSIMP_BUILD_ZLIB=OFF
		-DASSIMP_DOUBLE_PRECISION=OFF
		-DASSIMP_INJECT_DEBUG_POSTFIX=OFF
		-DASSIMP_IGNORE_GIT_HASH=ON
		-DASSIMP_UBSAN=OFF
		-DASSIMP_WARNINGS_AS_ERRORS=OFF
	)
	if use samples; then
		mycmakeargs+=( -DOpenGL_GL_PREFERENCE="GLVND" )
	fi
	cmake-multilib_src_configure
}

src_test() {
	"${BUILD_DIR}/bin/unit" || die
}
