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
IUSE="test ebuild-revision-14"
# https://github.com/ROCm/HIPIFY/blob/rocm-6.0.2/docs/hipify-clang.md
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
		${ROCM_CLANG_DEPEND}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	!test? (
		${ROCM_CLANG_DEPEND}
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
	"${FILESDIR}/${PN}-5.7.0-llvm-dynlib-on.patch"
	"${FILESDIR}/${PN}-5.7.0-install-headers-option.patch"
	"${FILESDIR}/${PN}-5.7.1-hardcoded-paths.patch"
)

pkg_setup() {
	if ! use test ; then
		:
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
	rocm_set_default_clang

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DHIPIFY_INSTALL_HEADERS=ON
		-DUSE_SYSTEM_LLVM=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
	# See tarball for layout.
	dodir "/opt/rocm-${PV}/libexec/hipify"
	dodir "/opt/rocm-${PV}/include/hipify"
	dodir "/opt/rocm-${PV}/bin"
	dodir "/opt/rocm-${PV}/hip/bin"
	mv \
		"${ED}/opt/rocm-${PV}/include/"*".h" \
		"${ED}/opt/rocm-${PV}/include/cuda_wrappers" \
		"${ED}/opt/rocm-${PV}/include/fuzzer" \
		"${ED}/opt/rocm-${PV}/include/module.modulemap" \
		"${ED}/opt/rocm-${PV}/include/orc" \
		"${ED}/opt/rocm-${PV}/include/profile" \
		"${ED}/opt/rocm-${PV}/include/sanitizer" \
		"${ED}/opt/rocm-${PV}/include/xray" \
		"${ED}/opt/rocm-${PV}/include/hipify" \
		|| die
	mv \
		"${ED}/opt/rocm-${PV}/bin/findcode.sh" \
		"${ED}/opt/rocm-${PV}/bin/finduncodep.sh" \
		"${ED}/opt/rocm-${PV}/libexec/hipify" \
		|| die
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-STATUS:  needs install test
