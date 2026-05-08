# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17
LLVM_COMPAT=( 20 )
MY_PN="SPIRV-LLVM-Translator"
MY_P="${MY_PN}-${PV}"

# Align libstdcxx to avoid symbol issues
inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit cmake-multilib flag-o-matic libstdcxx-slot llvm-r2 multiprocessing

DESCRIPTION="Bi-directional translator between SPIR-V and LLVM IR"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="UoI-NCSA"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
IUSE="
test
ebuild_revision_1
"
RESTRICT="!test? ( test )
	arm? ( test )
	arm64? ( test )
	loong? ( test )
	riscv? ( test )
"

RDEPEND="
	dev-util/spirv-tools[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	llvm-core/llvm:${SLOT}=[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-util/spirv-headers-1.4.328.0
"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-python/lit
		llvm-core/clang:${SLOT}[${LIBSTDCXX_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}"/${PN}-20.1.3-option-registered.patch )

pkg_setup() {
	libstdcxx-slot_verify
	llvm-r2_pkg_setup
}

src_prepare() {
	append-flags -fPIC
	cmake_src_prepare

	# do not force a specific LLVM version to find_package(), this only
	# causes issues and we force a specific path anyway
	sed -i -e '/find_package/s:${BASE_LLVM_VERSION}::' CMakeLists.txt || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCCACHE_ALLOWED="OFF"
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix)"
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${ESYSROOT}/usr/include/spirv"
		-DLLVM_SPIRV_INCLUDE_TESTS=$(usex test "ON" "OFF")
		-Wno-dev
	)

	cmake_src_configure
}

multilib_src_test() {
	lit -vv "-j${LIT_JOBS:-$(makeopts_jobs)}" "${BUILD_DIR}/test" || die
}
