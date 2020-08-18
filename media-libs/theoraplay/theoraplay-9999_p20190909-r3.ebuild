# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="TheoraPlay is a simple library to make decoding of Ogg Theora \
videos easier."
HOMEPAGE="https://icculus.org/theoraplay/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE="debug"
inherit cmake-static-libs multilib-build
REQUIRED_USE=""
RDEPEND="media-libs/libtheora:=[static-libs?,${MULTILIB_USEDEP}]
         media-libs/libogg:=[static-libs?,${MULTILIB_USEDEP}]
         media-libs/libvorbis:=[static-libs?,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
        dev-util/premake:5"
EGIT_COMMIT="99e5fc74603e"
SRC_URI=\
"https://hg.icculus.org/icculus/theoraplay/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit eutils
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default
	cp "${FILESDIR}/buildcpp.lua" "${S}" || die
	premake5 --file=buildcpp.lua gmake || die
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_copy_sources
	}
	multilib_copy_sources
	multilib_foreach_abi prepare_abi
}

src_compile() {
	local mydebug=$(usex debug "debug" "release")
	compile_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_compile() {
			cd "${BUILD_DIR}" || die
			cd build/ || die
			if [[ "${ECMAKE_LIB_TYPE}" == "shared-libs" ]] ; then
				emake config=${mydebug}sharedlib || die
			else
				emake config=${mydebug}staticlib || die
			fi
		}
		cmake-static-libs_foreach_impl cmake-static-libs_compile
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_install() {
			cd "${BUILD_DIR}" || die
			if [[ "${ECMAKE_LIB_TYPE}" == "shared-libs" ]] ; then
				cd "build/bin/${mydebug}SharedLib" || die
				dolib.so lib${PN}.so
			else
				cd "build/bin/${mydebug}StaticLib" || die
				dolib.a lib${PN}.a
			fi
			cd "${BUILD_DIR}" || die
			doheader ${PN}.h
		}
		cmake-static-libs_foreach_impl cmake-static-libs_install
	}
	multilib_foreach_abi install_abi
}
