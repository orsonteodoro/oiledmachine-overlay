# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils cmake-utils multilib-build static-libs

DESCRIPTION="Box2D is a 2D physics engine for games"
HOMEPAGE="http://box2d.org/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE+=" debug doc examples test"
# todo remove internal dependencies
DEPEND+=" examples? ( media-libs/glew[${MULTILIB_USEDEP}]
	media-libs/glfw[${MULTILIB_USEDEP}] )
	virtual/libc"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.8
	doc? ( app-doc/doxygen )"
SRC_URI=\
"https://github.com/erincatto/Box2D/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/box2d-${PV}"
RESTRICT="mirror"
_PATCHES=( "${FILESDIR}/box2d-2.4.0-set-rpath-testbed.patch" )

src_prepare() {
	default
	eapply "${_PATCHES[@]}"

	export CMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_prepare() {
			cd "${BUILD_DIR}" || die
			if [[ "${ESTSH_LIB_TYPE}" == "shared-libs" ]] ; then
				sed -i -e "s|STATIC|SHARED|" src/CMakeLists.txt || die
				sed -i -e "s|STATIC|SHARED|" extern/glad/CMakeLists.txt || die
				sed -i -e "s|STATIC|SHARED|" extern/imgui/CMakeLists.txt || die
			fi
			SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
			cmake-utils_src_prepare
		}
		static-libs_copy_sources
		static-libs_foreach_impl \
			static-libs_prepare
	}
	multilib_copy_sources
	multilib_foreach_abi prepare_abi
}

src_configure() {
	local mycmakeargs=(
		-DBOX2D_BUILD_DOCS=$(usex doc)
		-DBOX2D_BUILD_TESTBED=$(usex examples)
		-DBOX2D_BUILD_UNIT_TESTS=$(usex test)
	)
	if use examples ; then
		mycmakeargs+=(
	-DEXAMPLES_INSTALL_RPATH:PATH="/usr/share/${PN}-${PVR}/testbed"
		)
	fi

	configure_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_configure() {
			cd "${BUILD_DIR}" || die
			SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
			cmake-utils_src_configure
		}
		static-libs_foreach_impl \
			static-libs_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_compile() {
			cd "${BUILD_DIR}" || die
			SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
			cmake-utils_src_compile
		}
		static-libs_foreach_impl \
			static-libs_compile
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_test() {
			SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			BUILD_DIR="${WORKDIR}/${P}${SUFFIX}"
			cd "${BUILD_DIR}" || die

			if [[ -x unit_test ]] ; then
				./unit_test || die
			else
				ewarn "No unit test exist for ABI=${ABI} STSH=${ESTSH_LIB_TYPE}"
			fi
		}
		static-libs_foreach_impl \
			static-libs_test
	}
	multilib_foreach_abi test_abi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_install() {
			SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
			BUILD_DIR="${WORKDIR}/${P}${SUFFIX}"
			einfo "BUILD_DIR=${BUILD_DIR}"
			pushd "${BUILD_DIR}" || die
			if [[ "${ESTSH_LIB_TYPE}" == "shared-libs" ]] ; then
				dolib.so src/libbox2d.so
				if use examples ; then
					insinto "/usr/share/${PN}-${PVR}/testbed"
					exeinto "/usr/share/${PN}-${PVR}/testbed"
					doexe testbed/testbed \
						extern/imgui/libimgui.so \
						extern/glad/libglad.so
				fi
			else
				dolib.a src/libbox2d.a
				if use examples ; then
					insinto "/usr/share/${PN}-${PVR}/testbed"
					exeinto "/usr/share/${PN}-${PVR}/testbed"
					doexe testbed/testbed
				fi
			fi
			popd
		}
		static-libs_foreach_impl \
			static-libs_install
	}
	multilib_foreach_abi install_abi

	FILES=$(find include -name "*.h")
	for FILE in ${FILES}
	do
		insinto "/usr/$(dirname ${FILE})"
		doins "${FILE}"
	done

	cd docs || die
	if use doc; then
		doxygen Doxyfile
		dodoc -r API images manual.docx
	fi
}
