# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multilib-minimal toolchain-funcs

DESCRIPTION="a fast key-value storage library written at Google"
HOMEPAGE="http://leveldb.org/ https://github.com/google/leveldb"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-fbsd ~amd64-linux
~x86-linux"
KEYWORDS="amd64 arm arm64 ~mips ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
SLOT="0/$(ver_cut 1 ${PV})"
IUSE+=" +snappy +tcmalloc static-libs test"
RESTRICT="!test? ( test )"
# See .travis.yml for details
SNAPPY_V="0.3.7"
# Skipped sqlite and kyotocabinet
CDEPEND=">=sys-devel/gcc-8.4.0"
DEPEND+="
	${CDEPEND}
	dev-libs/crc32c[${MULTILIB_USEDEP}]
	tcmalloc? ( >=dev-util/google-perftools-2.5[${MULTILIB_USEDEP}] )
	snappy? (
		>=app-arch/snappy-${SNAPPY_V}:=[${MULTILIB_USEDEP}]
		static-libs? ( >=app-arch/snappy-${SNAPPY_V}:=[${MULTILIB_USEDEP}] )
	)
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	${CDEPEND}
	>=dev-util/cmake-3.9
	>=dev-build/ninja-0.1.3
	>=sys-devel/clang-8
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.23-system-testdeps.patch
	"${FILESDIR}"/${PN}-1.23-remove-benchmark-dep.patch
)
SRC_URI="https://github.com/google/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

get_lib_type() {
	use static-libs && echo "static"
	echo "shared"
}

src_prepare() {
	sed -e '/fno-rtti/d' -i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	configure_abi() {
		local lib_type
		for lib_type in $(get_lib_type) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${CMAKE_USE_DIR}" || die
			mycmakeargs=(
				-DHAVE_CRC32C=ON
				-DLEVELDB_BUILD_BENCHMARKS=OFF
				-DHAVE_SNAPPY=$(usex snappy)
				-DHAVE_TCMALLOC=$(usex tcmalloc)
				-DLEVELDB_BUILD_TESTS=$(usex test)
			)
			if [[ "${lib_type}" == "static" ]] ; then
				mycmakeargs+=( -DBUILD_SHARED_LIBS=OFF )
			else
				mycmakeargs+=( -DBUILD_SHARED_LIBS=ON )
			fi
			cmake_src_configure
		done
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_type) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_compile
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		local lib_type
		for lib_type in $(get_lib_type) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_test
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_type) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_install
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
}

multilib_src_install_all() {
	cd "${S}" || die
	docinto licenses
	dodoc LICENSE
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi, static-libs
