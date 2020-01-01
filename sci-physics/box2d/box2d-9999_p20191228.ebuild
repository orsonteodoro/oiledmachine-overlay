# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Box2D is a 2D physics engine for games"
HOMEPAGE="http://box2d.org/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="37e2dc25f8da158abda10324d75cb4d1db009adf"
SLOT="0/${PV}"
IUSE="debug doc examples static"
CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake-multilib
# todo remove internal dependencies
RDEPEND="media-libs/glew[${MULTILIB_USEDEP}]
	 media-libs/glfw[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"
inherit eutils
SRC_URI=\
"https://github.com/erincatto/Box2D/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/box2d-${EGIT_COMMIT}"

src_prepare() {
	default
	if ! use static ; then
		sed -i -e "s|STATIC|SHARED|" src/CMakeLists.txt || die
		sed -i -e "s|STATIC|SHARED|" extern/glad/CMakeLists.txt || die
		sed -i -e "s|STATIC|SHARED|" extern/imgui/CMakeLists.txt || die
	fi
	export CMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
	cmake-utils_src_prepare
	multilib_copy_sources
}

src_configure() {
	configure_abi() {
		local mycmakeargs=(
			-DBUILD_TESTS=$(usex tests)
			-DBUILD_SAMPLES=$(usex examples)
		)
		cmake-utils_src_compile
	}
	multilib_foreach_abi configure_abi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_abi() {
		pushd "${BUILD_DIR}" || die
		if use static; then
			dolib.a src/libbox2d.a extern/glad/libglad.a extern/imgui/libimgui.a
		else
			dolib.so src/libbox2d.so extern/glad/libglad.so extern/imgui/libimgui.so
		fi
		popd
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
