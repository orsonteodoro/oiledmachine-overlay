# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="unittest-cpp"
MY_P="${MY_PN}-${PV}"

inherit cmake-multilib dot-a

SRC_URI="
https://github.com/unittest-cpp/unittest-cpp/archive/v${PV}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A lightweight unit testing framework for C++"
HOMEPAGE="
	https://unittest-cpp.github.io/
	https://github.com/unittest-cpp/unittest-cpp
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
PATCHES=(
	# https://github.com/unittest-cpp/unittest-cpp/commit/2423fcac7668aa9c331a2dcf024c3ca06742942d \
	"${FILESDIR}/${PN}-2.0.0-fix-tests-with-clang.patch"
	"${FILESDIR}/${PN}-2.0.0-cmake-fix-pkgconfig-dir-path-on-FreeBSD.patch"
	"${FILESDIR}/${PN}-2.0.0-Add-support-for-LIB_SUFFIX.patch"
	"${FILESDIR}/${PN}-2.0.0-cmake4.patch"
)

src_prepare() {
	cmake_src_prepare

	# https://github.com/unittest-cpp/unittest-cpp/pull/163
	sed -i '/run unit tests as post build step/,/Running unit tests/d' \
		CMakeLists.txt || die
}

src_configure() {
	lto-guarantee-fat
	local mycmakeargs=(
	# Don't build with -Werror: https://bugs.gentoo.org/747583
		-DUTPP_AMPLIFY_WARNINGS=OFF
		-DUTPP_INCLUDE_TESTS_IN_BUILD=$(usex test)
	)
	cmake-multilib_src_configure
}

src_test() {
	test_abi() {
		"${BUILD_DIR}/TestUnitTest++" || die "Tests failed"
	}
	multilib_foreach_abi test_abi
}

src_install() {
	cmake_src_install
	strip-lto-bytecode
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.0.0-r2 (20230623)
# Both 32-bit and 64-bit tested:
# Success: 267 tests passed.
# Test time: 0.21 seconds.
