# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils multilib-minimal static-libs toolchain-funcs versionator

DESCRIPTION="a fast key-value storage library written at Google"
HOMEPAGE="http://leveldb.org/ https://github.com/google/leveldb"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-fbsd ~amd64-linux \
~x86-linux"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0/${PV}"
IUSE+=" +snappy +tcmalloc kernel_FreeBSD"
# See .travis.yml for details
SNAPPY_V="0.3.7"
# Skipped sqlite and kyotocabinet
CDEPEND=">=sys-devel/gcc-8.4.0"
DEPEND+=" ${CDEPEND}
	tcmalloc? ( >=dev-util/google-perftools-2.5[${MULTILIB_USEDEP}] )
	snappy? (
		>=app-arch/snappy-${SNAPPY_V}:=[${MULTILIB_USEDEP}]
		static-libs? ( >=app-arch/snappy-${SNAPPY_V}:=[static-libs,${MULTILIB_USEDEP}] )
	)"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${CDEPEND}
	>=dev-util/cmake-3.9
	>=dev-util/ninja-0.1.3
	>=sys-devel/clang-8"
PATCHES=( "${FILESDIR}/${PN}-1.22-add-options.patch" )
RESTRICT="mirror"

src_prepare() {
	multilib_copy_sources
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		S="${BUILD_DIR}" \
		static-libs_copy_sources
	}
	multilib_foreach_abi prepare_abi
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		prepare_impl() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" \
			CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_prepare
		}
		static-libs_foreach_impl prepare_impl
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	configure_abi() {
		cd "${BUILD_DIR}" || die
		configure_impl() {
			mycmakeargs=()
			if [[ "${ESTSH_LIB_TYPE}" == "static-libs" ]] ; then
				mycmakeargs+=(
					-DBUILD_SHARED_LIBS=OFF
				)
			else
				mycmakeargs+=(
					-DBUILD_SHARED_LIBS=ON
				)
			fi
			S="${BUILD_DIR}" \
			CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_configure
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
			S="${BUILD_DIR}" \
			CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_compile
		}
		static-libs_foreach_impl compile_impl
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		cd "${BUILD_DIR}" || die
		test_impl() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" \
			CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_test
		}
		static-libs_foreach_impl test_impl
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		cd "${BUILD_DIR}" || die
		install_impl() {
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" \
			CMAKE_USE_DIR="${BUILD_DIR}" \
			cmake-utils_src_install
		}
		static-libs_foreach_impl install_impl
	}
	multilib_foreach_abi install_abi
	cd "${S}" || die
	docinto licenses
	dodoc LICENSE
}
