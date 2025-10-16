# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Requirements:
# https://github.com/ROCm/HIPIFY/blob/rocm-7.0.2/docs/how-to/hipify-clang.rst

LLVM_SLOT=19
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
SLOT="0/${ROCM_SLOT}"
IUSE="
asan test
ebuild_revision_20
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
	${ROCM_CLANG_DEPEND}
	test? (
		|| (
			(
				=dev-util/nvidia-cuda-toolkit-12.9*
				|| (
					(
						=llvm-core/clang-21.0.0.9999:21
						=llvm-core/llvm-21.0.0.9999:21
					)
				)
			)
			(
				=dev-util/nvidia-cuda-toolkit-12.8*
				|| (
					(
						llvm-core/clang:20
						llvm-core/llvm:20
					)
				)
			)
			(
				=dev-util/nvidia-cuda-toolkit-12.6*
				|| (
					(
						llvm-core/clang:19
						llvm-core/llvm:19
					)
				)
			)
			(
				=dev-util/nvidia-cuda-toolkit-12.3*
				|| (
					(
						llvm-core/clang:17
						llvm-core/llvm:17
					)
					(
						llvm-core/clang:18
						llvm-core/llvm:18
					)
				)
			)
			(
				=dev-util/nvidia-cuda-toolkit-11.8*
				|| (
					(
						llvm-core/clang:15
						llvm-core/llvm:15
					)
				)
			)
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	>=dev-build/cmake-3.16.8
"
RESTRICT="
	test
"
PATCHES=(
)

pkg_setup() {
	check-compiler-switch_start
ewarn "None of the configurations for CUDA - LLVM available pairings are supported by upstream."
	if ! use test ; then
		:
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.9*" && has_version "=llvm-core/clang-21.0.0.9999" && has_version "=llvm-core/llvm-21.0.0.9999" ; then
		LLVM_SLOT=21
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.8*" && has_version "=llvm-core/clang-20*" && has_version "=llvm-core/llvm-20*" ; then
		LLVM_SLOT=20
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.6*" && has_version "=llvm-core/clang-19*" && has_version "=llvm-core/llvm-19*" ; then
		LLVM_SLOT=19
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.3*" && has_version "=llvm-core/clang-17*" && has_version "=llvm-core/llvm-17*" ; then
		LLVM_SLOT=17
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.3*" && has_version "=llvm-core/clang-18*" && has_version "=llvm-core/llvm-18*" ; then
		LLVM_SLOT=18
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" && has_version "=llvm-core/clang-15*" && has_version "=llvm-core/llvm-15*" ; then
		LLVM_SLOT=15
	else
eerror
eerror "Only the following parings are supported for tests:"
eerror
eerror "CUDA 12.9, CLANG + LLVM 21 (live)"
eerror "CUDA 12.8, CLANG + LLVM 20"
eerror "CUDA 12.6, CLANG + LLVM 19"
eerror "CUDA 12.3, CLANG + LLVM 18"
eerror "CUDA 12.3, CLANG + LLVM 17"
eerror "CUDA 11.8, CLANG + LLVM 15"
eerror
		die
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
		-DADDRESS_SANITIZER=$(usex asan)
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
	dodir "/opt/rocm/libexec/hipify"
	dodir "/opt/rocm/include/hipify"
	dodir "/opt/rocm/bin"
	dodir "/opt/rocm/hip/bin"
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-STATUS:  needs install test
