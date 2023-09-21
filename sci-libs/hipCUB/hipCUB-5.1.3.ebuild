# Copyright 1999-2022 Gentoo Authors
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
LLVM_MAX_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake llvm rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipCUB/archive/rocm-${PV}.tar.gz
	-> hipCUB-${PV}.tar.gz
"

DESCRIPTION="Wrapper of rocPRIM or CUB for GPU parallel primitives"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipCUB"
LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
benchmark cuda +rocm system-llvm test
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
	dev-util/hip-compiler[system-llvm=]
	~dev-util/hip-${PV}:${SLOT}[cuda?,rocm?]
	benchmark? (
		dev-cpp/benchmark
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	rocm? (
		~sci-libs/rocPRIM-${PV}:${SLOT}[${ROCM_USEDEP},rocm?]
	)
	test? (
		dev-cpp/gtest
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.16
	~dev-util/rocm-cmake-${PV}:${SLOT}
"
S="${WORKDIR}/hipCUB-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-4.3.0-add-memory-header.patch"
	"${FILESDIR}/${PN}-5.1.3-path-changes.patch"
)

pkg_setup() {
	llvm_pkg_setup
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
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)
		-DBUILD_TEST=$(usex test ON OFF)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)

	if use cuda ; then
		local s=11
		strip-flags
		filter-flags \
			-pipe \
			-Wl,-O1 \
			-Wl,--as-needed \
			-Wno-unknown-pragmas
		if [[ "${HIP_CXX}" == "nvcc" ]] ; then
			append-cxxflags -ccbin "${EPREFIX}/usr/${CHOST}/gcc-bin/${s}/${CHOST}-g++"
		fi
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
		export HIP_CLANG_PATH="${ESYSROOT}/${ROCM_LLVM_PATH}/bin"
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi

	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"
	cmake_src_configure
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

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
