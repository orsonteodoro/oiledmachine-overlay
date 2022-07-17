# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-multilib python-any-r1

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
LICENSE="
	Apache-2.0
	test? ( BSD )
"
HOMEPAGE="https://abseil.io"
KEYWORDS="~amd64 ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" cxx17 test"
BDEPEND+="
	${PYTHON_DEPS}
	test? ( sys-libs/timezone-data )
"
# It uses the master branch source code, see
# https://github.com/abseil/abseil-cpp/blob/20211102.0/CMake/Googletest/CMakeLists.txt.in
GTEST_COMMIT="1b18723e874b256c1e39378c6774a90701d70f7a" #
GTEST_FILE="gtest-1.11.0_p20211112-${GTEST_COMMIT:0:7}.tar.gz"
SRC_URI="
https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/google/googletest/archive/${GTEST_COMMIT}.tar.gz
	-> ${GTEST_FILE}
"
RESTRICT="!test? ( test ) mirror"

src_prepare() {
	cmake-utils_src_prepare
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
	if use test ; then
		sed -i 's/-Werror//g' \
"${WORKDIR}/googletest-${GTEST_COMMIT}/googletest/cmake/internal_utils.cmake" \
			|| die
	fi
	multilib_copy_sources
}

src_configure() {
	local mycmakeargs=(
		-DABSL_ENABLE_INSTALL=TRUE
		-DABSL_LOCAL_GOOGLETEST_DIR="${WORKDIR}/googletest-${GTEST_COMMIT}"
		-DABSL_PROPAGATE_CXX_STD=TRUE
		$(usex cxx17 -DCMAKE_CXX_STANDARD=17 '')
		$(usex test -DBUILD_TESTING=ON '')
	)
	cmake-multilib_src_configure
}
