# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.5.1/llvm/CMakeLists.txt
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake llvm prefix rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/"
	inherit git-r3
	S="${WORKDIR}/${P}/lib/comgr"
else
	SRC_URI="
https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	S="${WORKDIR}/ROCm-CompilerSupport-rocm-${PV}/lib/comgr"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Code Object Manager"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="system-llvm test r6"
RDEPEND="
	!system-llvm? (
		sys-devel/llvm-roc:=
		~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
	)
	!dev-libs/rocm-comgr:0
	dev-util/rocm-compiler:${ROCM_SLOT}[system-llvm=]
	~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
	system-llvm? (
		=sys-devel/clang-runtime-${LLVM_MAX_SLOT}*
		sys-devel/clang:${LLVM_MAX_SLOT}
		sys-devel/clang:=
		sys-devel/clang-runtime:=
		sys-devel/lld:${LLVM_MAX_SLOT}
		sys-devel/lld:=
	)
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
	>=dev-util/cmake-3.13.4
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-clang-fix-include.patch"
#	"${FILESDIR}/${PN}-5.3.3-fix-tests.patch"
	"${FILESDIR}/${PN}-5.3.3-fno-stack-protector.patch"
	"${FILESDIR}/${PN}-5.3.3-remove-h-option.patch"
	"${FILESDIR}/${PN}-5.5.1-clang-fix-None.patch"
	"${FILESDIR}/${PN}-5.5.1-CommonLinkerContext-header.patch"
	"${FILESDIR}/${PN}-5.5.1-fix-SubtargetFeatures.patch"
	"${FILESDIR}/${PN}-5.5.1-path-changes.patch"
	"${FILESDIR}/${PN}-5.5.1-llvm-not-dylib-add-libs.patch"
	"${FILESDIR}/${PN}-5.6.1-rpath.patch"
)
CMAKE_BUILD_TYPE="Release"

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	if use system-llvm ; then
		eapply "${FILESDIR}/${PN}-5.5.1-update-relax-relocation.patch"
	fi
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	# Disable stripping defined at lib/comgr/CMakeLists.txt:58
		-DCMAKE_STRIP=""
		-DLLVM_DIR="${ESYSROOT}${EROCM_LLVM_PATH}"
		-DLLVM_LINK_LLVM_DYLIB=$(usex system-llvm)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
