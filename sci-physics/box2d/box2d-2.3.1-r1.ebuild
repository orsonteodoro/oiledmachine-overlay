# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Box2D is a 2D physics engine for games"
HOMEPAGE="http://box2d.org/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE="debug doc examples static"
inherit multilib-minimal
RDEPEND=">=dev-util/premake-4.4
	 <dev-util/premake-5.0
	 media-libs/glew[${MULTILIB_USEDEP}]
	 media-libs/glfw[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"
inherit eutils
SRC_URI=\
"https://github.com/erincatto/Box2D/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/Box2D-${PV}"

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

src_prepare() {
	default
	cd "Box2D"
	if ! use static; then
		sed -i -e "s|StaticLib|SharedLib|g" \
			premake4.lua || die
	fi
	multilib_copy_sources
}

src_configure() {
	:;
}

src_compile() {
	compile_abi() {
		local arch=""
		local platform=""
		_get_abi_settings
		cd "${BUILD_DIR}"
		local mydebug=$(usex debug "debug" "release")
		pushd Box2D/Build/gmake || die
			ARCH="${arch}" \
			LDDEPS="-lglfw -lGLEW" \
			emake config="${mydebug}" || die
		popd
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_abi() {
		cd "${BUILD_DIR}"
		pushd "Box2D/Build/gmake/bin/${mydebug}" || die
		if use static; then
			dolib.a libBox2D.a libGLUI.a
		else
			dolib.so libBox2D.so libGLUI.so
		fi
		popd
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
