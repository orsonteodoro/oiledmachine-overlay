# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils flag-o-matic toolchain-funcs

DESCRIPTION="nanodbc"
HOMEPAGE="https://lexicalunit.github.io/nanodbc/"
SRC_URI="https://github.com/lexicalunit/${PN}/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="-unicode -boost_convert -static +examples +libcxx -handle_nodata_bug +debug"
REQUIRED_USE=""

RDEPEND="dev-libs/boost[nls]
	 dev-db/unixODBC
	 libcxx? ( sys-libs/libcxx )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
"

S="${WORKDIR}/nanodbc-${PV}"

pkg_setup() {
	if [[ "$(tc-getCC)" == "clang" || "$(tc-getCXX)" == "clang++" ]]; then
		if ! use libcxx; then
			die "Clang requires libcxx for this ebuild."
		fi
	fi
}

src_prepare() {
	if ! use static; then
		sed -i -e 's|Boost_USE_STATIC_LIBS ON)|Boost_USE_STATIC_LIBS OFF)|' CMakeLists.txt || die p2
		sed -i -e 's|Boost_USE_STATIC_LIBS ON)|Boost_USE_STATIC_LIBS OFF)|' test/CMakeLists.txt || die p3
	fi
	#sed -i -e 's|check_cxx_compiler_flag("-stdlib=libc++" CXX_SUPPORTS_STDLIB)|set(CXX_SUPPORTS_STDLIB ON)|' CMakeLists.txt || die p4
	epatch "${FILESDIR}"/nanodbc-2.11.3-boost-test.patch || die p6
	cmake-utils_src_prepare
}

src_configure() {
	if use libcxx; then
		append-cxxflags -Qunused-arguments -I/usr/include/c++/v1 -DBOOST_TEST_DYN_LINK
		append-ldflags -L/usr/$(get_libdir) -lc++
	fi
        local mycmakeargs=(
                $(cmake-utils_use unicode NANODBC_USE_UNICODE)
                $(cmake-utils_use boost_convert NANODBC_USE_BOOST_CONVERT)
                $(cmake-utils_use static NANODBC_STATIC)
                $(cmake-utils_use examples NANODBC_EXAMPLES)
                $(cmake-utils_use libcxx NANODBC_ENABLE_LIBCXX)
                $(cmake-utils_use handle_nodata_bug NANODBC_HANDLE_NODATA_BUG)
                $(cmake-utils_use debug TEST)
		-NANODBC_INSTALL=ON
		-DBOOST_LIBRARYDIR="/usr/$(get_libdir)"
		-DBoost_INCLUDE_DIRS="/usr/include"
		-DBoost_LIBRARY_DIRS="/usr/$(get_libdir)"
		-DBoost_ADDITIONAL_VERSIONS="1.56.0"
        )

	cmake-utils_src_configure
}

src_compile() {
	MAKEOPTS="-j1"
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
