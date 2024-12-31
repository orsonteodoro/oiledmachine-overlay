# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=17
MY_PN="TransferBench"
MY_PV="1.50" # Based on filename and major-minor version compatibility
ROCM_SLOT="6.1"
inherit hip-versions
ROCM_VERSION="${HIP_6_1_VERSION}"

inherit cmake rocm

if [[ ${PV} == *"9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ROCm/TransferBench.git"
	FALLBACK_COMMIT="v${MY_PV}"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
	SRC_URI="
https://github.com/ROCm/TransferBench/archive/refs/tags/v${MY_PV}.tar.gz
	-> ${MY_PN}-${MY_PV}.tar.gz
	"
fi

DESCRIPTION="TransferBench is a utility capable of benchmarking simultaneous \
copies between user-specified devices (CPUs/GPUs)"
HOMEPAGE="https://github.com/ROCm/TransferBench"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not contain all rights reserved.
SLOT="${ROCM_SLOT}/${PV}"
IUSE+=" cuda rocm ebuild_revision_0"
REQUIRED_USE+="
	|| (
		cuda
		rocm
	)
"
RDEPEND="
	sys-process/numactl
	~dev-util/hip-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.5.0
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	~dev-util/hip-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-1.46-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_hipcc
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)

	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DBUILD_WITH_TENSILE=OFF
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DCMAKE_CXX_COMPILER="hipcc"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi

	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_fix_rpath
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
