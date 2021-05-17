# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils flag-o-matic multilib-build static-libs toolchain-funcs

DESCRIPTION="A small C++ wrapper for the native C ODBC API"
HOMEPAGE="https://nanodbc.github.io/nanodbc/"
LICENSE="MIT"

# Live ebuilds/snapshots won't get KEYWORed.

SLOT="0/${PV}"
IUSE+=" -boost_convert +debug doc +examples -handle_nodata_bug +libcxx -unicode -static-libs"
REQUIRED_USE+=" !libcxx"
#building with USE libcxx is broken?
DEPEND+=" dev-libs/boost:=[${MULTILIB_USEDEP},nls,static-libs?]
	 dev-db/unixODBC[${MULTILIB_USEDEP}]
	 libcxx? ( sys-libs/libcxx[${MULTILIB_USEDEP}] )"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-2.6
	doc? (
		dev-python/rstcheck
		dev-python/sphinx
		dev-python/sphinx_rtd_theme
		<=dev-python/breathe-4.29.0
	)"
EGIT_COMMIT="1a303f1028baf973d92bec037f92a2516d7060a9"
SRC_URI=\
"https://github.com/nanodbc/${PN}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/nanodbc-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	if [[ "$(tc-getCC)" == "clang" || "$(tc-getCXX)" == "clang++" ]]; then
		if ! use libcxx; then
			die "Clang requires libcxx for this ebuild."
		fi
	fi
}

src_prepare() {
	default
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_prepare() {
			cd "${BUILD_DIR}" || die
			sed -i -e "s|DESTINATION lib|DESTINATION \${CMAKE_INSTALL_LIBDIR}|" CMakeLists.txt || die
			sed -i -e "s|lib/cmake/nanodbc|\${CMAKE_INSTALL_LIBDIR}/cmake/nanodbc|" CMakeLists.txt || die
			#sed -i -e 's|check_cxx_compiler_flag("-stdlib=libc++" CXX_SUPPORTS_STDLIB)|set(CXX_SUPPORTS_STDLIB ON)|' \
			# CMakeLists.txt || die
			#eapply "${FILESDIR}"/nanodbc-2.11.3-boost-test.patch || die p6
			eapply "${FILESDIR}"/nanodbc-2.13.0-disable-tests.patch || die p7
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_prepare
		}
		static-libs_copy_sources
		static-libs_foreach_impl \
			static-libs_prepare
	}
	multilib_copy_sources
	multilib_foreach_abi prepare_abi

	multilib_copy_sources
}

src_configure() {
	configure_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_configure() {
			cd "${BUILD_DIR}" || die

			if [[ "${ESTSH_LIB_TYPE}" == "shared-libs" ]] ; then
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
				-DCMAKE_INSTALL_LIBDIR="${EPREFIX}"/usr/$(get_libdir)
		                -DNANODBC_DISABLE_LIBCXX=$(usex libcxx "OFF" "ON")
		                -DNANODBC_DISABLE_EXAMPLES=$(usex examples "OFF" "ON")
		                -DNANODBC_ENABLE_WORKAROUND_NODATA=$(usex handle_nodata_bug)
		                -DNANODBC_ENABLE_BOOST=$(usex boost_convert)
		                -DNANODBC_ENABLE_UNICODE=$(usex unicode)
				-DUNIX=1
		        )
			if [[ "${ESTSH_LIB_TYPE}" == "shared-libs" ]] ; then
				mycmakeargs=( -DBUILD_SHARED_LIBS=ON )
			else
				mycmakeargs=( -DBUILD_SHARED_LIBS=OFF )
			fi
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_configure
		}
		static-libs_foreach_impl \
			static-libs_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	if use doc ; then
		einfo "Building html documentation"
		cd "${S}/doc" || die
		emake html
	fi

	compile_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_compile() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_compile
		}
		static-libs_foreach_impl \
			static-libs_compile
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	install_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_install() {
			pushd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_install
		}
		static-libs_foreach_impl \
			static-libs_install
	}
	multilib_foreach_abi install_abi
}
