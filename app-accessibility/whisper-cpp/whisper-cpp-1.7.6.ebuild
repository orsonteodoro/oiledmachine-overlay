# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22
# Requirements:
# HIP: https://github.com/ggml-org/whisper.cpp/blob/v1.7.6/ggml/src/ggml-hip/CMakeLists.txt#L49
# CUDA:  https://github.com/ggml-org/whisper.cpp/blob/v1.7.6/.github/workflows/build.yml#L772
#        https://github.com/ggml-org/whisper.cpp/blob/v1.7.6/ggml/src/ggml-cuda/CMakeLists.txt#L8

inherit check-compiler-switch cmake flag-o-matic rocm

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

# See https://github.com/ROCm/rocm-install-on-linux/blob/docs/6.2.4/docs/reference/system-requirements.rst
AMDGPU_TARGETS_COMPAT=(
	"gfx906"
	"gfx908"
	"gfx90a"
	"gfx942"
	"gfx1100"
	"gfx1030"
)
CUDA_TARGETS_COMPAT=(
	"sm_50"
	"sm_60"
	"sm_61"
	"sm_70"
	"sm_75"
	"sm_80"
	"sm_86"
	"sm_89"
)
CPU_FLAGS_LOONG=(
	"cpu_flags_loong_lsx"
	"cpu_flags_loong_lasx"
)
CPU_FLAGS_RISCV=(
	"cpu_flags_riscv_rvv"
	"cpu_flags_riscv_xthreadvector"
	"cpu_flags_riscv_zfh"
)
CPU_FLAGS_S390=(
	"cpu_flags_s390_nnpa"
	"cpu_flags_s390_vxe"
)
CPU_FLAGS_X86=(
	"cpu_flags_x86_sse4_2"
	"cpu_flags_x86_bmi2"
	"cpu_flags_x86_f16c"
	"cpu_flags_x86_fma"
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512dq"
	"cpu_flags_x86_avx512cd"
	"cpu_flags_x86_avx512dq"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_avx512vl"
	"cpu_flags_x86_avx512bf16"
	"cpu_flags_x86_avx512vbmi"
	"cpu_flags_x86_avx512vnni"
	"cpu_flags_x86_avxvnni"
	"cpu_flags_x86_avxvnniint8"
	"cpu_flags_x86_amx"
	"cpu_flags_x86_amx_tile"
	"cpu_flags_x86_amx_int8"
	"cpu_flags_x86_amx_bf16"
)
ROCM_SLOTS=(
	# 5.5 minimum
	"6.2"
)
gen_rocm_iuse() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		echo "
			rocm_${s/./_}
		"
	done
}
ROCM_IUSE=( $(gen_rocm_iuse) )
inherit hip-versions
declare -A ROCM_VERSIONS=(
	["6_2"]="${HIP_6_2_VERSION}"
)

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_P}"
SRC_URI="https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz"

DESCRIPTION="Port of OpenAI's Whisper model in C/C++ "
HOMEPAGE="https://github.com/ggml-org/whisper.cpp"
LICENSE="MIT"
SLOT="0"
IUSE="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
${CPU_FLAGS_LOONG[@]}
${CPU_FLAGS_RISCV[@]}
${CPU_FLAGS_S390[@]}
${CPU_FLAGS_X86[@]}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_IUSE[@]}
+cpu -cuda -cuda-f16 -ffmpeg -mkl -openblas -opencl -openvino -rocm -sdl2 -vulkan
ebuild_revision_1
"
gen_rocm_required_use() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		echo "
			rocm_${s/./_}? (
				rocm
			)
		"
	done
}
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
	?? (
		${ROCM_IUSE[@]}
	)
	?? (
		cpu
		cuda
		mkl
		openblas
		rocm
		openvino
	)

	cpu_flags_x86_avx2? (
		cpu_flags_x86_bmi2
	)

	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_2
	)

	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
		cpu_flags_x86_bmi2
		cpu_flags_x86_fma
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_bmi2? (
		cpu_flags_x86_avx
		cpu_flags_x86_avx2
		cpu_flags_x86_fma
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_fma? (
		cpu_flags_x86_avx
		cpu_flags_x86_avx2
		cpu_flags_x86_bmi2
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_avx
		cpu_flags_x86_avx2
		cpu_flags_x86_bmi2
		cpu_flags_x86_fma
	)

	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512cd? (
		cpu_flags_x86_avx2
		cpu_flags_x86_sse4_2
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
	)

	cpu_flags_x86_amx_bf16? (
		cpu_flags_x86_avxvnni
		cpu_flags_x86_amx_int8
		cpu_flags_x86_amx_tile
		cpu_flags_x86_avx512vbmi
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_avx512bf16
	)
	cpu_flags_x86_amx_int8? (
		cpu_flags_x86_avxvnni
		cpu_flags_x86_amx_bf16
		cpu_flags_x86_amx_tile
		cpu_flags_x86_avx512vbmi
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_avx512bf16
	)
	cpu_flags_x86_amx_tile? (
		cpu_flags_x86_avxvnni
		cpu_flags_x86_amx_bf16
		cpu_flags_x86_amx_int8
		cpu_flags_x86_avx512vbmi
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_avx512bf16
	)
	cpu_flags_x86_avx512bf16? (
		cpu_flags_x86_avxvnni
		cpu_flags_x86_amx_bf16
		cpu_flags_x86_amx_int8
		cpu_flags_x86_amx_tile
		cpu_flags_x86_avx512vbmi
		cpu_flags_x86_avx512vnni
	)
	cpu_flags_x86_avx512vbmi? (
		cpu_flags_x86_avxvnni
		cpu_flags_x86_amx_bf16
		cpu_flags_x86_amx_int8
		cpu_flags_x86_amx_tile
		cpu_flags_x86_avx512bf16
		cpu_flags_x86_avx512vnni
	)
	cpu_flags_x86_avx512vnni? (
		cpu_flags_x86_avxvnni
		cpu_flags_x86_amx_bf16
		cpu_flags_x86_amx_int8
		cpu_flags_x86_amx_tile
		cpu_flags_x86_avx512bf16
		cpu_flags_x86_avx512vbmi
	)

	cpu_flags_riscv_xthreadvector? (
		cpu_flags_riscv_rvv
	)
	cpu_flags_riscv_zfh? (
		cpu_flags_riscv_rvv
	)

	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	rocm? (
		|| (
			${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
		)
	)
"
gen_rocm_rdepend() {
	# DEPENDs listed in llama/llama.go
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s1="${s/./_}"
		local gcc_slot="HIP_${s1}_GCC_SLOT"
		echo "
			rocm_${s/./_}? (
				~dev-libs/rocm-comgr-${ROCM_VERSIONS[${s1}]}:${s}
				~dev-libs/rocr-runtime-${ROCM_VERSIONS[${s1}]}:${s}
				~dev-util/hip-${ROCM_VERSIONS[${s1}]}:${s}[lc,rocm]
				~sci-libs/hipBLAS-${ROCM_VERSIONS[${s1}]}:${s}[rocm]
				~sci-libs/rocBLAS-${ROCM_VERSIONS[${s1}]}:${s}$(get_rocm_usedep ROCBLAS)
				~sys-devel/llvm-roc-${ROCM_VERSIONS[${s1}]}:${s}[llvm_targets_AMDGPU,llvm_targets_X86]
			)
		"
	done
}
RDEPEND="
	cuda? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11.8*
			=dev-util/nvidia-cuda-toolkit-12.4*
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	ffmpeg? (
		>=media-video/ffmpeg-4.4.2
	)
	openblas? (
		>=sci-libs/openblas-0.3.20
	)
	opencl? (
		>=sci-libs/clblast-2.12
		sci-libs/clblast:=
	)
	openvino? (
		sci-ml/openvino:=
	)
	rocm? (
		$(gen_rocm_rdepend)
	)
	sdl2? (
		>=media-libs/libsdl2-2.0.20
		media-libs/libsdl2:=
	)
	vulkan? (
		>=media-libs/vulkan-loader-1.3.204.1
	)
"
DEPEND="
	vulkan? (
		>=dev-util/vulkan-headers-1.3.204.1
	)
"
BDEPEND="
	>=dev-build/cmake-3.5
"
DOCS=( "AUTHORS" "README.md" "README_sycl.md" )

pkg_setup() {
	check-compiler-switch_start
	if use rocm ; then
		if use rocm_6_2 ; then
			export ROCM_SLOT="6.2"
			export LLVM_SLOT=18
			export ROCM_VERSION="${HIP_6_2_VERSION}"
		fi
		rocm_pkg_setup
	fi
	if use cuda ; then
		if has_version "=dev-util/nvidia-cuda-toolkit-11.8*" ; then
			export CC="${CHOST}-gcc-11"
			export CXX="${CHOST}-g++-11"
			export CPP="${CXX} -E"
		elif has_version "=dev-util/nvidia-cuda-toolkit-12.4*" ; then
			export CC="${CHOST}-gcc-13"
			export CXX="${CHOST}-g++-13"
			export CPP="${CXX} -E"
		fi
	fi
}

src_configure() {
	strip-unsupported-flags

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	# Note: CUDA and HIP are currently untested. Build failures may occur.
	# Turning off examples causes errors during configure
	# -DWHISPER_BUILD_TESTS=$(usex test)
	export AMDGPU_TARGETS="$(get_amdgpu_flags)"
	local mycmakeargs=(
		-DWHISPER_BUILD_EXAMPLES=ON
		-DGGML_CLBLAST=$(usex opencl)
		-DGGML_CPU=$(usex cpu)
		-DGGML_CUBLAS=$(usex cuda)
		-DGGML_HIPBLAS=$(usex rocm)
		-DGGML_SYCL=OFF
		-DGGML_VULKAN=$(usex vulkan)
		-DWHISPER_FFMPEG=$(usex ffmpeg)
		-DWHISPER_SDL2=$(usex sdl2)

	# CPU/GPU Optimizations
		-DGGML_AMX_BF16=$(usex cpu_flags_x86_amx_bf16)
		-DGGML_AMX_INT8=$(usex cpu_flags_x86_amx_int8)
		-DGGML_AMX_TILE=$(usex cpu_flags_x86_amx_tile)
		-DGGML_AVX=$(usex cpu_flags_x86_avx)
		-DGGML_AVX_VNNI=$(usex cpu_flags_x86_avxvnni)
		-DGGML_AVX2=$(usex cpu_flags_x86_avx2)
		-DGGML_AVX512=$(usex cpu_flags_x86_avx512f)
		-DGGML_AVX512_BF16=$(usex cpu_flags_x86_avx512bf16)
		-DGGML_AVX512_VBMI=$(usex cpu_flags_x86_avx512vbmi)
		-DGGML_AVX512_VNNI=$(usex cpu_flags_x86_avx512vnni)
		-DGGML_BMI2=$(usex cpu_flags_x86_bmi2)
		-DGGML_CUDA_F16=$(usex cuda-f16)
		-DGGML_F16C=$(usex cpu_flags_x86_f16c)
		-DGGML_FMA=$(usex cpu_flags_x86_fma)
		-DGGML_LASX=$(usex cpu_flags_loong_lasx)
		-DGGML_LSX=$(usex cpu_flags_loong_lsx)
		-DGGML_NNPA=$(usex cpu_flags_s390_nnpa)
		-DGGML_RVV=$(usex cpu_flags_riscv_rvv)
		-DGGML_RV_ZFH=$(usex cpu_flags_riscv_zfh)
		-DGGML_SSE42=$(usex cpu_flags_x86_sse4_2)
		-DGGML_VXE=$(use cpu_flags_s390_vxe)
		-DGGML_XTHEADVECTOR=$(usex cpu_flags_riscv_xthreadvector)
	)
	if use mkl ; then
		mycmakeargs+=(
			-DGGML_BLAS=ON
			-DGGML_BLAS_VENDOR="Intel"
		)
	elif use openblas ; then
		mycmakeargs+=(
			-DGGML_BLAS=ON
			-DGGML_BLAS_VENDOR="OpenBLAS"
		)
	else
		mycmakeargs+=(
			-DGGML_BLAS=OFF
		)
	fi

	if is-flagq "-march=native" ; then
		mycmakeargs+=(
			-DGGML_NATIVE=ON
		)
	else
		mycmakeargs+=(
			-DGGML_NATIVE=OFF
		)
	fi
	filter-flags "-march=*"

	if is-flagq "-flto*" ; then
		mycmakeargs+=(
			-DGGML_LTO=ON
		)
	else
		mycmakeargs+=(
			-DGGML_LTO=OFF
		)
	fi
	filter-lto

	cmake_src_configure
}
