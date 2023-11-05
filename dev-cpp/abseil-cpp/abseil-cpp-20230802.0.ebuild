# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit cmake-multilib python-any-r1

SRC_URI="
https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
LICENSE="
	Apache-2.0
	test? (
		BSD
	)
"
HOMEPAGE="https://abseil.io"
KEYWORDS="~amd64 ~ppc64 ~x86"
SLOT="0/${PV%%.*}"
IUSE+=" +cxx17 test -test-helpers r2"
BDEPEND+="
	${PYTHON_DEPS}
	test? (
		=dev-cpp/gtest-9999
		sys-libs/timezone-data
	)
"
RESTRICT="
	!test? (
		test
	)
	mirror
"
PATCHES=(
)

src_prepare() {
	cmake_src_prepare
	# Un-hardcode abseil compiler flags
	sed -i \
		-e '/"-maes",/d' \
		-e '/"-msse4.1",/d' \
		-e '/"-mfpu=neon"/d' \
		-e '/"-march=armv8-a+crypto"/d' \
		absl/copts/copts.py || die
	# Now generate cmake files
	python_fix_shebang absl/copts/generate_copts.py
	absl/copts/generate_copts.py || die
}

src_configure() {
	local mycmakeargs=(
		-DABSL_BUILD_TESTING=$(usex test ON OFF)
		-DABSL_BUILD_TEST_HELPERS=$(usex test-helpers ON OFF)
		-DABSL_ENABLE_INSTALL=TRUE
		-DABSL_PROPAGATE_CXX_STD=TRUE
		-DABSL_USE_EXTERNAL_GOOGLETEST=TRUE
		$(usex cxx17 -DCMAKE_CXX_STANDARD=17 '')
		$(usex test -DBUILD_TESTING=ON '')
	)
	cmake-multilib_src_configure
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED x86 and amd64
# USE="cxx17 test test-helpers -r1" ABI_X86="32 (64) (-x32)"

# x86 ABI:
# 100% tests passed, 0 tests failed out of 207
# Total Test time (real) = 267.15 sec

# amd64 ABI:
# 100% tests passed, 0 tests failed out of 207
# Total Test time (real) = 204.20 sec
