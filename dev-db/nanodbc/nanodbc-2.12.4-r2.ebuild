# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A small C++ wrapper for the native C ODBC API"
HOMEPAGE="https://nanodbc.github.io/nanodbc/"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="${PV}"
IUSE="-boost_convert +debug +examples -handle_nodata_bug +libcxx -unicode -static-libs"
REQUIRED_USE="!libcxx"
#building with USE libcxx is broken?
inherit multilib-build
RDEPEND="dev-libs/boost:=[${MULTILIB_USEDEP},nls,static-libs?]
	 dev-db/unixODBC[${MULTILIB_USEDEP}]
	 libcxx? ( sys-libs/libcxx[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6"
inherit cmake-multilib eutils flag-o-matic toolchain-funcs
SRC_URI=\
"https://github.com/nanodbc/${PN}/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/nanodbc-${PV}"

pkg_setup() {
	if [[ "$(tc-getCC)" == "clang" || "$(tc-getCXX)" == "clang++" ]]; then
		if ! use libcxx; then
			die "Clang requires libcxx for this ebuild."
		fi
	fi
}

src_prepare() {
	default
	if use debug; then
		if [[ ! ( ${FEATURES} =~ "nostrip" ) ]]; then
			die "Emerge again with FEATURES=\"nostrip\" or remove the debug use flag"
		fi
        fi
	if ! use static-libs; then
		sed -i -e 's|Boost_USE_STATIC_LIBS ON)|Boost_USE_STATIC_LIBS OFF)|' \
			CMakeLists.txt || die
		sed -i -e 's|Boost_USE_STATIC_LIBS ON)|Boost_USE_STATIC_LIBS OFF)|' \
			test/CMakeLists.txt || die
	fi
	sed -i -e "s|DESTINATION lib|DESTINATION \${CMAKE_INSTALL_LIBDIR}|" CMakeLists.txt || die
	#sed -i -e 's|check_cxx_compiler_flag("-stdlib=libc++" CXX_SUPPORTS_STDLIB)|set(CXX_SUPPORTS_STDLIB ON)|' \
	# CMakeLists.txt || die
	eapply "${FILESDIR}"/nanodbc-2.11.3-boost-test.patch || die
	eapply "${FILESDIR}"/nanodbc-2.12.4-disable-tests.patch || die
	cmake-utils_src_prepare
	multilib_copy_sources
}

src_configure() {
	filter-flags -Os -O1 -O3
	append-cxxflags -O2 $(odbc_config --cflags)
	if use debug ; then
		filter-flags -O2
		append-cxxflags -O0 -g
	fi
	if use static-libs; then
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
		-DBOOST_LIBRARYDIR="/usr/$(get_libdir)"
		-DBoost_ADDITIONAL_VERSIONS="1.56.0"
		-DBoost_INCLUDE_DIRS="/usr/include"
		-DBoost_LIBRARY_DIRS="/usr/$(get_libdir)"
                -DNANODBC_ENABLE_LIBCXX=$(usex libcxx)
                -DNANODBC_EXAMPLES=$(usex examples)
                -DNANODBC_HANDLE_NODATA_BUG=$(usex handle_nodata_bug)
                -DNANODBC_USE_BOOST_CONVERT=$(usex boost_convert)
                -DNANODBC_USE_UNICODE=$(usex unicode)
                -DNANODBC_STATIC=$(usex static-libs)
		-DNANODBC_INSTALL=ON
                -DTEST=$(usex debug)
		-DUNIX=1
        )
#		-DBoost_LIBRARIES=\"boost_unit_test_framework boost_locale\"
	cmake-multilib_src_configure
}

src_compile() {
	MAKEOPTS="-j1"
	cmake-multilib_src_compile
}

src_install() {
	cmake-multilib_src_install
}
