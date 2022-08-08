# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="Navigation-mesh Toolset for Games"
HOMEPAGE="https://github.com/memononen/recastnavigation"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE="debug demo examples static-libs test"
inherit cmake flag-o-matic multilib-minimal
RDEPEND="demo? (
		media-libs/libsdl2[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-8.0"
inherit static-libs toolchain-funcs
EGIT_COMMIT="c5cbd53024c8a9d8d097a4371215e3342d2fdc87"
SRC_URI="\
https://github.com/${PN}/${PN}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
_PATCHES=( "${FILESDIR}/recastnavigation-9999_p20200807-fix-shared-lib-65b314a.patch" )

pkg_setup() {
	GCC_V=$(gcc-fullversion)
	if ver_test ${GCC_V} -lt "8.0" ; then
		die "You need at least gcc 8.0 to compile."
	fi
}

src_prepare() {
	multilib_copy_sources
	prepare_abi() {
		static-libs_copy_sources
		cd "${BUILD_DIR}" || die
		prepare_impl() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake_src_prepare
			eapply -R "${_PATCHES[@]}"
		}
		static-libs_foreach_impl prepare_impl
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
			if [[ "${ESTSH_LIB_TYPE}" == "static-libs" ]] ; then
				mycmakeargs+=(
					-DRECASTNAVIGATION_STATIC=ON
				)
			else
				mycmakeargs+=(
					-DRECASTNAVIGATION_STATIC=OFF
				)
			fi

			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake_src_configure
		}
		static-libs_foreach_impl configure_impl
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		compile_impl() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake_src_compile
		}
		static-libs_foreach_impl compile_impl
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	install_abi() {
		cd "${BUILD_DIR}" || die
		install_impl() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake_src_install
		}
		static-libs_foreach_impl install_impl
	}
	multilib_foreach_abi install_abi
	docinto licenses
	dodoc License.txt
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi, static-libs
