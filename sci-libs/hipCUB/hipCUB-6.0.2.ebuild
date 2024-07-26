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
HIP_SUPPORT_CUDA=1
LLVM_SLOT=17
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake rocm

KEYWORDS="~amd64"
S="${WORKDIR}/hipCUB-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipCUB/archive/rocm-${PV}.tar.gz
	-> hipCUB-${PV}.tar.gz
"

DESCRIPTION="Wrapper of rocPRIM or CUB for GPU parallel primitives"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipCUB"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	BSD
	MIT
"
# The distro MIT license template does not have All rights reserved.
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
benchmark cuda +rocm test ebuild-revision-7
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
	${ROCM_REQUIRED_USE}
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
	)
"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	benchmark? (
		dev-cpp/benchmark
	)
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	rocm? (
		~sci-libs/rocPRIM-${PV}:${ROCM_SLOT}[${ROCPRIM_6_0_AMDGPU_USEDEP},rocm?]
	)
	test? (
		dev-cpp/gtest
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.16
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-4.3.0-add-memory-header.patch"
	"${FILESDIR}/${PN}-6.0.2-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	# Disabled downloading googletest and googlebenchmark
	sed -r \
		-e '/Downloading/{:a;N;/\n *\)$/!ba; d}' \
		-i \
		cmake/Dependencies.cmake \
		|| die

	# Removed the GIT dependency
	sed -r \
		-e '/find_package\(Git/{:a;N;/\nendif/!ba; d}' \
		-i \
		cmake/Dependencies.cmake \
		|| die

	if use benchmark ; then
		sed \
			-e "/get_filename_component/s,\${BENCHMARK_SOURCE},${PN}_\${BENCHMARK_SOURCE}," \
			-e "/add_executable/a\  install(TARGETS \${BENCHMARK_TARGET})" \
			-i \
			benchmark/CMakeLists.txt \
			|| die
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
		-DBUILD_TEST=$(usex test ON OFF)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)

	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
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
	elif use rocm ; then
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
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
