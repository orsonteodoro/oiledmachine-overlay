# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="Importer library to import assets from 3D files"
HOMEPAGE="https://github.com/assimp/assimp"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
doc? ( https://github.com/${PN}/${PN}/releases/download/v${PV}/${PN}-docs-${PV}.pdf )"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="doc samples static-libs test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP},minizip]
	samples? (
		media-libs/freeglut[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.0-disabletest.patch" # bug 659122
	"${FILESDIR}/${PN}-5.0.0-unzip-of.patch"
	"${FILESDIR}/${PN}-5.0.0-findassimp.patch"
	"${FILESDIR}/${P}-GNUInstallDirs.patch" # bug 701912
	"${FILESDIR}/${P}-projectversion.patch"
	"${FILESDIR}/${P}-fix-unittests.patch"
	"${FILESDIR}/${P}-fix-aiGetLegalStringTest.patch"
	"${FILESDIR}/${P}-versiontest.patch"
)

src_prepare() {
	cmake-utils_src_prepare
	multilib_copy_sources
}

src_configure() {
	local mycmakeargs=(
		-DASSIMP_BUILD_STATIC_LIB=$(usex static-libs)
		-DCMAKE_DEBUG_POSTFIX=""
		-DASSIMP_BUILD_SAMPLES=$(usex samples)
		-DASSIMP_BUILD_TESTS=$(usex test)
	)

	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install

	use doc && dodoc "${DISTDIR}"/${PN}-docs-${PV}.pdf

	insinto /usr/share/cmake/Modules
	doins cmake-modules/Findassimp.cmake
}

src_test() {
	"${BUILD_DIR}/test/unit" || die
}
