# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=17
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/HIPIFY/"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
	SRC_URI="
https://github.com/ROCm-Developer-Tools/HIPIFY/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="HIPIFY: Convert CUDA to Portable C++ Code"
HOMEPAGE="https://github.com/RadeonOpenCompute/HIPIFY"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="test ebuild-revision-9"
# https://github.com/ROCm-Developer-Tools/HIPIFY/blob/rocm-6.0.2/docs/hipify-clang.md#hipify-clang-dependencies
TEST_BDEPEND="
	|| (
		=dev-util/nvidia-cuda-toolkit-12.2*
		=dev-util/nvidia-cuda-toolkit-11.8*
		=dev-util/nvidia-cuda-toolkit-11.7*
		=dev-util/nvidia-cuda-toolkit-11.5*
	)
	dev-util/nvidia-cuda-toolkit:=
"
RDEPEND="
	!test? (
		~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	!test? (
		~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
	)
	test? (
		${TEST_BDEPEND}
	)
	>=dev-build/cmake-3.16.8
"
RESTRICT="
	test
"
PATCHES=(
	"${FILESDIR}/HIPIFY-5.7.0-llvm-dynlib-on.patch"
	"${FILESDIR}/HIPIFY-5.7.0-install-headers-option.patch"
)

pkg_setup() {
	if ! use test ; then
		:;
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.2*" && has_version "=sys-devel/clang-17*" && has_version "=sys-devel/llvm-17*" ; then
		LLVM_SLOT=17
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.2*" && has_version "=sys-devel/clang-16*" && has_version "=sys-devel/llvm-16*" ; then
		LLVM_SLOT=16
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" && has_version "=sys-devel/clang-15*" && has_version "=sys-devel/llvm-15*" ; then
		LLVM_SLOT=15
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" && has_version "=sys-devel/clang-14*" && has_version "=sys-devel/llvm-14*" ; then
		LLVM_SLOT=14
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.7*" && has_version "=sys-devel/clang-14*" && has_version "=sys-devel/llvm-14*" ; then
		LLVM_SLOT=14
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.5*" && has_version "=sys-devel/clang-13*" && has_version "=sys-devel/llvm-13*" ; then
		LLVM_SLOT=13
	fi
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	export CC="clang"
	export CXX="clang++"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DUSE_SYSTEM_LLVM=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-STATUS:  needs install test
