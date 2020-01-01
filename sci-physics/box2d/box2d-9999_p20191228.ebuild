# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Box2D is a 2D physics engine for games"
HOMEPAGE="http://box2d.org/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="37e2dc25f8da158abda10324d75cb4d1db009adf"
SLOT="0/${PVR}"
IUSE="debug doc examples static"
inherit multilib-minimal
RDEPEND="dev-util/premake:5
	 media-libs/glew[${MULTILIB_USEDEP}]
	 media-libs/glfw[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"
inherit eutils
SRC_URI=\
"https://github.com/erincatto/Box2D/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/Box2D-${EGIT_COMMIT}"

src_prepare() {
	default
	multilib_copy_sources
	prepare_abi() {
		cd "${BUILD_DIR}"
		if ! use static; then
			sed -i -e "s|StaticLib|SharedLib|g" \
				premake5.lua || die
		fi
		premake5 gmake2
		sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" \
			Build/Box2D.make || die
		sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" \
			-e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" \
			Build/Box2D.make || die
		sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" \
			-e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" \
			Build/HelloWorld.make || die
		sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH)|\$(ALL_CPPFLAGS)|" \
			-e "s|\$(RESOURCES) \$(ARCH)|\$(RESOURCES)|" \
			Build/Testbed.make || die
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	:;
}

src_compile() {
	local abi=""
	compile_abi() {
		cd "${BUILD_DIR}"
		if [[ "${ABI}" == "amd64" ]] ; then
			abi="x86_64"
		else
			abi="${ABI}"
		fi
		local mydebug=$(usex debug "debug_${abi}" "release_${abi}")
		pushd Build || die
			LDDEPS="-lglfw -lGLEW" \
			emake config="${mydebug}" || die
		popd
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	local abi=""
	if [[ "${ABI}" == "amd64" ]] ; then
		abi="x86_64"
	else
		abi="${ABI}"
	fi
	local mydebug=$(usex debug "Debug" "Release")
	install_abi() {
		cd "${BUILD_DIR}"
		pushd "Build/bin/${abi}/${mydebug}"
		if use static ; then
			dolib.a libBox2D.a
		else
			dolib.so libBox2D.so
		fi
		popd
	}
	multilib_foreach_abi install_abi

	pushd Box2D || die
	FILES=$(find . -name "*.h")
	for FILE in ${FILES}
	do
		insinto "/usr/include/$(dirname ${FILE})"
		doins "${FILE}"
	done
	popd

	cd Documentation || die
	if use doc; then
		doxygen Doxyfile
		dodoc -r API images manual.docx
	fi
}
