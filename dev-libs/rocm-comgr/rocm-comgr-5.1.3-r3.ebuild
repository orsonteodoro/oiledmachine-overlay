# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.1.3/llvm/CMakeLists.txt
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
IUSE="system-llvm r5"
RDEPEND="
	!system-llvm? (
		sys-devel/llvm-roc:=
		~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
	)
	!dev-libs/rocm-comgr:0
	dev-util/rocm-compiler[system-llvm=]
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
BDEPEND="
	>=dev-util/cmake-3.13.4
	~dev-util/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-4.5.2-dependencies.patch"
	"${FILESDIR}/${PN}-5.1.3-clang-link.patch"
	"${FILESDIR}/${PN}-5.1.3-clang-fix-include.patch"
	"${FILESDIR}/0001-COMGR-changes-needed-for-upstream-llvm.patch"
#	"${FILESDIR}/${PN}-5.1.3-llvm-15-remove-zlib-gnu"
#	"${FILESDIR}/${PN}-5.1.3-llvm-15-args-changed"
	"${FILESDIR}/${PN}-5.3.3-fno-stack-protector.patch"
	"${FILESDIR}/${PN}-5.1.3-path-changes.patch"
	"${FILESDIR}/${PN}-5.1.3-llvm-not-dylib-add-libs.patch"
)
CMAKE_BUILD_TYPE="Release"

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
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
