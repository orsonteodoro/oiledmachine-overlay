# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Box2D is a 2D physics engine for games"
HOMEPAGE="http://box2d.org/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE="debug doc examples"
inherit multilib-minimal
RDEPEND=">=dev-util/premake-4.4
	 <dev-util/premake-5.0
	 media-libs/glew[${MULTILIB_USEDEP}]
	 media-libs/glfw[${MULTILIB_USEDEP}]
	 media-libs/freeglut[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"
inherit cmake-static-libs eutils
SRC_URI=\
"https://github.com/erincatto/Box2D/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/Box2D-${PV}"
RESTRICT="mirror"

_get_abi_settings() {
	if [[ "${ABI}" == "amd64" ]] ; then
		platform="x64"
		arch="-m64"
	elif [[ "${ABI}" == "x86" ]] ; then
		platform="x32"
		arch="-m32"
	else
		die "Platform is not supported.  Contact ebuild maintainer."
	fi
}

_set_global_flags() {
	export ARCH="${arch}"
	export LDFLAGS="-L/usr/$(get_libdir)"
	export LDDEPS="-lglfw -lGLEW"
}

src_prepare() {
	default
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_prepare() {
			cd "${BUILD_DIR}" || die
			cd "Box2D" || die
			if [[ "${ECMAKE_LIB_TYPE}" == "shared-libs" ]] ; then
				sed -i -e "s|StaticLib|SharedLib|g" \
					premake4.lua || die
			fi
			local arch=""
			local platform=""
			_get_abi_settings
			_set_global_flags
			premake4 --platform=${platform} gmake
		}
		cmake-static-libs_copy_sources
		cmake-static-libs_foreach_impl \
			cmake-static-libs_prepare
	}
	multilib_copy_sources
	multilib_foreach_abi prepare_abi
}

src_configure() {
	:;
}

src_compile() {
	local mydebug=$(usex debug "debug" "release")
	compile_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_compile() {
			cd "${BUILD_DIR}" || die
			local arch=""
			local platform=""
			_get_abi_settings
			_set_global_flags
			pushd Box2D/Build/gmake || die
				emake config="${mydebug}" verbose=1 || die
			popd
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
			cd "${BUILD_DIR}" || die
			pushd "Box2D/Build/gmake/bin/${mydebug}" || die
			if [[ "${ECMAKE_LIB_TYPE}" == "shared-libs" ]] ; then
				dolib.so libBox2D.so libGLUI.so
			else
				dolib.a libBox2D.a libGLUI.a
			fi
			popd
		}
		cmake-static-libs_foreach_impl \
			cmake-static-libs_install
	}
	multilib_foreach_abi install_abi

	pushd Box2D || die
	FILES=$(find Box2D -name "*.h")
	for FILE in ${FILES}
	do
		insinto "/usr/include/$(dirname ${FILE})"
		doins "${FILE}"
	done
	popd

	cd Box2D/Documentation || die
	if use doc; then
		doxygen Doxyfile
		dodoc -r API images manual.docx
	fi
}
