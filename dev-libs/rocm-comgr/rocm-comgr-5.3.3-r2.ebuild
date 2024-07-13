# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
LLVM_SLOT=15 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.3.3/llvm/CMakeLists.txt
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic prefix rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/"
	S="${WORKDIR}/${P}/lib/comgr"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/ROCm-CompilerSupport-rocm-${PV}/lib/comgr"
	SRC_URI="
https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Radeon Open Compute Code Object Manager"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="test ebuild-revision-11"
RDEPEND="
	!dev-libs/rocm-comgr:0
	sys-devel/llvm-roc:=
	~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
	~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
RESTRICT="
	!test? (
		test
	)
"
BDEPEND="
	>=dev-build/cmake-3.13.4
	sys-devel/gcc:12
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-clang-fix-include.patch"
	"${FILESDIR}/${PN}-5.1.3-llvm-15-remove-zlib-gnu"
	"${FILESDIR}/${PN}-5.3.3-fix-tests.patch"
	"${FILESDIR}/${PN}-5.3.3-fno-stack-protector.patch"
	"${FILESDIR}/${PN}-5.3.3-remove-h-option.patch"
	"${FILESDIR}/${PN}-5.5.1-llvm-not-dylib-add-libs.patch"
	"${FILESDIR}/${PN}-5.6.1-rpath.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	export CC="${CHOST}-gcc-12"
	export CXX="${CHOST}-g++-12"
	export CPP="${CXX} -E"
	filter-flags '-fuse-ld=*'
	append-ldflags -fuse-ld=bfd
	strip-unsupported-flags

	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	# Disable stripping defined at lib/comgr/CMakeLists.txt:58
		-DCMAKE_STRIP=""
		-DLLVM_DIR="${ESYSROOT}${EROCM_LLVM_PATH}"
		-DLLVM_LINK_LLVM_DYLIB=OFF
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
