# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit cmake flag-o-matic multilib-build python-any-r1 toolchain-funcs

SRC_URI="
https://github.com/nanodbc/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

DESCRIPTION="A small C++ wrapper for the native C ODBC API"
HOMEPAGE="https://nanodbc.github.io/nanodbc/"
LICENSE="MIT"

# Live ebuilds/snapshots won't get KEYWORed.

RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
-boost doxygen +debug html +examples -handle_nodata_bug +libcxx man pdf -unicode
-static-libs singlehtml texinfo
"
REQUIRED_USE+=" !libcxx" # static-libs not supported unless boost has static-libs support
#building with USE libcxx is broken?
RDEPEND+="
	dev-libs/boost:=[${MULTILIB_USEDEP},nls]
	dev-db/unixODBC[${MULTILIB_USEDEP}]
	libcxx? (
		sys-libs/libcxx[${MULTILIB_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
DEPEND_SPHINX="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		<dev-python/breathe-4.29.1[${PYTHON_USEDEP}]
		dev-python/rstcheck[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	')
"
BDEPEND+="
	>=dev-util/cmake-2.6
	doxygen? (
		app-doc/doxygen
	)
	html? (
		${DEPEND_SPHINX}
	)
	man? (
		${DEPEND_SPHINX}
	)
	pdf? (
		${DEPEND_SPHINX}
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP},latex]
		')
		dev-tex/latexmk
	)
	singlehtml? (
		${DEPEND_SPHINX}
	)
	texinfo? (
		${DEPEND_SPHINX}
	)
"

pkg_setup() {
	if [[ "$(tc-getCC)" == "clang" || "$(tc-getCXX)" == "clang++" ]]; then
		if ! use libcxx; then
			die "Clang requires libcxx for this ebuild."
		fi
	fi
	if use texinfo ; then
ewarn
ewarn "The texinfo USE flags may need FEATURES=\"\${FEATURES} -network-sandbox\""
ewarn "as a per-package environmental setting for doc generation completeness."
ewarn
	fi
	if use pdf ; then
ewarn
ewarn "The pdf USE flags may need FEATURES=\"\${FEATURES} -network-sandbox\" as"
ewarn "a per-package environmental setting for doc generation completeness."
ewarn
	fi
	if use html || use man || use pdf || use singlehtml || use texinfo ; then
		python-any-r1_pkg_setup
	fi
}
PATCHES=(
	#"${FILESDIR}/nanodbc-2.11.3-boost-test.patch"
	"${FILESDIR}/nanodbc-2.13.0-disable-tests.patch"
	"${FILESDIR}/nanodbc-2.14.0-odbc_config-chost-prefix.patch"
)

src_prepare() {
	cd "${BUILD_DIR}" || die
	sed -i -e "s|DESTINATION lib|DESTINATION \${CMAKE_INSTALL_LIBDIR}|" \
		CMakeLists.txt || die
	sed -i -e "s|lib/cmake/nanodbc|\${CMAKE_INSTALL_LIBDIR}/cmake/nanodbc|" \
		CMakeLists.txt || die
	cmake_src_prepare
	#sed -i -e 's|check_cxx_compiler_flag("-stdlib=libc++" CXX_SUPPORTS_STDLIB)|set(CXX_SUPPORTS_STDLIB ON)|' \
	#	CMakeLists.txt || die
	sed -i -e "s|Boost_USE_STATIC_LIBS ON|Boost_USE_STATIC_LIBS OFF|g" \
		CMakeLists.txt || die

	prepare_abi() {
		cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}" || die
	}
	multilib_foreach_abi prepare_abi
}

get_lib_types() {
	use static-libs && echo "static"
	echo "shared"
}

src_configure() {
	configure_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${CMAKE_USE_DIR}" || die
			[[ "${lib_type}" == "shared" ]] && append-cxxflags -fPIC
			if use libcxx; then
				append-cxxflags \
					-I"${EPREFIX}/usr/include/c++/v1" \
					-DBOOST_TEST_DYN_LINK
				if [[ "$(tc-getCXX)" == "clang++" ]]; then
					append-cxxflags -Qunused-arguments
				fi
				append-ldflags -L"${EPREFIX}/usr/$(get_libdir)" -lc++
			fi
		        local mycmakeargs=(
				-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
				-DCMAKE_SYSTEM_LIBRARY_PATH="${EPREFIX}/usr/$(get_libdir)"
		                -DNANODBC_DISABLE_LIBCXX=$(usex libcxx "OFF" "ON")
		                -DNANODBC_DISABLE_EXAMPLES=$(usex examples "OFF" "ON")
		                -DNANODBC_ENABLE_WORKAROUND_NODATA=$(usex handle_nodata_bug)
		                -DNANODBC_ENABLE_BOOST=$(usex boost)
		                -DNANODBC_ENABLE_UNICODE=$(usex unicode)
				-DUNIX=1
		        )
			if [[ "${lib_type}" == "shared" ]] ; then
				mycmakeargs+=( -DBUILD_SHARED_LIBS=ON )
			else
				mycmakeargs+=( -DBUILD_SHARED_LIBS=OFF )
			fi
			cmake_src_configure
		done
	}
	multilib_foreach_abi configure_abi
}

src_compile_docs() {
	cd "${CMAKE_USE_DIR}" || die
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
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_compile
			multilib_is_native_abi && src_compile_docs
		done
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
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_install
			multilib_is_native_abi && src_install_docs
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
}

# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib-support, static-libs
# OILEDMACHINE-OVERLAY-META-WIP: boost-without-static
