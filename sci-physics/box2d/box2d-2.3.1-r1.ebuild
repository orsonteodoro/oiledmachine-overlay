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
	 media-libs/glfw[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"
inherit eutils
SRC_URI=\
"https://github.com/erincatto/Box2D/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/Box2D-${PV}"

src_prepare() {
	default
	multilib_copy_sources
	prepare_abi() {
		cd "${BUILD_DIR}"
		if ! use static; then
			sed -i -e "s|StaticLib|SharedLib|g" \
				premake4.lua || die
		fi
		premake4 gmake
		sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" \
			Build/gmake/Box2D.make || die
		sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" \
			-e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" \
			Build/gmake/Box2D.make || die
		sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" \
			-e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" \
			Build/gmake/GLUI.make || die
		sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" \
			-e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" \
			Build/gmake/HelloWorld.make || die
		sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" \
			-e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" \
			Build/gmake/Testbed.make || die
		sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" \
			Build/gmake/GLUI.make || die
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	:;
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}"
		local mydebug=$(usex debug "debug" "release")
		pushd Box2D/Build/gmake || die
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
