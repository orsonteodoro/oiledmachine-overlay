# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Box2D is a 2D physics engine for games"
HOMEPAGE="http://box2d.org/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE="debug doc examples test"
inherit multilib-build
# todo remove internal dependencies
RDEPEND="media-libs/glew[${MULTILIB_USEDEP}]
	 media-libs/glfw[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"
inherit cmake-static-libs eutils cmake-utils
SRC_URI=\
"https://github.com/erincatto/Box2D/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/box2d-${PV}"
RESTRICT="mirror"

src_prepare() {
	default
	export CMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_prepare() {
			cd "${BUILD_DIR}" || die
			if [[ "${ECMAKE_LIB_TYPE}" == "shared-libs" ]] ; then
				sed -i -e "s|STATIC|SHARED|" src/CMakeLists.txt || die
				sed -i -e "s|STATIC|SHARED|" extern/glad/CMakeLists.txt || die
				sed -i -e "s|STATIC|SHARED|" extern/imgui/CMakeLists.txt || die
			fi
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_prepare
		}
		cmake-static-libs_copy_sources
		cmake-static-libs_foreach_impl \
			cmake-static-libs_prepare
	}
	multilib_copy_sources
	multilib_foreach_abi prepare_abi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DBUILD_SAMPLES=$(usex examples)
	)
	configure_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_configure() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_configure
		}
		cmake-static-libs_foreach_impl \
			cmake-static-libs_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_compile() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_compile
		}
		cmake-static-libs_foreach_impl \
			cmake-static-libs_compile
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_install() {
			pushd "${BUILD_DIR}" || die
			if [[ "${ECMAKE_LIB_TYPE}" == "shared-libs" ]] ; then
				dolib.so src/libbox2d.so \
					extern/glad/libglad.so \
					extern/imgui/libimgui.so
			else
				dolib.a src/libbox2d.a \
					extern/glad/libglad.a \
					extern/imgui/libimgui.a
			fi
			popd
		}
		cmake-static-libs_foreach_impl \
			cmake-static-libs_install
	}
	multilib_foreach_abi install_abi

	FILES=$(find include -name "*.h")
	for FILE in ${FILES}
	do
		insinto "/usr/include/$(dirname ${FILE})"
		doins "${FILE}"
	done

	cd docs || die
	if use doc; then
		doxygen Doxyfile
		dodoc -r API images manual.docx
	fi
}
