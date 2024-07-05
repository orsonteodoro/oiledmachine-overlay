# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=17 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.7.0/llvm/CMakeLists.txt
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-Device-Libs/"
	S="${WORKDIR}/${P}/src"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/ROCm-Device-Libs-rocm-${PV}"
	SRC_URI="
https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Radeon Open Compute Device Libraries"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-Device-Libs"
LICENSE="MIT"
RESTRICT="
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="test ebuild-revision-6"
RDEPEND="
	!dev-libs/rocm-device-libs:0
	sys-devel/llvm-roc:=
	~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.13.4
	sys-devel/llvm-roc:=
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
"
PATCHES=(
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
		-DLLVM_DIR="${ESYSROOT}${EROCM_LLVM_PATH}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
