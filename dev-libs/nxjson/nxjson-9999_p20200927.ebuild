# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Very small JSON parser written in C."
HOMEPAGE="https://github.com/yarosla/nxjson"
LICENSE="LGPL-3+"

# Live ebuilds do not get keyworded

SLOT="0/${PV}"
IUSE="debug static test"
EGIT_COMMIT="d2c6fba9d5b0d445722105dd2a64062c1309ac86"
SRC_URI=\
"https://github.com/yarosla/nxjson/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
inherit cmake-utils eutils multilib-minimal static-libs toolchain-funcs
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
_PATCHES=( "${FILESDIR}/nxjson-9999_p20200927-libdir-path.patch" )

src_prepare() {
	default
	export CMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_prepare() {
			cd "${BUILD_DIR}" || die
			if [[ "${ESTSH_LIB_TYPE}" == "shared-libs" ]] ; then
				sed -i -e "s|STATIC|SHARED|" CMakeLists.txt || die
			fi
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_prepare
			eapply ${_PATCHES[@]}
		}
		static-libs_copy_sources
		static-libs_foreach_impl \
			static-libs_prepare
	}
	multilib_copy_sources
	multilib_foreach_abi prepare_abi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)
	configure_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_configure() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_configure
		}
		static-libs_foreach_impl \
			static-libs_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_compile() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_compile
		}
		static-libs_foreach_impl \
			static-libs_compile
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_test() {
			cd "${BUILD_DIR}" || die
			if use test ; then
				nxjson || die
			fi
		}
		static-libs_foreach_impl \
			static-libs_test
	}
	multilib_foreach_abi test_abi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_abi() {
		cd "${BUILD_DIR}" || die
		static-libs_install() {
			pushd "${BUILD_DIR}" || die
			cmake-utils_src_install
		}
		static-libs_foreach_impl \
			static-libs_install
	}
	multilib_foreach_abi install_abi
}
