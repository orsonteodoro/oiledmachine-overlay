# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=18
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic rocm

if [[ ${PV} == *"9999" ]] ; then
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
HOMEPAGE="https://github.com/ROCm/HIPIFY"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	MIT
"
# all-rights-reserved MIT - src/LLVMCompat.h
# MIT - tests/unit_tests/libraries/cuRAND/cmdparser.hpp
# MIT - LICENSE.txt
# The distro's MIT license template does not contain all rights reserved.
SLOT="${ROCM_SLOT}/${PV}"
IUSE="test ebuild_revision_17"
# https://github.com/ROCm/HIPIFY/blob/rocm-6.2.4/docs/hipify-clang.rst
RDEPEND="
	!test? (
		${ROCM_CLANG_DEPEND}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	test? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12.6*
			=dev-util/nvidia-cuda-toolkit-12.3*
			=dev-util/nvidia-cuda-toolkit-12.2*
			=dev-util/nvidia-cuda-toolkit-11.8*
			=dev-util/nvidia-cuda-toolkit-11.7*
			=dev-util/nvidia-cuda-toolkit-11.5*
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	>=dev-build/cmake-3.16.8
"
RESTRICT="
	test
"
PATCHES=(
	"${FILESDIR}/${PN}-5.7.1-hardcoded-paths.patch"
)

pkg_setup() {
	check-compiler-switch_start
	if ! use test ; then
		:
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.6*" && has_version "=llvm-core/clang-19*" && has_version "=llvm-core/llvm-17*" ; then
		LLVM_SLOT=19
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.5*" && has_version "=llvm-core/clang-19*" && has_version "=llvm-core/llvm-17*" ; then
		LLVM_SLOT=19
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.4*" && has_version "=llvm-core/clang-19*" && has_version "=llvm-core/llvm-17*" ; then
		LLVM_SLOT=19
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.3*" && has_version "=llvm-core/clang-18*" && has_version "=llvm-core/llvm-17*" ; then
		LLVM_SLOT=18
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.3*" && has_version "=llvm-core/clang-17*" && has_version "=llvm-core/llvm-17*" ; then
		LLVM_SLOT=17
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.2*" && has_version "=llvm-core/clang-17*" && has_version "=llvm-core/llvm-17*" ; then
		LLVM_SLOT=17
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.2*" && has_version "=llvm-core/clang-16*" && has_version "=llvm-core/llvm-16*" ; then
		LLVM_SLOT=16
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" && has_version "=llvm-core/clang-15*" && has_version "=llvm-core/llvm-15*" ; then
		LLVM_SLOT=15
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" && has_version "=llvm-core/clang-14*" && has_version "=llvm-core/llvm-14*" ; then
		LLVM_SLOT=14
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.7*" && has_version "=llvm-core/clang-14*" && has_version "=llvm-core/llvm-14*" ; then
		LLVM_SLOT=14
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.5*" && has_version "=llvm-core/clang-13*" && has_version "=llvm-core/llvm-13*" ; then
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

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
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
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-STATUS:  needs install test
