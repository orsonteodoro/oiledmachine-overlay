# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils cmake-utils flag-o-matic toolchain-funcs

DESCRIPTION="nanodbc"
HOMEPAGE="https://lexicalunit.github.io/nanodbc/"
SRC_URI="https://github.com/lexicalunit/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="-unicode -boost_convert -static -static-libs +examples +libcxx -handle_nodata_bug +debug"
REQUIRED_USE="static? ( static-libs )"

RDEPEND="dev-libs/boost[nls,static-libs?]
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
        if use debug; then
                if [[ ! ( ${FEATURES} =~ "nostrip" ) ]]; then
        	        die Emerge again with FEATURES="nostrip" or remove the debug use flag
	        fi
        fi

	if ! use static; then
		sed -i -e 's|Boost_USE_STATIC_LIBS ON)|Boost_USE_STATIC_LIBS OFF)|' CMakeLists.txt || die p2
		sed -i -e 's|Boost_USE_STATIC_LIBS ON)|Boost_USE_STATIC_LIBS OFF)|' test/CMakeLists.txt || die p3
	fi
	#sed -i -e 's|check_cxx_compiler_flag("-stdlib=libc++" CXX_SUPPORTS_STDLIB)|set(CXX_SUPPORTS_STDLIB ON)|' CMakeLists.txt || die p4
	eapply "${FILESDIR}"/nanodbc-2.11.3-boost-test.patch || die p6
	eapply "${FILESDIR}"/nanodbc-2.12.4-disable-tests.patch || die p7

	eapply_user

	cmake-utils_src_prepare
}

src_configure() {
	filter-flags -Os -O1 -O3
	append-cxxflags -O2 $(odbc_config --cflags)
	if use debug ; then
		filter-flags -O2
		append-cxxflags -O0 -g
	fi
	if use static; then
		append-cxxflags -fPIC
	fi
	if use libcxx; then
		append-cxxflags -I/usr/include/c++/v1 -DBOOST_TEST_DYN_LINK
		if [[ "$(tc-getCXX)" == "clang++" ]]; then
			append-cxxflags -Qunused-arguments
		fi
		append-ldflags -L/usr/$(get_libdir) -lc++
	fi
        local mycmakeargs=(
                -DNANODBC_USE_UNICODE=$(usex unicode)
                -DNANODBC_USE_BOOST_CONVERT=$(usex boost_convert)
                -DNANODBC_STATIC=$(usex static)
                -DNANODBC_EXAMPLES=$(usex examples)
                -DNANODBC_ENABLE_LIBCXX=$(usex libcxx)
                -DNANODBC_HANDLE_NODATA_BUG=$(usex handle_nodata_bug)
                -DTEST=$(usex debug)
		-DUNIX=1
		-NANODBC_INSTALL=ON
		-DBOOST_LIBRARYDIR="/usr/$(get_libdir)"
		-DBoost_INCLUDE_DIRS="/usr/include"
		-DBoost_LIBRARY_DIRS="/usr/$(get_libdir)"
		-DBoost_ADDITIONAL_VERSIONS="1.56.0"
        )
#		-DBoost_LIBRARIES=\"boost_unit_test_framework boost_locale\"

	cmake-utils_src_configure
}

src_compile() {
	MAKEOPTS="-j1"
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
