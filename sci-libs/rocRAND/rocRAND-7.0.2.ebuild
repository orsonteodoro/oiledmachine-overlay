# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx908_xnack_plus # with asan
	gfx90a_xnack_minus
	gfx90a_xnack_plus # with or without asan
	gfx942
	gfx942_xnack_plus # with asan
	gfx950
	gfx950_xnack_plus # with asan
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
CUDA_TARGETS_COMPAT=(
	auto

# Same as rocFFT
	sm_60
	sm_70
	sm_75
	compute_60
	compute_70
	compute_75
)
HIP_SUPPORT_CUDA=1
LLVM_SLOT=19
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/rocRAND-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/${PN}/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Generate pseudo-random and quasi-random numbers"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's license template does not have All rights reserved.
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/${ROCM_SLOT}"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
asan benchmark cuda hip-cpu +rocm test ebuild_revision_13
"
gen_cuda_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
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
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	rocm? (
		${ROCM_REQUIRED_USE}
	)
	^^ (
		rocm
		cuda
		hip-cpu
	)
"
RDEPEND="
	>=dev-util/hip-${PV}:${SLOT}[cuda?,rocm?]
	dev-util/hip:=
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	hip-cpu? (
		${HIP_CLANG_DEPEND}
		dev-libs/hip-cpu
	)
"
DEPEND="
	${RDEPEND}
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
	test? (
		dev-cpp/gtest
	)
"
BDEPEND="
	>=dev-build/cmake-3.10.2
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
	!hip-cpu? (
		${HIPCC_DEPEND}
	)
	hip-cpu? (
		${HIP_CLANG_DEPEND}
	)
"
PATCHES=(
)

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
}

src_prepare() {
	# Removed the GIT dependency.
	sed \
		-e "/find_package(Git/,+4d" \
		-i \
		cmake/Dependencies.cmake \
		|| die

	if use cuda ; then
		local badflags=(
			"-Wno-unknown-pragmas"
			"-Wall"
			"-Wextra"
		)
		local
		for flag in ${badflags[@]} ; do
			sed -i \
				-e "s|${flag}||g" \
				$(grep -l -r -e "${flag}" "${WORKDIR}") \
				|| die
		done
	fi

	cmake_src_prepare
	rocm_src_prepare
}

get_nvgpu_targets() {
	local list
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		if use cuda_targets_${x} ; then
			list+=";${x#*_}"
		fi
	done
	list="${list:1}"
	echo "${list}"
}

check_asan() {
	local ASAN_GPUS=(
		"gfx908_xnack_plus"
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
	check_asan
	local mycmakeargs=(
		-DBUILD_ADDRESS_SANITIZER=$(usex asan)
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)

	# Fixes:
	# rocrand.cpp:1904:16: error: use of undeclared identifier 'ROCRAND_VERSION'
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF

		-DBUILD_TEST=$(usex test ON OFF)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_SKIP_RPATH=ON
		-DUSE_HIP_CPU=$(usex hip-cpu ON OFF)
	)

	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DDISABLE_WERROR=ON
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
		if use cuda_targets_auto ; then
			mycmakeargs+=(
			)
		else
			mycmakeargs+=(
				-DNVGPU_TARGETS=$(get_nvgpu_targets)
			)
		fi
	elif use hip-cpu ; then
# Error with gcc-11, gcc-12
#during IPA pass: simdclone
#/var/tmp/portage/sci-libs/rocRAND-5.6.0/work/rocRAND-rocm-5.6.0/library/src/rocrand.cpp:2042:1: internal compiler error: Floating point exception
		mycmakeargs+=(
			-Dhip_cpu_rt_DIR="${ESYSROOT}/usr/lib/hip-cpu/share/hip_cpu_rt/cmake"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi
	if use hip-cpu ; then
		rocm_set_default_clang
	else
		rocm_set_default_hipcc
	fi

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

	rocm_src_configure
}

src_test() {
	check_amdgpu
	export LD_LIBRARY_PATH="${BUILD_DIR}/library"
	MAKEOPTS="-j1" \
	cmake_src_test
}

src_install() {
	cmake_src_install
	if use benchmark; then
		cd "${BUILD_DIR}/benchmark"
		dobin "benchmark_rocrand_"*
	fi
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
