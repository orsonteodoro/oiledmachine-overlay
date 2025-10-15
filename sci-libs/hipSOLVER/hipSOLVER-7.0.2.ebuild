# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

HIP_SUPPORT_CUDA=1
LLVM_SLOT=19
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake edo flag-o-matic rocm toolchain-funcs

# Some test datasets are shared with rocSPARSE.
KEYWORDS="~amd64"
S="${WORKDIR}/hipSOLVER-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipSOLVER/archive/refs/tags/rocm-${PV}.tar.gz
	-> hipSOLVER-${PV}.tar.gz
"

DESCRIPTION="ROCm SOLVER marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipSOLVER"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	MIT
"
# all-rights-reserved MIT - CMakeLists.txt
# MIT - LICENSE.md
# The distro's MIT license template does not have all rights reserved.
SLOT="0/${ROCM_SLOT}"
IUSE="asan test cuda +rocm ebuild_revision_7"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
	^^ (
		rocm
		cuda
	)
"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	>=dev-util/hip-${PV}:${SLOT}[cuda?,rocm?]
	dev-util/hip:=
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	rocm? (
		>=sci-libs/rocBLAS-${PV}:${SLOT}[rocm]
		sci-libs/rocBLAS:=
		>=sci-libs/rocSOLVER-${PV}:${SLOT}[rocm(+)]
		sci-libs/rocSOLVER:=

		>=dev-util/rocm-smi-${PV}:${SLOT}
		dev-util/rocm-smi:=
	)
	virtual/blas
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.7
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
	test? (
		dev-cpp/gtest
	)
"
PATCHES=(
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_ADDRESS_SANITIZER=$(usex asan ON OFF)
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DCMAKE_INSTALL_INCLUDEDIR="include"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DUSE_CUDA=$(usex cuda ON OFF)
	)

	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi
	rocm_set_default_hipcc
	rocm_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	edob "./${PN,,}-test"
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-META:  ebuild needs test
