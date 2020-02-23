# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Box2D is a 2D physics engine for games"
HOMEPAGE="http://box2d.org/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="ebb7c5e24ab289c394dffe5d56e3a4025c72c0fc"
SLOT="0/${PV}"
IUSE="debug doc examples test"
inherit multilib-build
# todo remove internal dependencies
RDEPEND="media-libs/glew[${MULTILIB_USEDEP}]
	 media-libs/glfw[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"
inherit box2d eutils cmake-utils
SRC_URI=\
"https://github.com/erincatto/Box2D/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/box2d-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default
	export CMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		box2d_prepare_static_shared() {
			cd "${BUILD_DIR}" || die
			if [[ "${EBOX2D}" == "shared" ]] ; then
				sed -i -e "s|STATIC|SHARED|" src/CMakeLists.txt || die
				sed -i -e "s|STATIC|SHARED|" extern/glad/CMakeLists.txt || die
				sed -i -e "s|STATIC|SHARED|" extern/imgui/CMakeLists.txt || die
			fi
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_prepare
		}
		box2d_copy_sources
		box2d_foreach_impl box2d_prepare_static_shared
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
		box2d_configure_static_shared() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_configure
		}
		box2d_foreach_impl box2d_configure_static_shared
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		box2d_compile_static_shared() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_compile
		}
		box2d_foreach_impl box2d_compile_static_shared
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_abi() {
		cd "${BUILD_DIR}" || die
		box2d_install_static_shared() {
			pushd "${BUILD_DIR}" || die
			if [[ "${EBOX2D}" == "shared" ]] ; then
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
		box2d_foreach_impl box2d_install_static_shared
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
