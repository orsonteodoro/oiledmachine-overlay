# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=17 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.7.0/llvm/CMakeLists.txt
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake llvm rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-Device-Libs/"
	inherit git-r3
	S="${WORKDIR}/${P}/src"
else
	SRC_URI="
https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	S="${WORKDIR}/ROCm-Device-Libs-rocm-${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Device Libraries"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-Device-Libs"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="system-llvm test r4"
RDEPEND="
	!dev-libs/rocm-device-libs:0
	!system-llvm? (
		sys-devel/llvm-roc:=
		~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
	)
	system-llvm? (
		sys-devel/clang:${LLVM_MAX_SLOT}
		sys-devel/llvm:${LLVM_MAX_SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	!system-llvm? (
		sys-devel/llvm-roc:=
		~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
	)
	>=dev-util/cmake-3.13.4
	~dev-util/rocm-cmake-${PV}:${ROCM_SLOT}
	system-llvm? (
		sys-devel/clang:${LLVM_MAX_SLOT}
		sys-devel/llvm:${LLVM_MAX_SLOT}
	)
"
RESTRICT="
	!test? (
		test
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.3.3-path-changes.patch"
)
CMAKE_BUILD_TYPE="Release"

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	if use system-llvm ; then
# https://github.com/RadeonOpenCompute/ROCm-Device-Libs/issues/94
		eapply "${FILESDIR}/${PN}-5.5.1-llvm-link.patch"
	fi
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DLLVM_DIR="${ESYSROOT}${EROCM_LLVM_PATH}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
