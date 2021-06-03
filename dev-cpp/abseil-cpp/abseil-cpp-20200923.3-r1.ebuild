# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-multilib python-any-r1

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
LICENSE="Apache-2.0
	 test? ( BSD )"
HOMEPAGE="https://abseil.io"
KEYWORDS="~amd64 ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" cxx17 test"
BDEPEND+=" ${PYTHON_DEPS}
	   test? ( sys-libs/timezone-data )"
# yes, it needs SOURCE, not just installed one
# Uses master, see
# https://github.com/abseil/abseil-cpp/blob/20200923.3/CMake/Googletest/CMakeLists.txt.in
GTEST_COMMIT="f31c82efe6598aef4c3a82fb4b35f1f84a3b81a1" # Up to tag date version
GTEST_FILE="gtest-1.10.0_p20210116.tar.gz"
SRC_URI="
https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/google/googletest/archive/${GTEST_COMMIT}.tar.gz
	-> ${GTEST_FILE}"
RESTRICT="!test? ( test ) mirror"

src_prepare() {
	cmake-utils_src_prepare
	# un-hardcode abseil compiler flags
	sed -i \
		-e '/"-maes",/d' \
		-e '/"-msse4.1",/d' \
		-e '/"-mfpu=neon"/d' \
		-e '/"-march=armv8-a+crypto"/d' \
		absl/copts/copts.py || die
	# now generate cmake files
	absl/copts/generate_copts.py || die
	sed -i 's/-Werror//g' \
"${WORKDIR}/googletest-${GTEST_COMMIT}"/googletest/cmake/internal_utils.cmake \
		|| die
	multilib_copy_sources
}

src_configure() {
	local mycmakeargs=(
		-DABSL_ENABLE_INSTALL=TRUE
		-DABSL_LOCAL_GOOGLETEST_DIR="${WORKDIR}/googletest-${GTEST_COMMIT}"
		-DABSL_RUN_TESTS=$(usex test)
		$(usex cxx17 -DCMAKE_CXX_STANDARD=17 '') # it has to be a useflag for some consumers
		$(usex test -DBUILD_TESTING=ON '') #intentional usex
	)
	cmake-multilib_src_configure
}
