# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=16
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
# The distro's MIT license template does not contain all rights reserved.
SLOT="${ROCM_SLOT}/${PV}"
IUSE="test ebuild_revision_15"
# https://github.com/ROCm-Developer-Tools/HIPIFY/tree/rocm-5.5.1#-hipify-clang-dependencies
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
			=dev-util/nvidia-cuda-toolkit-12.0*
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
	"${FILESDIR}/${PN}-5.3.3-hardcoded-paths.patch"
)

pkg_setup() {
	if ! use test ; then
		:
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.0*" && has_version "=llvm-core/clang-17*" && has_version "=llvm-core/llvm-17*" ; then
ewarn "CUDA 12 support is experimental"
		LLVM_SLOT=17
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" && has_version "=llvm-core/clang-15*" && has_version "=llvm-core/llvm-15*" ; then
		LLVM_SLOT=15
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" && has_version "=llvm-core/clang-14*" && has_version "=llvm-core/llvm-14*" ; then
		LLVM_SLOT=14
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.7*" && has_version "=llvm-core/clang-14*" && has_version "=llvm-core/llvm-14*" ; then
		LLVM_SLOT=14
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.5*" && has_version "=llvm-core/clang-13*" && has_version "=llvm-core/llvm-13*" ; then
		LLVM_SLOT=13
	fi
	if has_version "=dev-util/nvidia-cuda-toolkit-12.0*" ; then
ewarn "CUDA 12 is experimental."
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

# Fixes:
#HipifyAction.cpp:736:34: error: no type named 'OptionalFileEntryRef' in namespace 'clang'
#                          clang::OptionalFileEntryRef file,
#                          ~~~~~~~^
		-DSWDEV_375013=ON
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
		"${ED}/opt/rocm-${PV}/findcode.sh" \
		"${ED}/opt/rocm-${PV}/finduncodep.sh" \
		"${ED}/opt/rocm-${PV}/libexec/hipify" \
		|| die
	mv \
		"${ED}/opt/rocm-${PV}/"*".sh" \
		"${ED}/opt/rocm-${PV}/hipify-clang" \
		"${ED}/opt/rocm-${PV}/hipify-perl" \
		"${ED}/opt/rocm-${PV}/bin" \
		|| die
	local pairs=(
		"libexec/hipify/findcode.sh:hip/bin/findcode.sh"
		"libexec/hipify/finduncodep.sh:hip/bin/finduncodep.sh"
		"bin/hipconvertinplace-perl.sh:hip/bin/hipconvertinplace-perl.sh"
		"bin/hipconvertinplace.sh:hip/bin/hipconvertinplace.sh"
		"bin/hipexamine-perl.sh:hip/bin/hipexamine-perl.sh"
		"bin/hipexamine.sh:hip/bin/hipexamine.sh"
		"bin/hipify-clang:hip/bin/hipify-clang"
		"bin/hipify-perl:hip/bin/hipify-perl"
	)
	local pair
	for pair in ${pairs[@]} ; do
		local src="${pair%:*}"
		local dest="${pair#*:}"
		dosym \
			"/opt/rocm-${PV}/${src}" \
			"/opt/rocm-${PV}/${dest}"
	done
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
