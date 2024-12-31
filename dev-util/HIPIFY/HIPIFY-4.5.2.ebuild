# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=13
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
# https://github.com/ROCm-Developer-Tools/HIPIFY/tree/rocm-4.5.2#-hipify-clang-dependencies
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
			=dev-util/nvidia-cuda-toolkit-11.5*
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	>=dev-build/cmake-3.8
"
RESTRICT="
	test
"
PATCHES=(
	"${FILESDIR}/${PN}-4.5.2-hardcoded-paths.patch"
)

pkg_setup() {
	if ! use test ; then
		:
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
	dodir "/opt/rocm-${PV}/hip/bin"
	mv \
		"${ED}/opt/rocm-${PV}/include/" \
		"${ED}/opt/rocm-${PV}/hip/bin/" \
		|| die
	mv \
		"${ED}/opt/rocm-${PV}/hipify-clang" \
		"${ED}/opt/rocm-${PV}/hip/bin" \
		|| die
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
