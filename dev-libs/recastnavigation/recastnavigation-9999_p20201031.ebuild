# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Navigation-mesh Toolset for Games"
HOMEPAGE="https://github.com/memononen/recastnavigation"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE="debug demo examples static-libs test"
inherit cmake-static-libs cmake-utils multilib-minimal
RDEPEND="demo? (
		media-libs/libsdl2[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-8.0"
inherit eutils toolchain-funcs
EGIT_COMMIT="65b314a44e92d5e07d943e7523455ad4d391dfaa"
SRC_URI="\
https://github.com/${PN}/${PN}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	GCC_V=$(gcc-fullversion)
	if ver_test ${GCC_V} -lt "8.0" ; then
		die "You need at least gcc 8.0 to compile."
	fi
}

src_prepare() {
	multilib_copy_sources
	prepare_abi() {
		cmake-static-libs_copy_sources
		cd "${BUILD_DIR}" || die
		prepare_impl() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_prepare
		}
		cmake-static-libs_foreach_impl prepare_impl
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	configure_abi() {
		cd "${BUILD_DIR}" || die
		configure_impl() {
			cd "${BUILD_DIR}" || die
			mycmakeargs=(
				-DRECASTNAVIGATION_DEMO=$(usex demo)
				-DRECASTNAVIGATION_TESTS=$(usex test)
				-DRECASTNAVIGATION_EXAMPLES=$(usex examples)
			)
			if [[ "${ECMAKE_LIB_TYPE}" == "static-libs" ]] ; then
				mycmakeargs+=(
					-DRECASTNAVIGATION_STATIC=ON
				)
			else
				mycmakeargs+=(
					-DRECASTNAVIGATION_STATIC=OFF
				)
			fi
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_configure
		}
		cmake-static-libs_foreach_impl configure_impl
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		compile_impl() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_compile
		}
		cmake-static-libs_foreach_impl compile_impl
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	install_abi() {
		cd "${BUILD_DIR}" || die
		install_impl() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_install
		}
		cmake-static-libs_foreach_impl install_impl
	}
	multilib_foreach_abi install_abi
	docinto licenses
	dodoc License.txt
}
