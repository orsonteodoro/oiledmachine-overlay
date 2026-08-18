# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22
# Requirements:
# HIP: https://github.com/ggml-org/whisper.cpp/blob/v1.7.6/ggml/src/ggml-hip/CMakeLists.txt#L49
# CUDA:  https://github.com/ggml-org/whisper.cpp/blob/v1.7.6/.github/workflows/build.yml#L772
#        https://github.com/ggml-org/whisper.cpp/blob/v1.7.6/ggml/src/ggml-cuda/CMakeLists.txt#L8

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

CXX_STANDARD=17

inherit hip-versions
ROCM_VERSIONS=(
	"${HIP_7_2_VERSION}"
)

# Placeholder, TODO review
AMDGPU_TARGETS_COMPAT=(
	"gfx908"
	"gfx90a"
	"gfx942"
	"gfx1030"
	"gfx1100"
	"gfx1101"
	"gfx1200"
	"gfx1201"
)

# See https://github.com/ROCm/rocm-install-on-linux/blob/rocm-7.2.0/docs/reference/system-requirements.rst
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
	"cpu_flags_loong_lasx"
	"cpu_flags_loong_lsx"
)

CPU_FLAGS_RISCV=(
	"cpu_flags_riscv_v"
	"cpu_flags_riscv_xtheadvector"
	"cpu_flags_riscv_zfh"
)

CPU_FLAGS_S390=(
	"cpu_flags_s390_nnpa"
	"cpu_flags_s390_vxe"
)

CPU_FLAGS_X86=(
	"cpu_flags_x86_amx_bf16"
	"cpu_flags_x86_amx_int8"
	"cpu_flags_x86_amx_tile"
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512bf16"
	"cpu_flags_x86_avx512bw"
	"cpu_flags_x86_avx512cd"
	"cpu_flags_x86_avx512dq"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_avx512vbmi"
	"cpu_flags_x86_avx512vl"
	"cpu_flags_x86_avx512vnni"
	"cpu_flags_x86_avxvnni"
	"cpu_flags_x86_bmi2"
	"cpu_flags_x86_f16c"
	"cpu_flags_x86_fma"
	"cpu_flags_x86_sse4_2"
)

gen_rocm_iuse() {
	local pv
	for pv in "${ROCM_VERSIONS[@]}" ; do
		local s="${pv%.*}"
		s="${pv/./_}"
		echo "
			rocm_${s}
		"
	done
}
ROCM_IUSE=(
	$(gen_rocm_iuse)
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMP=(
	"media-libs/libsdl2-9999"
	"media-video/ffmpeg-9999"
	"media-video/ffmpeg-9999m"
	"sci-libs/openblas-9999"
	"sci-ml/openvino-9999"
)

inherit check-compiler-switch chkl cmake flag-o-matic libcxx-slot libstdcxx-slot secure-version rocm

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
video_cards_intel
ebuild_revision_7
"
gen_rocm_required_use() {
	local pv
	for pv in "${ROCM_VERSIONS[@]}" ; do
		local s="${pv%.*}"
		s="${s/./_}"
		echo "
			rocm_${s}? (
				rocm
			)
		"
	done
}
gen_cuda_required_use() {
	local x
	for x in "${CUDA_TARGETS_COMPAT[@]}" ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
gen_rocm_required_use() {
	local x
	for x in "${AMDGPU_TARGETS_COMPAT[@]}" ; do
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

	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_bmi2? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_fma? (
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
		cpu_flags_x86_f16c
		cpu_flags_x86_fma
	)

	cpu_flags_x86_avxvnni? (
		cpu_flags_x86_avx2
	)

	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512cd
	)
	cpu_flags_x86_avx512cd? (
		cpu_flags_x86_avx512f
	)

	cpu_flags_x86_avx512bw? (
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
	)

	cpu_flags_x86_avx512vnni? (
		cpu_flags_x86_avx512bw
	)

	cpu_flags_x86_avx512bf16? (
		cpu_flags_x86_avx512vnni
	)

	cpu_flags_x86_avx512vbmi? (
		cpu_flags_x86_avx512bw
	)

	cpu_flags_x86_amx_bf16? (
		cpu_flags_x86_avxvnni
		cpu_flags_x86_amx_int8
		cpu_flags_x86_amx_tile
		cpu_flags_x86_avx512vbmi
		cpu_flags_x86_avx512bf16
	)
	cpu_flags_x86_amx_int8? (
		cpu_flags_x86_avxvnni
		cpu_flags_x86_amx_bf16
		cpu_flags_x86_amx_tile
		cpu_flags_x86_avx512vbmi
		cpu_flags_x86_avx512bf16
	)
	cpu_flags_x86_amx_tile? (
		cpu_flags_x86_avxvnni
		cpu_flags_x86_amx_bf16
		cpu_flags_x86_amx_int8
		cpu_flags_x86_avx512vbmi
		cpu_flags_x86_avx512bf16
	)

	cpu_flags_riscv_xtheadvector? (
		cpu_flags_riscv_v
	)
	cpu_flags_riscv_zfh? (
		cpu_flags_riscv_v
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
	local pv
	for pv in "${ROCM_VERSIONS[@]}" ; do
		local s="0/${pv}"
		local u="rocm_${pv/./_}"
		local ROCM_SLOT="${pv%.*}"
		echo "
			${u}? (
				~dev-libs/rocm-comgr-${pv}:=
				~dev-libs/rocr-runtime-${pv}:=
				~dev-util/hip-${pv}:=[lc,rocm]
				~sci-libs/hipBLAS-${pv}:=[rocm]
				~sci-libs/rocBLAS-${pv}:=[$(get_rocm_usedep ROCBLAS)]
				~sys-devel/llvm-roc-${pv}:=[llvm_targets_AMDGPU,llvm_targets_X86]
			)
		"
	done
}
RDEPEND="
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
		|| (
			=dev-util/nvidia-cuda-toolkit-11.8*
			=dev-util/nvidia-cuda-toolkit-12.4*
		)
	)
	ffmpeg? (
		$(secure-version_gen_ffmpeg_depends)
	)
	openblas? (
		>=sci-libs/openblas-${OPENBLAS_PV}:=
	)
	opencl? (
		>=sci-libs/clblast-2.12:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	openvino? (
		>=sci-ml/openvino-${OPENVINO_PV}:=
	)
	rocm? (
		$(gen_rocm_rdepend)
	)
	sdl2? (
		>=media-libs/libsdl2-${LIBSDL2_PV}:=
	)
	vulkan? (
		>=media-libs/vulkan-loader-${VULKAN_PV}:=
	)
"
DEPEND="
	vulkan? (
		>=dev-util/vulkan-headers-${VULKAN_PV}:=
	)
"
BDEPEND="
	>=dev-build/cmake-3.5
"
DOCS=( "AUTHORS" "README.md" )

pkg_setup() {
	check-compiler-switch_start
	if use rocm ; then
		if use rocm_7_2 ; then
			export LLVM_SLOT=22
			export ROCM_SLOT="7.2"
			export ROCM_VERSION="${HIP_7_2_VERSION}"
		fi
		rocm_pkg_setup
	fi
	if use cuda ; then
		export CC="${CHOST}-gcc"
		export CXX="${CHOST}-g++"
		export CPP="${CXX} -E"
	fi
	if use openvino ; then
		CONFIG_CHECK="~DRM_ACCEL_IVPU ~DRM ~DRM_ACCEL ~PCI ~PCI_MSI"
		WARNING_DRM_ACCEL_IVPU="Missing NPU support with CONFIG_DRM_ACCEL_IVPU"
		linux-info_pkg_setup
	fi
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	chkl_check_many_timestamps
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
		-DGGML_SYCL=NO
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
		-DGGML_RVV=$(usex cpu_flags_riscv_v)
		-DGGML_RV_ZFH=$(usex cpu_flags_riscv_zfh)
		-DGGML_SSE42=$(usex cpu_flags_x86_sse4_2)
		-DGGML_VXE=$(use cpu_flags_s390_vxe)
		-DGGML_XTHEADVECTOR=$(usex cpu_flags_riscv_xtheadvector)
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
