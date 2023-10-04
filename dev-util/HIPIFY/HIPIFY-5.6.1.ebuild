# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake llvm rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/HIPIFY/"
	inherit git-r3
else
	SRC_URI="
https://github.com/ROCm-Developer-Tools/HIPIFY/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
fi

DESCRIPTION="HIPIFY: Convert CUDA to Portable C++ Code"
HOMEPAGE="https://github.com/RadeonOpenCompute/HIPIFY"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="system-llvm test r7"
gen_llvm_rdepend() {
	local s="${1}"
	echo "
		(
			system-llvm? (
				~sys-devel/llvm-${s}
				~sys-devel/clang-${s}
			)
		)
	"
}
# https://github.com/ROCm-Developer-Tools/HIPIFY/blob/rocm-5.6.1/docs/hipify-clang.md#hipify-clang-dependencies
TEST_BDEPEND="
	|| (
		(
			=dev-util/nvidia-cuda-toolkit-12.1*:=
			|| (
				$(gen_llvm_rdepend 17.0.0.9999)
				$(gen_llvm_rdepend 16.0.3)
				$(gen_llvm_rdepend 16.0.2)
				$(gen_llvm_rdepend 16.0.1)
				$(gen_llvm_rdepend 16.0.0)
			)
		)
		(
			=dev-util/nvidia-cuda-toolkit-11.8*:=
			|| (
				$(gen_llvm_rdepend 15.0.7)
				$(gen_llvm_rdepend 15.0.6)
				$(gen_llvm_rdepend 15.0.5)
				$(gen_llvm_rdepend 15.0.4)
				$(gen_llvm_rdepend 15.0.3)
				$(gen_llvm_rdepend 15.0.2)
				$(gen_llvm_rdepend 15.0.1)
				$(gen_llvm_rdepend 15.0.0)
				$(gen_llvm_rdepend 14.0.6)
				$(gen_llvm_rdepend 14.0.5)
			)
		)
		(
			=dev-util/nvidia-cuda-toolkit-11.7*:=
			|| (
				$(gen_llvm_rdepend 14.0.4)
				$(gen_llvm_rdepend 14.0.3)
				$(gen_llvm_rdepend 14.0.2)
				$(gen_llvm_rdepend 14.0.1)
				$(gen_llvm_rdepend 14.0.0)
			)
		)
		(
			=dev-util/nvidia-cuda-toolkit-11.5*:=
			|| (
				$(gen_llvm_rdepend 13.0.1)
				$(gen_llvm_rdepend 13.0.0)
			)
		)
	)
"
RDEPEND="
	dev-util/hip-compiler[system-llvm=]
	!test? (
		!system-llvm? (
			~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
		)
		system-llvm? (
			sys-devel/llvm:${LLVM_MAX_SLOT}
			sys-devel/clang:${LLVM_MAX_SLOT}
		)
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	!test? (
		!system-llvm? (
			~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
		)
		system-llvm? (
			sys-devel/llvm:${LLVM_MAX_SLOT}
			sys-devel/clang:${LLVM_MAX_SLOT}
		)
	)
	test? (
		${TEST_BDEPEND}
	)
	>=dev-util/cmake-3.16.8
"
RESTRICT="
	test
"
PATCHES=(
	"${FILESDIR}/HIPIFY-5.6.1-llvm-dynlib-on.patch"
	"${FILESDIR}/HIPIFY-5.6.0-path-changes.patch"
	"${FILESDIR}/HIPIFY-5.6.1-install-headers-option.patch"
)

pkg_setup() {
	if ! use test ; then
		:;
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.1*" && has_version "=sys-devel/clang-17*" && has_version "=sys-devel/llvm-17*" ; then
		LLVM_MAX_VERSION=17
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.1*" && has_version "=sys-devel/clang-16*" && has_version "=sys-devel/llvm-16*" ; then
		LLVM_MAX_VERSION=16
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" && has_version "=sys-devel/clang-15*" && has_version "=sys-devel/llvm-15*" ; then
		LLVM_MAX_VERSION=15
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" && has_version "=sys-devel/clang-14*" && has_version "=sys-devel/llvm-14*" ; then
		LLVM_MAX_VERSION=14
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.7*" && has_version "=sys-devel/clang-14*" && has_version "=sys-devel/llvm-14*" ; then
		LLVM_MAX_VERSION=14
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.5*" && has_version "=sys-devel/clang-13*" && has_version "=sys-devel/llvm-13*" ; then
		LLVM_MAX_VERSION=13
	fi
	llvm_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	if use system-llvm ; then
		export CC="${CHOST}-clang-${LLVM_SLOT}"
		export CXX="${CHOST}-clang++-${LLVM_SLOT}"
	else
		export CC="clang"
		export CXX="clang++"
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DUSE_SYSTEM_LLVM=$(usex system-llvm)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
