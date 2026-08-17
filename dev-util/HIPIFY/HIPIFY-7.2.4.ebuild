# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Requirements:
# https://github.com/ROCm/HIPIFY/blob/rocm-7.0.2/docs/how-to/hipify-clang.rst
# https://github.com/ROCm/HIPIFY/blob/rocm-7.0.2/src/Statistics.h

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
asan cuda test
ebuild_revision_20
"
CUDA_12_6_CDEPEND="
	(
		(
			>=dev-libs/cudnn-8.8.0
			<dev-libs/cudnn-9.12.0
		)
		>=x11-drivers/nvidia-drivers-560.35
		=dev-util/nvidia-cuda-toolkit-12.6*
		virtual/cuda-compiler:0/12.6
	)
"
CUDA_12_8_CDEPEND="
	(
		(
			>=dev-libs/cudnn-8.8.0
			<dev-libs/cudnn-9.12.0
		)
		>=x11-drivers/nvidia-drivers-570.124
		=dev-util/nvidia-cuda-toolkit-12.8*
		virtual/cuda-compiler:0/12.8
	)
"
CUDA_12_9_CDEPEND="
	(
		(
			>=dev-libs/cudnn-8.8.0
			<dev-libs/cudnn-9.12.0
		)
		>=x11-drivers/nvidia-drivers-575.57
		=dev-util/nvidia-cuda-toolkit-12.9*
		virtual/cuda-compiler:0/12.9
	)
"
RDEPEND="
	!test? (
		${ROCM_CLANG_DEPEND}
	)
	cuda? (
		|| (
			${CUDA_12_9_CDEPEND}
			${CUDA_12_8_CDEPEND}
			${CUDA_12_6_CDEPEND}
		)
		virtual/cuda-compiler:=
		dev-util/nvidia-cuda-toolkit:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	test? (
		|| (
			${CUDA_12_9_CDEPEND}
			${CUDA_12_8_CDEPEND}
			${CUDA_12_6_CDEPEND}
		)
		virtual/cuda-compiler:=
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
# The ROCm LLVM requirement is not aligned with maximum allowed by CUDA's LLVM requirement.
ewarn "None of the configurations for CUDA - LLVM available pairings are supported by upstream."
	if ! use test ; then
		:
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.9*" ; then
		local x
		for x in {16..19} ; do
			if has_version "=llvm-core/clang-${x}*" && has_version "=llvm-core/llvm-${x}*" ; then
				LLVM_SLOT=${x}
				break
			fi
		done
		[[ -z "${LLVM_SLOT}" ]] && die "Only Clang/LLVM 16-19 supported"
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.8*" ; then
		local x
		for x in {16..19} ; do
			if has_version "=llvm-core/clang-${x}*" && has_version "=llvm-core/llvm-${x}*" ; then
				LLVM_SLOT=${x}
				break
			fi
		done
		[[ -z "${LLVM_SLOT}" ]] && die "Only Clang/LLVM 16-19 supported"
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.6*" ; then
		local x
		for x in {16..18} ; do
			if has_version "=llvm-core/clang-${x}*" && has_version "=llvm-core/llvm-${x}*" ; then
				LLVM_SLOT=${x}
				break
			fi
		done
		[[ -z "${LLVM_SLOT}" ]] && die "Only Clang/LLVM 16-19 supported"
	else
eerror
eerror "Only the following parings are supported for tests:"
eerror
eerror "CUDA 12.9, CLANG + LLVM 16-19"
eerror "CUDA 12.8, CLANG + LLVM 16-19"
eerror "CUDA 12.6, CLANG + LLVM 16-18"
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
