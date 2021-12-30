# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-utils eutils flag-o-matic multilib-build python-any-r1 \
static-libs toolchain-funcs

DESCRIPTION="A small C++ wrapper for the native C ODBC API"
HOMEPAGE="https://nanodbc.github.io/nanodbc/"
LICENSE="MIT"

# Live ebuilds/snapshots won't get KEYWORed.

SLOT="0/${PV}"
IUSE+=" -boost_convert doxygen +debug html +examples -handle_nodata_bug
+libcxx man pdf -unicode -static-libs singlehtml texinfo"
REQUIRED_USE+=" !libcxx"
#building with USE libcxx is broken?
DEPEND+=" dev-libs/boost:=[${MULTILIB_USEDEP},nls,static-libs?]
	 dev-db/unixODBC[${MULTILIB_USEDEP}]
	 libcxx? ( sys-libs/libcxx[${MULTILIB_USEDEP}] )"
RDEPEND+=" ${DEPEND}"
DEPEND_SPHINX="
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/rstcheck[${PYTHON_USEDEP}]')
	$(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]')
	$(python_gen_any_dep 'dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]')
	$(python_gen_any_dep '<dev-python/breathe-4.29.1[${PYTHON_USEDEP}]')"
BDEPEND+="
	>=dev-util/cmake-2.6
	doxygen? ( app-doc/doxygen )
	html? ( ${DEPEND_SPHINX} )
	man? ( ${DEPEND_SPHINX} )
	pdf? ( ${DEPEND_SPHINX}
		$(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP},latex]')
		dev-tex/latexmk )
	singlehtml? ( ${DEPEND_SPHINX} )
	texinfo? ( ${DEPEND_SPHINX} )"
EGIT_COMMIT="308329c4985eff77e27f1e3428068e28af1e9e06"
SRC_URI="
https://github.com/nanodbc/${PN}/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz"
S="${WORKDIR}/nanodbc-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	if [[ "$(tc-getCC)" == "clang" || "$(tc-getCXX)" == "clang++" ]]; then
		if ! use libcxx; then
			die "Clang requires libcxx for this ebuild."
		fi
	fi
	if use texinfo ; then
ewarn
ewarn "The texinfo USE flags may need FEATURES=\"-network-sandbox\" as a"
ewarn "per-package environmental setting for doc generation completeness."
ewarn
	fi
	if use pdf ; then
ewarn
ewarn "The pdf USE flags may need FEATURES=\"-network-sandbox\" as a"
ewarn "per-package environmental setting for doc generation completeness."
ewarn
	fi
	if use html || use man || use pdf || use singlehtml || use texinfo ; then
		python-any-r1_pkg_setup
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

src_compile_docs() {
	cd doc || die
	if use doxygen ; then
		einfo "Building doxygen documentation"
		mkdir -p ../docs/doxygen
		pushd ../docs/doxygen || die
			doxygen -g doxygen.conf
			sed -i -e "s|My Project|${PN}|g" \
				-e "s|GENERATE_XML           = NO|GENERATE_XML           = YES|g" \
				-e "s|GENERATE_LATEX         = YES|GENERATE_LATEX         = NO|g" \
				-e "s|INPUT                  =|INPUT                  = ${BUILD_DIR}/nanodbc|g" \
				-e "s|JAVADOC_AUTOBRIEF      = NO|JAVADOC_AUTOBRIEF      = YES|g" \
				-e "s|AUTOLINK_SUPPORT       = YES|AUTOLINK_SUPPORT       = NO|g" \
				-e "s|XML_OUTPUT             = xml|XML_OUTPUT             = doxyxml|g" \
				-e "s|MACRO_EXPANSION        = NO|MACRO_EXPANSION        = YES|g" \
				-e "s|PREDEFINED             =|PREDEFINED             = DOXYGEN=1|g" \
				doxygen.conf
		popd
		emake doxygen
	fi

	if use html ; then
		einfo "Building html documentation"
		emake html
	fi

	if use man ; then
		einfo "Building man documentation"
		emake man
	fi

	if use pdf ; then
		einfo "Building pdf documentation"
		emake latexpdf
	fi

	if use singlehtml ; then
		einfo "Building singlehtml documentation"
		emake singlehtml
	fi

	if use texinfo ; then
		einfo "Building texinfo documentation"
		emake texinfo
	fi
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_compile() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_compile

			if multilib_is_native_abi ; then
				src_compile_docs
			fi
		}
		static-libs_foreach_impl \
			static-libs_compile
	}
	multilib_foreach_abi compile_abi
}

src_install_docs()
{
	if use doxygen ; then
		insinto /usr/share/${P}/docs/doxygen
		doins -r html
		doins -r doc/build/breathe/doxygen/nanodbc/xml
	fi

	if use html ; then
		insinto /usr/share/${P}/docs
		doins -r doc/build/html
	fi

	if use man ; then
		doman doc/build/man/nanodbc.1
	fi

	if use pdf ; then
		insinto /usr/share/${P}/docs
		doins -r doc/build/latex/nanodbc.pdf
	fi

	if use singlehtml ; then
		insinto /usr/share/${P}/docs
		doins -r doc/build/singlehtml
	fi

	if use texinfo ; then
		doinfo doc/build/texinfo/nanodbc.texi
	fi
}

src_install() {
	install_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_install() {
			pushd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_install
			if multilib_is_native_abi ; then
				src_install_docs
			fi
		}
		static-libs_foreach_impl \
			static-libs_install
	}
	multilib_foreach_abi install_abi
}
