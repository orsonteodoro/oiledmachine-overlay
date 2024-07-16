# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx940
	gfx941
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
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
HIPRAND_COMMIT="b7b91006d19c84cb742c75f19157ece72ab8f9ca"
LLVM_SLOT=17
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/rocRAND-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/${PN}/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/ROCmSoftwarePlatform/hipRAND/archive/${HIPRAND_COMMIT}.tar.gz
	-> hipRAND-${HIPRAND_COMMIT}.tar.gz
"

DESCRIPTION="Generate pseudo-random and quasi-random numbers"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"
LICENSE="MIT"
RESTRICT="
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
benchmark cuda hip-cpu +rocm test ebuild-revision-8
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
	~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	hip-cpu? (
		${HIP_CLANG_DEPEND}
		dev-libs/hip-cpu
	)
"
DEPEND="
	${RDEPEND}
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	test? (
		dev-cpp/gtest
	)
"
BDEPEND="
	>=dev-build/cmake-3.10.2
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	!hip-cpu? (
		${HIPCC_DEPEND}
	)
	hip-cpu? (
		${HIP_CLANG_DEPEND}
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.5.1-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	rmdir hipRAND || die
	mv -v \
		../hipRAND-${HIPRAND_COMMIT} \
		hipRAND \
		|| die

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

src_configure() {
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"
	local mycmakeargs=(
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
			-DBUILD_HIPRAND=ON
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
			-DBUILD_HIPRAND=OFF
			-Dhip_cpu_rt_DIR="${ESYSROOT}/usr/lib/hip-cpu/share/hip_cpu_rt/cmake"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DBUILD_HIPRAND=ON
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
