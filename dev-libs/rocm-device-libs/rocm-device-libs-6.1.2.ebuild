# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
LLVM_SLOT=17 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-6.1.2/llvm/CMakeLists.txt
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/llvm-project.git"
	S="${WORKDIR}/${P}/src"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/llvm-project-rocm-${PV}/amd/device-libs"
	SRC_URI="
https://github.com/ROCm/llvm-project/archive/refs/tags/rocm-${PV}.tar.gz
	-> llvm-project-rocm-${PV}.tar.gz
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
IUSE="test ebuild-revision-11"
RDEPEND="
	${ROCM_CLANG_DEPEND}
	!dev-libs/rocm-device-libs:0
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
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	# Generated from:
	#grep -F -r -e "+++" files | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${S}/doc/OCKL.md"
		"${S}/ockl/inc/ockl.h"
		"${S}/ockl/src/dm.cl"
		"${S}/ockl/src/mtime.cl"
		"${S}/ockl/src/wait.cl"
		"${S}/src/dm.cl"
		"${S}/src/wait.cl"
		"${S}/test/constant_folding/CMakeLists.txt"
		"${S}/test/constant_folding/RunConstantFoldTest.cmake"
	)
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	export LD_LIBRARY_PATH="${EROCM_PATH}/llvm/$(rocm_get_libdir):${LD_LIBRARY_PATH}"
	rocm_set_default_clang
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DLLVM_DIR="${ESYSROOT}${EROCM_LLVM_PATH}"
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
