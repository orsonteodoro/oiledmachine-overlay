# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx908
	gfx90a
	gfx90a_xnack_plus # with asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx950
	gfx950_xnack_plus # with asan
)
HIP_SUPPORT_CUDA=1
LLVM_SLOT=19
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipTensor/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
"

DESCRIPTION="AMD’s C++ library for accelerating tensor primitives"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipTensor"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not contain all rights reserved.
SLOT="0/${ROCM_SLOT}"
# Upstream enables samples
# Upstream enables test
IUSE="
asan cuda +rocm -samples -test
ebuild_revision_5
"
gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_rocm_required_use)
	${ROCM_REQUIRED_USE}
	rocm? (
		${ROCM_REQUIRED_USE}
	)
	^^ (
		cuda
		rocm
	)
"
RESTRICT="
	test
"
RDEPEND="
	>=dev-util/hip-${PV}:${SLOT}[rocm]
	dev-util/hip:=
	>=sci-libs/composable-kernel-${PV}:${SLOT}[${COMPOSABLE_KERNEL_7_0_AMDGPU_USEDEP}]
	sci-libs/composable-kernel:=
	cuda? (
		${HIP_CUDA_DEPEND}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.14
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
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

check_asan() {
	local ASAN_GPUS=(
		"gfx90a_xnack_plus"
		"gfx942_xnack_plus"
		"gfx950_xnack_plus"
	)
	local found=0
	local x
	for x in ${ASAN_GPUS[@]} ; do
		if use "amdgpu_targets_${x}" ; then
			found=1
		fi
	done
	if (( ${found} == 0 )) && use asan ; then
ewarn "ASan security mitigations for GPU are disabled."
ewarn "ASan is enabled for CPU HOST side but not GPU side for both older and newer GPUs."
ewarn "Pick one of the following for GPU side ASan:  ${ASAN_GPUS[@]/#/amdgpu_targets_}"
	fi
}

src_configure() {
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"

	# For reduced memory usage during build.
	replace-flags '-O0' '-O2'
	replace-flags '-O0' '-O2'

	check_asan

	if use asan ; then
		export ADDRESS_SANITIZER="-fsanitize=address -shared-libasan"
	else
		unset ADDRESS_SANITIZER
	fi
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DHIPTENSOR_BUILD_TESTS=$(usex test ON OFF)
		-DHIPTENSOR_BUILD_SAMPLES=$(usex samples ON OFF)
	)

	if use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
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
	MAKEOPTS="-j1" \
	cmake_src_test
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
