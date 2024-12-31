# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
LLVM_SLOT=16 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.6.1/llvm/CMakeLists.txt
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
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	BSD
	UoI-NCSA
"
# BSD - lib/comgr/LICENSE.txt
# all-rights-reserved MIT - lib/comgr/comgr-backward-compat.cmake
# UoI-NCSA - lib/comgr/test/disasm_options_test.c
# The distro's MIT license template does not contain all rights reserved.
# strip - Prevent missing symbols
RESTRICT="
	strip
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="test ebuild_revision_15"
RDEPEND="
	${ROCM_CLANG_DEPEND}
	!dev-libs/rocm-comgr:0
	~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	>=dev-build/cmake-3.13.4
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-clang-fix-include.patch"
#	"${FILESDIR}/${PN}-5.3.3-fix-tests.patch"
	"${FILESDIR}/${PN}-5.3.3-fno-stack-protector.patch"
	"${FILESDIR}/${PN}-5.6.1-llvm-not-dylib-add-libs.patch"
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
	rocm_set_default_clang

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
