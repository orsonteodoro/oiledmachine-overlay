# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This package is a misnomer.  This is the non-python portions of pytorch.

# TODO package:
# ComputeLibrary

# For requirements, see
# https://github.com/pytorch/pytorch/blob/v2.0.1/RELEASE.md?plain=1#L45
# https://github.com/pytorch/pytorch/tree/v1.13.1/third_party
# https://github.com/pytorch/pytorch/blob/v1.13.1/.circleci/docker/common/install_rocm_magma.sh#L9 for magma

AMDGPU_TARGETS_COMPAT=(
# Based on rocm_agent_enumerator
	gfx700
	gfx701
	gfx801
	gfx802
	gfx803
	gfx900
	gfx902
	gfx904
	gfx906
	gfx908
	gfx90a
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1013
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
)
AMDGPU_TARGETS_UNTESTED=(
# Based on https://github.com/pytorch/pytorch/blob/v1.13.1/.jenkins/pytorch/build.sh
	gfx700
	gfx701
	gfx801
	gfx802
	gfx803
	gfx900
	gfx902
	gfx904
#	gfx906
	gfx908
	gfx90a
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1013
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
)
ASMJIT_COMMIT="d3fbf7c9bc7c1d1365a94a45614b91c5a3706b81" # fbgemm dep
BENCHMARK_COMMIT_1="0d98dba29d66e93259db7daa53a9327df767a415"
BENCHMARK_COMMIT_2="5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8" # protobuf dep
BENCHMARK_COMMIT_3="0d98dba29d66e93259db7daa53a9327df767a415" # onnx dep
BENCHMARK_COMMIT_4="e776aa0275e293707b6a0901e0e8d8a8a3679508" # onnx-tensorrt/third_party/onnx dep
CLANG_CINDEX_PYTHON3_COMMIT="6a00cbc4a9b8e68b71caf7f774b3f9c753ae84d5" # onnx-tensorrt/third_party/onnx/third_party/pybind11 dep
GCC_SLOTS=( {15..7} ) # Upstream uses 7
CPU_FLAGS_ARM=(
	cpu_flags_arm_dotprod
	cpu_flags_arm_fp16
	cpu_flags_arm_neon
	cpu_flags_arm_sve
)
CPU_FLAGS_PPC=(
	cpu_flags_ppc_vsx
	cpu_flags_ppc_vsx3
)
CPU_FLAGS_RISCV=(
	cpu_flags_riscv_rvv
)
CPU_FLAGS_S390=(
	cpu_flags_s390_vxe_z14
	cpu_flags_s390_vxe_z15
	cpu_flags_s390_zvector
)
CPU_FLAGS_X86=(
	cpu_flags_x86_amx
	cpu_flags_x86_avx
	cpu_flags_x86_avx2
	cpu_flags_x86_avx512bw
	cpu_flags_x86_avx512dq
	cpu_flags_x86_avx512f
	cpu_flags_x86_avx512vbmi
	cpu_flags_x86_avx512vl
	cpu_flags_x86_f16c
	cpu_flags_x86_fma
	cpu_flags_x86_fma4
	cpu_flags_x86_sse2
	cpu_flags_x86_sse4_1
)
CPUINFO_COMMIT_1="8ec7bd91ad0470e61cf38f618cc1f270dede599c"
CPUINFO_COMMIT_2="ed8b86a253800bafdb7b25c5c399f91bff9cb1f3" # fbgemm dep
# CUDA 12 not supported yet: https://github.com/pytorch/pytorch/issues/91122
CUDA_TARGETS_COMPAT=(
# Builds for all cards
	auto

# Observed:
#	sm_35 # Dropped based on RELEASE.md:  Release Compatibility Matrix
	sm_52
	sm_60
	sm_61
	sm_70
	sm_75
	sm_80
	sm_86
	compute_50
	compute_70
)
CUB_COMMIT="d106ddb991a56c3df1b6d51b2409e36ba8181ce4"
CUDNN_FRONTEND_COMMIT="171a7a986f7fbd9ed71bd0cf3c7ad4f55843d6b3"
CUTLASS_COMMIT_1="b72cbf957df8cf84a6d0ff91c190ad51a9c1d24a"
GLOO_COMMIT="5b143513263133af2b95547e97c07cebeb72bf72"
GOOGLETEST_COMMIT_1="6f3f9a9e617c0571356f74821944b13f54233f1c" # gloo dep ; committer-date:<=2022-05-18
GOOGLETEST_COMMIT_2="5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081" # protobuf dep
GOOGLETEST_COMMIT_3="86add13493e5c881d7e4ba77fb91c1f57752b3a4" # kineto dep ; committer-date:<=2022-06-19
# No dynolog
GOOGLETEST_COMMIT_5="cbf019de22c8dd37b2108da35b2748fd702d1796" # fbgemm dep
GOOGLETEST_COMMIT_6="aee0f9d9b5b87796ee8a0ab26b7587ec30e8858e" # tensorpipe dep
IDEEP_COMMIT="77d662b313a762e82b389d3fd965e0098f12cd99"
IOS_CMAKE_COMMIT="8abaed637d56f1337d6e1d2c4026e25c1eade724"
FBGEMM_COMMIT="0d98c261561524cce92e37fe307ea6596664309a"
FFMPEG_COMPAT=(
	"0/55.57.57" # 3.4 (U18 dockerfile)
	"0/54.56.56" # 2.8 (U16 docs)
	"0/52.54.54" # 1.2 (U14 docs)
)
FLATBUFFERS_COMMIT="d0cede9c90c5257537c293517a21376408b549fa"
FMT_COMMIT_1="cd4af11efc9c622896a3e4cb599fa28668ca3d05"
FMT_COMMIT_2="568233889171e0ee91bf28879b1482b038e84cc2" # kineto dep ; committer-date:<=2022-06-19
FOXI_COMMIT="c278588e34e535f0bb8f00df3880d26928038cad"
FP16_COMMIT="4dfe081cf6bcd15db339cf2680b9281b8451eeb3"
FXDIV_COMMIT="b408327ac2a15ec3e43352421954f5b1967701d1"
EIGEN_COMMIT="3147391d946bb4b6c68edd901f2add6ac1f31f8c"
HIPIFY_TORCH_COMMIT="1840658c184f3eeba787dae0f06c45756c1daaf5" # fbgemm dep
ITTAPI_COMMIT="5b8a7d7422611c3a0d799fb5fc5dd4abfae35b42"
KINETO_COMMIT="0703c78999061b8329dfab7ec5046fc5764a5573"
LIBNOP_COMMIT="910b55815be16109f04f4180e9adee14fb4ce281" # tensorpipe dep
LIBUV_COMMIT="1dff88e5161cba5c59276d2070d2e304e4dcb242" # tensorpipe dep
LLVM_COMPAT=(
	14 # ROCm slot
	12 10 9 8 7 5 # Upstream build.sh, pull.yml
)
LLVM_COMPAT_ARM_DOTPROD=(
	14
	12 10 9 8 7
)
LLVM_COMPAT_S390_Z15=(
	14
	12 10
)
LLVM_COMPAT_X86_AMX=(
	14
	12
)
MKL_DNN_COMMIT="888a87a954e4fddb4d81fd10858eb834f2441b46"
MYPN="pytorch"
MYP="${MYPN}-${PV}"
NEON2SSE_COMMIT="97a126f08ce318023be604d03f88bf0820a9464a"
NLOHMANN_COMMIT_1="87cda1d6646592ac5866dc703c8e1839046a6806"
NNPACK_COMMIT="c07e3a0400713d546e0dea2d5466dd22ea389c73"
ONNX_COMMIT_1="f7ee1ac60d06abe8e26c9b6bbe1e3db5286b614b"
ONNX_COMMIT_2="765f5ee823a67a866f4bd28a9860e81f3c811ce8" # onnx-tensorrt dep
ONNX_TENSORRT_COMMIT="c153211418a7c57ce071d9ce2a41f8d1c85a878f"
PEACHPY_COMMIT="f45429b087dd7d5bc78bb40dc7cf06425c252d67"
POCKETFFT_COMMIT="ea778e37710c07723435b1be58235996d1d43a5a"
PROTOBUF_COMMIT="d1eca4e4b421cd2997495c4b4e65cea6be4e9b8a"
PSIMD_COMMIT="072586a71b55b7f8c584153d223e95687148a900"
PTHREADPOOL_COMMIT="a134dd5d4cee80cce15db81a72e7f929d71dd413"
PYBIND11_COMMIT_1="aa304c9c7d725ffb9d10af08a3b34cb372307020"
PYBIND11_COMMIT_2="ffa346860b306c9bbfb341aed9c14c067751feb8" # onnx dep
PYBIND11_COMMIT_3="a1041190c8b8ff0cd9e2f0752248ad5e3789ea0c" # onnx-tensorrt/third_party/onnx dep
PYBIND11_COMMIT_4="a23996fce38ff6ccfbcdc09f1e63f2c4be5ea2ef" # tensorpipe dep
PYTHON_COMPAT=( python3_10 ) # Upstream only allows <=3.10
PYTHON_ENUM_COMMIT="4cfedc426c4e2fc52e3f5c2b4297e15ed8d6b8c7"
PYTHON_SIX_COMMIT="15e31431af97e5e64b80af0a3f598d382bcdd49a"
QNNPACK_COMMIT="7d2a4e9931a82adc3814275b6219a03e24e36b4c"
inherit hip-versions
ROCM_SLOTS=(
# See https://github.com/pytorch/pytorch/blob/v1.13.1/.github/workflows/trunk.yml
	"${HIP_5_2_VERSION}"
)
gen_rocm_slots() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s="${s%.*}"
		s="${s/./_}"
		echo "rocm_${s}"
	done
}
ROCM_SLOTS2=( $(gen_rocm_slots) )
SLEEF_COMMIT="e0a003ee838b75d11763aa9c3ef17bf71a725bff"
TBB_COMMIT="a51a90bc609bb73db8ea13841b5cf7aa4344d4a9"
TENSORPIPE_COMMIT="52791a2fd214b2a9dc5759d36725909c1daa7f2e"
VULKANMEMORYALLOCATOR_COMMIT="a6bfc237255a6bac1513f7c1ebde6d8aed6b5191"
XNNPACK_COMMIT="ae108ef49aa5623b896fc93d4298c49d1750d9ba"
ZSTD_COMMIT="aec56a52fbab207fc639a1937d1e708a282edca8"


inherit cmake cuda dep-prepare dhms flag-o-matic llvm rocm python-single-r1 toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}/${MYP}"
SRC_URI="
https://github.com/pytorch/${MYPN}/archive/refs/tags/v${PV}.tar.gz
	-> ${MYP}.tar.gz
	!system-libs? (
https://github.com/asmjit/asmjit/archive/${ASMJIT_COMMIT}.tar.gz
	-> asmjit-${ASMJIT_COMMIT:0:7}.tar.gz
https://github.com/benjaminp/six/archive/${PYTHON_SIX_COMMIT}.tar.gz
	-> benjaminp-six-${PYTHON_SIX_COMMIT:0:7}.tar.gz
https://github.com/facebook/zstd/archive/${ZSTD_COMMIT}.tar.gz
	-> zstd-${ZSTD_COMMIT:0:7}.tar.gz
https://github.com/facebookincubator/gloo/archive/${GLOO_COMMIT}.tar.gz
	-> gloo-${GLOO_COMMIT:0:7}.tar.gz
https://github.com/fmtlib/fmt/archive/${FMT_COMMIT_1}.tar.gz
	-> fmt-${FMT_COMMIT_1:0:7}.tar.gz
https://github.com/fmtlib/fmt/archive/${FMT_COMMIT_2}.tar.gz
	-> fmt-${FMT_COMMIT_2:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_1}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_1:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_2}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_2:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_3}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_3:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_4}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_4:0:7}.tar.gz
https://github.com/google/flatbuffers/archive/${FLATBUFFERS_COMMIT}.tar.gz
	-> flatbuffers-${FLATBUFFERS_COMMIT:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_1}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_1:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_2}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_2:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_3}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_3:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_5}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_5:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_6}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_6:0:7}.tar.gz
https://github.com/google/libnop/archive/${LIBNOP_COMMIT}.tar.gz
	-> libnop-${LIBNOP_COMMIT:0:7}.tar.gz
https://github.com/google/XNNPACK/archive/${XNNPACK_COMMIT}.tar.gz
	-> XNNPACK-${XNNPACK_COMMIT:0:7}.tar.gz
https://github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/archive/${VULKANMEMORYALLOCATOR_COMMIT}.tar.gz
	-> VulkanMemoryAllocator-${VULKANMEMORYALLOCATOR_COMMIT:0:7}.tar.gz
https://github.com/houseroad/foxi/archive/${FOXI_COMMIT}.tar.gz
	-> foxi-${FOXI_COMMIT:0:7}.tar.gz
https://github.com/intel/ARM_NEON_2_x86_SSE/archive/${NEON2SSE_COMMIT}.tar.gz
	-> ARM_NEON_2_x86_SSE-${NEON2SSE_COMMIT:0:7}.tar.gz
https://github.com/intel/ideep/archive/${IDEEP_COMMIT}.tar.gz
	-> ideep-${IDEEP_COMMIT:0:7}.tar.gz
https://github.com/intel/ittapi/archive/${ITTAPI_COMMIT}.tar.gz
	-> ittapi-${ITTAPI_COMMIT:0:7}.tar.gz
https://github.com/libuv/libuv/archive/${LIBUV_COMMIT}.tar.gz
	-> libuv-${LIBUV_COMMIT:0:7}.tar.gz
https://github.com/malfet/PeachPy/archive/${PEACHPY_COMMIT}.tar.gz
	-> PeachPy-${PEACHPY_COMMIT:0:7}.tar.gz
https://github.com/Maratyszcza/FP16/archive/${FP16_COMMIT}.tar.gz
	-> FP16-${FP16_COMMIT:0:7}.tar.gz
https://github.com/Maratyszcza/FXdiv/archive/${FXDIV_COMMIT}.tar.gz
	-> FXDIV-${FXDIV_COMMIT:0:7}.tar.gz
https://github.com/Maratyszcza/NNPACK/archive/${NNPACK_COMMIT}.tar.gz
	-> NNPACK-${NNPACK_COMMIT:0:7}.tar.gz
https://github.com/Maratyszcza/psimd/archive/${PSIMD_COMMIT}.tar.gz
	-> psimd-${PSIMD_COMMIT:0:7}.tar.gz
https://github.com/Maratyszcza/pthreadpool/archive/${PTHREADPOOL_COMMIT}.tar.gz
	-> pthreadpool-${PTHREADPOOL_COMMIT:0:7}.tar.gz
https://github.com/mreineck/pocketfft/archive/${POCKETFFT_COMMIT}.tar.gz
	-> pocketfft-${POCKETFFT_COMMIT:0:7}.tar.gz
https://github.com/nlohmann/json/archive/${NLOHMANN_COMMIT_1}.tar.gz
	-> nlohmann-json-${NLOHMANN_COMMIT_1:0:7}.tar.gz
https://github.com/NVIDIA/cudnn-frontend/archive/${CUDNN_FRONTEND_COMMIT}.tar.gz
	-> cudnn-frontend-${CUDNN_FRONTEND_COMMIT:0:7}.tar.gz
https://github.com/NVIDIA/cutlass/archive/${CUTLASS_COMMIT_1}.tar.gz
	-> cutlass-${CUTLASS_COMMIT_1:0:7}.tar.gz
https://github.com/NVlabs/cub/archive/${CUB_COMMIT}.tar.gz
	-> cub-${CUB_COMMIT:0:7}.tar.gz
https://github.com/oneapi-src/oneDNN/archive/${MKL_DNN_COMMIT}.tar.gz
	-> oneDNN-${MKL_DNN_COMMIT:0:7}.tar.gz
https://github.com/oneapi-src/oneTBB/archive/${TBB_COMMIT}.tar.gz
	-> oneTBB-${TBB_COMMIT:0:7}.tar.gz
https://github.com/onnx/onnx-tensorrt/archive/${ONNX_TENSORRT_COMMIT}.tar.gz
	-> onnx-tensorrt-${ONNX_TENSORRT_COMMIT:0:7}.tar.gz
https://github.com/onnx/onnx/archive/${ONNX_COMMIT_1}.tar.gz
	-> onnx-${ONNX_COMMIT_1:0:7}.tar.gz
https://github.com/onnx/onnx/archive/${ONNX_COMMIT_2}.tar.gz
	-> onnx-${ONNX_COMMIT_2:0:7}.tar.gz
https://github.com/PeachPy/enum34/archive/${PYTHON_ENUM_COMMIT}.tar.gz
	-> PeachPy-enum34-${PYTHON_ENUM_COMMIT:0:7}.tar.gz
https://github.com/protocolbuffers/protobuf/archive/${PROTOBUF_COMMIT}.tar.gz
	-> protobuf-${PROTOBUF_COMMIT:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_1}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_1:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_2}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_2:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_3}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_3:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_4}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_4:0:7}.tar.gz
https://github.com/pytorch/cpuinfo/archive/${CPUINFO_COMMIT_1}.tar.gz
	-> pytorch-cpuinfo-${CPUINFO_COMMIT_1:0:7}.tar.gz
https://github.com/pytorch/cpuinfo/archive/${CPUINFO_COMMIT_2}.tar.gz
	-> pytorch-cpuinfo-${CPUINFO_COMMIT_2:0:7}.tar.gz
https://github.com/pytorch/FBGEMM/archive/${FBGEMM_COMMIT}.tar.gz
	-> FBGEMM-${FBGEMM_COMMIT:0:7}.tar.gz
https://github.com/pytorch/kineto/archive/${KINETO_COMMIT}.tar.gz
	-> kineto-${KINETO_COMMIT:0:7}.tar.gz
https://github.com/pytorch/QNNPACK/archive/${QNNPACK_COMMIT}.tar.gz
	-> QNNPACK-${QNNPACK_COMMIT:0:7}.tar.gz
https://github.com/pytorch/tensorpipe/archive/${TENSORPIPE_COMMIT}.tar.gz
	-> tensorpipe-${TENSORPIPE_COMMIT:0:7}.tar.gz
https://github.com/ROCm/hipify_torch/archive/${HIPIFY_TORCH_COMMIT}.tar.gz
	-> hipify_torch-${HIPIFY_TORCH_COMMIT:0:7}.tar.gz
https://github.com/shibatch/sleef/archive/${SLEEF_COMMIT}.tar.gz
	-> sleef-${SLEEF_COMMIT:0:7}.tar.gz
https://github.com/wjakob/clang-cindex-python3/archive/${CLANG_CINDEX_PYTHON3_COMMIT}.tar.gz
	-> clang-cindex-python3-${CLANG_CINDEX_PYTHON3_COMMIT:0:7}.tar.gz
https://github.com/Yangqing/ios-cmake/archive/${IOS_CMAKE_COMMIT}.tar.gz
	-> ios-cmake-${IOS_CMAKE_COMMIT:0:7}.tar.gz
https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_COMMIT}/eigen-${EIGEN_COMMIT}.tar.gz
	-> eigen-${EIGEN_COMMIT:0:7}.tar.gz
	)
"

DESCRIPTION="A deep learning framework"
HOMEPAGE="https://pytorch.org/"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	(
		BSD
		ISC
		MIT
	)
	(
		CC0-1.0
		MIT
	)
	(
		MPL-2
		LGPL-3.0+
		GPL-2.0+
	)
	(
		custom
		BSD
	)
	(
		BSD-2
		custom
	)
	(
		custom
		MIT
	)
	Apache-2.0
	Boost-1.0
	BSD
	BSD-2
	CC-BY-4.0
	PSF-3.3.0
	UoI-NCSA
	Unlicense
	ZLIB
"
# ( BSD-2 custom ) Apache-2.0 Boost-1.0 BSD - NOTICE
# all-rights-reserved MIT - third_party/miniz-2.1.0/LICENSE
# Apache-2.0 - third_party/tensorpipe/third_party/googletest/googlemock/scripts/generator/LICENSE
# Apache-2.0 Boost-1.0 BSD BSD-2 MIT - third_party/LICENSES_BUNDLED.txt
# BSD - test/distributed/pipeline/sync/LICENSE
# BSD - LICENSE
# BSD-2 - aten/src/ATen/native/quantized/cpu/qnnpack/deps/clog/LICENSE
# Boost-1.0 third_party/sleef/LICENSE.txt
# BSD-2 BSD ISC MIT - third_party/tensorpipe/third_party/libuv/LICENSE
# CC-BY-4.0 - third_party/tensorpipe/third_party/libuv/LICENSE-docs
# CC0-1.0 MIT - third_party/nlohmann/docs/mkdocs/docs/home/license.md
# custom MIT - third_party/kineto/third_party/fmt/LICENSE.rst
# custom BSD - ./third_party/onnx-tensorrt/third_party/onnx/third_party/pybind11/LICENSE
# custom BSD-2 - ./third_party/neon2sse/LICENSE
# MIT - third_party/psimd/LICENSE
# MPL-2.0 LGPL-3+ GPL-2+ - third_party/eigen/scripts/relicense.py
# PSF-3.3.0 - third_party/kineto/third_party/fmt/doc/python-license.txt
# Unlicense - caffe2/mobile/contrib/libopencl-stub/LICENSE
# UoI-NCSA - third_party/tensorpipe/third_party/pybind11/tools/clang/LICENSE.TXT
# UoI-NCSA - ,third_party/onnx-tensorrt/third_party/onnx/third_party/pybind11/tools/clang/LICENSE.TXT
# ZLIB - third_party/FBGEMM/third_party/asmjit/LICENSE.md
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="test"
SLOT="0"
# cuda and rocm are enabled by default upstream.
IUSE="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_PPC[@]}
${CPU_FLAGS_RISCV[@]}
${CPU_FLAGS_S390[@]}
${CPU_FLAGS_X86[@]}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_IUSE}
${ROCM_SLOTS2[@]}
clang cuda +distributed +eigen +fbgemm -ffmpeg +flash-attention +gloo -jit +kineto +magma
-mkl +mpi +nccl +nnpack +numpy +onednn -openblas -opencl -opencv +openmp +rccl rocm
roctracer -ssl system-libs +tensorpipe +qnnpack test +xnnpack
ebuild_revision_8
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
REQUIRED_USE_AVX512="
	cpu_flags_x86_avx512bw
	cpu_flags_x86_avx512dq
	cpu_flags_x86_avx512f
	cpu_flags_x86_avx512vl
"
# For libtorch_python.so: undefined symbol: _ZTIN5torch2nn6ModuleE see issue #60341
# clang breaks with python 3.10
REQUIRED_USE="
	!clang
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	${PYTHON_REQUIRED_USE}
	?? (
		cuda
		rocm
	)
	arm? (
		cpu_flags_arm_neon
	)
	clang? (
		|| (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
		cpu_flags_arm_dotprod? (
			|| (
				${LLVM_COMPAT_ARM_DOTPROD[@]/#/llvm_slot_}
			)
		)
		cpu_flags_s390_vxe_z15? (
			|| (
				${LLVM_COMPAT_S390_Z15[@]/#/llvm_slot_}
			)
		)
		cpu_flags_x86_amx? (
			|| (
				${LLVM_COMPAT_X86_AMX[@]/#/llvm_slot_}
			)
		)
		cpu_flags_x86_avx512vbmi? (
			|| (
				${LLVM_COMPAT[@]/#/llvm_slot_}
			)
		)
	)
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_1
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
		cpu_flags_x86_f16c
		cpu_flags_x86_fma
	)
	cpu_flags_x86_avx512bw? (
		${REQUIRED_USE_AVX512}
	)
	cpu_flags_x86_avx512dq? (
		${REQUIRED_USE_AVX512}
	)
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
	)
	cpu_flags_x86_avx512vbmi? (
		${REQUIRED_USE_AVX512}
	)
	cpu_flags_x86_avx512vl? (
		${REQUIRED_USE_AVX512}
	)
	cpu_flags_x86_sse4_1? (
		cpu_flags_x86_sse2
	)
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	distributed? (
		|| (
			gloo
			mpi
			nccl
			rccl
			tensorpipe
		)
	)
	fbgemm? (
		${REQUIRED_USE_AVX512}
		cpu_flags_x86_avx2
		openmp
	)
	ffmpeg? (
		opencv
	)
	flash-attention? (
		cuda? (
			|| (
				cuda_targets_sm_80
			)
		)
	)
	gloo? (
		distributed
	)
	magma? (
		^^ (
			cuda
			rocm
		)
	)
	mpi? (
		distributed
	)
	nccl? (
		distributed
	)
	onednn? (
		|| (
			(
				${REQUIRED_USE_AVX512}
			)
			cpu_flags_x86_amx
			cpu_flags_x86_avx2
			cpu_flags_x86_sse4_1
		)
	)
	qnnpack? (
		amd64? (
			cpu_flags_x86_sse2
		)
		arm? (
			cpu_flags_arm_neon
		)
		arm64? (
			cpu_flags_arm_neon
		)
		x86? (
			cpu_flags_x86_sse2
		)
	)
	rccl? (
		distributed
	)
	rocm? (
		${ROCM_REQUIRED_USE}
		^^ (
			${ROCM_SLOTS2[@]}
		)
	)
	rocm_5_2? (
		llvm_slot_14
	)
	tensorpipe? (
		distributed
	)
	xnnpack? (
		arm64? (
			cpu_flags_arm_dotprod
			cpu_flags_arm_fp16
		)
	)
"
gen_rocm_depends() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local s=$(ver_cut 1-2 ${pv})
		local u="${s}"
		u="${u/./_}"
		echo "
			rocm_${u}? (
				~dev-libs/rocm-comgr-${pv}:${s}
				~dev-libs/rocr-runtime-${pv}:${s}
				~dev-util/hip-${pv}:${s}[rocm]
				~sci-libs/hipCUB-${pv}:${s}[rocm]
				~sci-libs/hipRAND-${pv}:${s}[rocm]
				~sci-libs/hipSPARSE-${pv}:${s}[rocm]
				~sci-libs/hipFFT-${pv}:${s}[rocm]
				~sci-libs/miopen-${pv}:${s}$(get_rocm_usedep MIOPEN)
				~sci-libs/rocBLAS-${pv}:${s}$(get_rocm_usedep ROCBLAS)
				~sci-libs/rocFFT-${pv}:${s}$(get_rocm_usedep ROCFFT)
				~sci-libs/rocRAND-${pv}:${s}$(get_rocm_usedep ROCRAND)
				~sci-libs/rocPRIM-${pv}:${s}$(get_rocm_usedep ROCPRIM)
				~sci-libs/rocThrust-${pv}:${s}$(get_rocm_usedep ROCTHRUST)
				flash-attention? (
					sci-libs/aiotriton:${s}
				)
				magma? (
					=sci-libs/magma-2.6*:${s}$(get_rocm_usedep MAGMA_2_6)
				)
				openmp? (
					~dev-libs/llvm-roc-libomp-${pv}:${s}$(get_rocm_usedep LLVM_ROC_LIBOMP)
				)
				rccl? (
					~dev-libs/rccl-${pv}:${s}$(get_rocm_usedep RCCL)
				)
				roctracer? (
					~dev-util/roctracer-${pv}:${s}
				)
			)
		"
	done
}

gen_ffmpeg_depends() {
	echo "
		|| (
	"
	local s
	for s in ${FFMPEG_COMPAT[@]} ; do
		echo "
			media-video/ffmpeg:${s}
		"
	done
	echo "
		)
		media-video/ffmpeg:=
	"
}
CUDA_10_2_RDEPEND="
(
	=dev-util/nvidia-cuda-toolkit-10.2*:=[profiler]
	=dev-libs/cudnn-8.3*
)
"
CUDA_11_3_RDEPEND="
(
	=dev-util/nvidia-cuda-toolkit-11.3*:=[profiler]
	=dev-libs/cudnn-8.6*
)
"
CUDA_11_6_RDEPEND="
(
	=dev-util/nvidia-cuda-toolkit-11.6*:=[profiler]
	=dev-libs/cudnn-8.6*
)
"
CUDA_11_7_RDEPEND="
(
	=dev-util/nvidia-cuda-toolkit-11.7*:=[profiler]
	=dev-libs/cudnn-8.6*
)
"

RDEPEND="
	${PYTHON_DEPS}
	sci-libs/lapack
	cuda? (
		cuda_targets_auto? (
			|| (
				${CUDA_10_2_RDEPEND}
				${CUDA_11_3_RDEPEND}
				${CUDA_11_6_RDEPEND}
				${CUDA_11_7_RDEPEND}
			)
		)
		cuda_targets_compute_50? (
			|| (
				${CUDA_10_2_RDEPEND}
				${CUDA_11_3_RDEPEND}
				${CUDA_11_6_RDEPEND}
				${CUDA_11_7_RDEPEND}
			)
		)
		cuda_targets_compute_70? (
			|| (
				${CUDA_10_2_RDEPEND}
				${CUDA_11_3_RDEPEND}
				${CUDA_11_6_RDEPEND}
				${CUDA_11_7_RDEPEND}
			)
		)
		cuda_targets_sm_52? (
			|| (
				${CUDA_10_2_RDEPEND}
				${CUDA_11_3_RDEPEND}
				${CUDA_11_6_RDEPEND}
				${CUDA_11_7_RDEPEND}
			)
		)
		cuda_targets_sm_60? (
			|| (
				${CUDA_10_2_RDEPEND}
				${CUDA_11_3_RDEPEND}
				${CUDA_11_6_RDEPEND}
				${CUDA_11_7_RDEPEND}
			)
		)
		cuda_targets_sm_61? (
			|| (
				${CUDA_10_2_RDEPEND}
				${CUDA_11_3_RDEPEND}
				${CUDA_11_6_RDEPEND}
				${CUDA_11_7_RDEPEND}
			)
		)
		cuda_targets_sm_70? (
			|| (
				${CUDA_10_2_RDEPEND}
				${CUDA_11_3_RDEPEND}
				${CUDA_11_6_RDEPEND}
				${CUDA_11_7_RDEPEND}
			)
		)
		cuda_targets_sm_75? (
			|| (
				${CUDA_10_2_RDEPEND}
				${CUDA_11_3_RDEPEND}
				${CUDA_11_6_RDEPEND}
				${CUDA_11_7_RDEPEND}
			)
		)
		cuda_targets_sm_80? (
			|| (
				${CUDA_11_3_RDEPEND}
				${CUDA_11_6_RDEPEND}
				${CUDA_11_7_RDEPEND}
			)
		)
		cuda_targets_sm_86? (
			|| (
				${CUDA_11_3_RDEPEND}
				${CUDA_11_6_RDEPEND}
				${CUDA_11_7_RDEPEND}
			)
		)
		nccl? (
			dev-libs/nccl
		)
		dev-util/nvidia-cuda-toolkit:=
		dev-libs/cudnn:=
	)
	ffmpeg? (
		$(gen_ffmpeg_depends)
	)
	gloo? (
		ssl? (
			>=dev-libs/openssl-1.1
			dev-libs/openssl:=
		)
	)
	magma? (
		sci-libs/magma[cuda?,rocm?]
		sci-libs/magma:=
		cuda? (
			sci-libs/magma:0
		)
	)
	mpi? (
		sys-cluster/openmpi
	)
	numpy? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
	opencl? (
		virtual/opencl
	)
	opencv? (
		$(python_gen_cond_dep '
			media-libs/opencv:=[${PYTHON_USEDEP},python]
		')
	)
	rocm? (
		|| (
			$(gen_rocm_depends)
		)
	)
	system-libs? (
		(
			>=dev-cpp/gflags-2.2.2:=
			dev-cpp/gflags:=
		)
		>=dev-cpp/glog-0.4.0
		>=dev-libs/cpuinfo-2022.08.19
		>=dev-libs/libfmt-7.0.3
		>=dev-libs/protobuf-3.13.1:0/3.21
		>=dev-libs/pthreadpool-2021.04.13
		>=dev-libs/sleef-3.6.0[cpu_flags_x86_avx?,cpu_flags_x86_avx2?,cpu_flags_x86_avx512f?,cpu_flags_x86_fma4?,cpu_flags_x86_sse2?,cpu_flags_x86_sse4_1?]
		>=sci-libs/foxi-2021.05.26
		>=sci-libs/onnx-1.12.0
		cuda? (
			>=dev-libs/cudnn-frontend-0.7.1:0/8
		)
		fbgemm? (
			>=sci-libs/FBGEMM-2022.09.28
		)
		gloo? (
			>=sci-libs/gloo-0.5.0[cuda?,mpi?,ssl?]
		)
		mkl? (
			sci-libs/mkl
		)
		nnpack? (
			>=sci-libs/NNPACK-2020.12.21
		)
		onednn? (
			>=dev-libs/oneDNN-0.5.0
		)
		qnnpack? (
			>=sci-libs/QNNPACK-2019.08.28
		)
		tensorpipe? (
			>=sci-libs/tensorpipe-2021.12.27[cuda?]
		)
		xnnpack? (
			>=sci-libs/XNNPACK-2022.02.16[jit?,memopt,sparse]
			cpu_flags_arm_dotprod? (
				cpu_flags_arm_fp16? (
					>=sci-libs/XNNPACK-2022.02.16[assembly]
				)
			)
		)
	)
"
DEPEND="
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	${RDEPEND}
	system-libs? (
		$(python_gen_cond_dep '
			>=dev-python/pybind11-2.10.0[${PYTHON_USEDEP}]
		')
		>=dev-cpp/eigen-3.4.0
		>=dev-libs/flatbuffers-2.0.5
		>=dev-libs/FP16-2020.05.14
		>=dev-libs/FXdiv-2020.04.17
		>=dev-libs/pocketfft-2021.03.12
		>=dev-libs/psimd-2020.05.17
		>=sci-misc/kineto-0.4.0_p20220619
		cuda? (
			>=dev-libs/cutlass-2.10.0
		)
		onednn? (
			>=sci-libs/ideep-0.5.0
		)
	)
"
gen_clang() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/llvm:${s}
				llvm-core/clang:${s}
				llvm-core/lld:${s}
				openmp? (
					llvm-core/clang-runtime:${s}[openmp]
					=llvm-runtimes/openmp-${s}*
				)
			)
		"
	done
}
gen_gcc_bdepend() {
	local s
	for s in ${GCC_SLOTS[@]} ; do
		echo "
			=sys-devel/gcc-${s}*[openmp?]
		"
	done
}
BDEPEND="
	>=dev-build/cmake-3.18.0
	!clang? (
		|| (
			$(gen_gcc_bdepend)
		)
		cpu_flags_arm_dotprod? (
			>=sys-devel/gcc-8.1
			>=sys-devel/binutils-2.29
		)
		cpu_flags_arm_fp16? (
			>=sys-devel/gcc-7.1
			>=sys-devel/binutils-2.26
		)
		cpu_flags_arm_neon? (
			>=sys-devel/gcc-4.8
		)
		cpu_flags_arm_sve? (
			>=sys-devel/gcc-8.1
			>=sys-devel/binutils-2.28
		)
		cpu_flags_riscv_rvv? (
			>=sys-devel/gcc-14.1
			>=sys-devel/binutils-2.38
		)
		cpu_flags_s390_vxe_z14? (
			>=sys-devel/gcc-9.1
		)
		cpu_flags_s390_vxe_z15? (
			>=sys-devel/gcc-9.3
		)
		cpu_flags_s390_zvector? (
			>=sys-devel/gcc-5.2
		)
		cpu_flags_x86_avx512bw? (
			>=sys-devel/gcc-5.1
			>=sys-devel/binutils-2.25
		)
		cpu_flags_x86_avx512dq? (
			>=sys-devel/gcc-5.1
			>=sys-devel/binutils-2.25
		)
		cpu_flags_x86_avx512f? (
			>=sys-devel/gcc-4.9
			>=sys-devel/binutils-2.24
		)
		cpu_flags_x86_avx512vl? (
			>=sys-devel/gcc-5.1
			>=sys-devel/binutils-2.25
		)
		cpu_flags_x86_avx512vbmi? (
			>=sys-devel/gcc-12.1
			>=sys-devel/binutils-2.32
		)
	)
	clang? (
		$(gen_clang)
	)
	system-libs? (
		test? (
			>=dev-cpp/benchmark-1.6.1
		)
	)
"
PDEPEND="
"
PATCHES=(
	"${FILESDIR}/${PN}-1.13.1-gentoo.patch"
	"${FILESDIR}/${PN}-1.13.0-install-dirs.patch"
	"${FILESDIR}/${PN}-1.12.0-glog-0.6.0.patch"
	"${FILESDIR}/${PN}-1.12.0-clang.patch"
	"${FILESDIR}/${PN}-1.13.1-prefixed-install.patch"
	"${FILESDIR}/${PN}-1.13.1-optionalize-simd.patch"
)

warn_untested_gpu() {
	local gpu
	for gpu in ${AMDGPU_TARGETS_UNTESTED[@]} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not CI tested upstream."
		fi
	done
}

pkg_setup() {
	dhms_start
	warn_untested_gpu
# error: 'runtime_error' is not a member of 'std'
ewarn
ewarn "Switch to GCC 12 if build failure."
ewarn
ewarn "eselect gcc set ${CHOST}-12"
ewarn "source /etc/profile"
ewarn
	if use rocm_5_2 ; then
		LLVM_SLOT="14"
		LLVM_MAX_SLOT="${LLVM_SLOT}"
		ROCM_SLOT="5.2"
		rocm_pkg_setup
	#elif use rocm_5_1 ; then
	#	LLVM_SLOT="14"
	#	LLVM_MAX_SLOT="${LLVM_SLOT}"
	#	ROCM_SLOT="5.1"
	#	rocm_pkg_setup
	else
		local s
		for s in ${LLVM_COMPAT[@]} ; do
			if use "llvm_slot_${s}" ; then
				LLVM_MAX_SLOT="${s}"
				if use clang ; then
					export CC="${CHOST}-clang-${s}"
					export CXX="${CHOST}-clang++-${s}"
					append-ldflags -fuse-ld=lld
				fi
				break
			fi
		done
		llvm_pkg_setup

		if ! use clang ; then
			if has_version "=dev-util/nvidia-cuda-toolkit-11.8*" ; then
				export CC="${CHOST}-gcc-11"
				export CXX="${CHOST}-g++-11"
			elif has_version "=dev-util/nvidia-cuda-toolkit-11.7*" ; then
				export CC="${CHOST}-gcc-11"
				export CXX="${CHOST}-g++-11"
			elif has_version "=dev-util/nvidia-cuda-toolkit-11.3*" ; then
				export CC="${CHOST}-gcc-10"
				export CXX="${CHOST}-g++-10"
			elif has_version "=dev-util/nvidia-cuda-toolkit-11.2*" ; then
				export CC="${CHOST}-gcc-10"
				export CXX="${CHOST}-g++-10"
			else
				local min_slot

				if use cpu_flags_riscv_rvv ; then
					min_slot=14
				elif use cpu_flags_x86_avx512vbmi ; then
					min_slot=12
				elif use cpu_flags_x86_amx ; then
					min_slot=11
				elif use cpu_flags_s390_vxe_z14 || use cpu_flags_s390_vxe_z15 ; then
					min_slot=9
				elif use cpu_flags_arm_dotprod || use cpu_flags_arm_sve ; then
					min_slot=8
				else
					min_slot=${GCC_SLOTS[-1]}
				fi

				local gcc_slots=( $(seq ${GCC_SLOTS[0]} -1 ${min_slot}) )
				local s
				for s in ${gcc_slots[@]} ; do
					if use openmp && has_version "=sys-devel/gcc-${s}*[openmp]" ; then
						export CC="${CHOST}-gcc-${s}"
						export CXX="${CHOST}-g++-${s}"
						break
					elif has_version "=sys-devel/gcc-${s}*" ; then
						export CC="${CHOST}-gcc-${s}"
						export CXX="${CHOST}-g++-${s}"
						break
					fi
				done
			fi
		fi
		export CPP="${CC} -E"
		strip-unsupported-flags
	fi

	if use rocm ; then
		local libs=(
			"amd_comgr:dev-libs/rocm-comgr"
			"amdhip64:dev-util/hip"
			"hsa-runtime64:dev-libs/rocr-runtime"
			"rocblas:sci-libs/rocBLAS"
		)
		if use roctracer ; then
			libs+=(
				"roctracer64:dev-util/roctracer"
			)
		fi
		local glibcxx_ver="HIP_${ROCM_SLOT/./_}_GLIBCXX"
	# Avoid missing versioned symbols
	# # ld: /opt/rocm-6.1.2/lib/librocblas.so: undefined reference to `std::ios_base_library_init()@GLIBCXX_3.4.32'
		rocm_verify_glibcxx "${!glibcxx_ver}" ${libs[@]}
	fi

	python-single-r1_pkg_setup
}

src_prepare() {
	if use system-libs ; then
		eapply "${FILESDIR}/${PN}-1.13.1-tensorpipe.patch"
		sed -i \
			-e "/third_party\/gloo/d" \
			"cmake/Dependencies.cmake" \
			|| die
	else
		dep_prepare_mv "${WORKDIR}/ARM_NEON_2_x86_SSE-${NEON2SSE_COMMIT}" "${S}/third_party/neon2sse"
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_1}" "${S}/third_party/benchmark"
		dep_prepare_mv "${WORKDIR}/cpuinfo-${CPUINFO_COMMIT_1}" "${S}/third_party/cpuinfo"
		dep_prepare_mv "${WORKDIR}/cudnn-frontend-${CUDNN_FRONTEND_COMMIT}" "${S}/third_party/cudnn_frontend"
		dep_prepare_mv "${WORKDIR}/eigen-${EIGEN_COMMIT}" "${S}/third_party/eigen"
		dep_prepare_mv "${WORKDIR}/enum34-${PYTHON_ENUM_COMMIT}" "${S}/third_party/python-enum"
		dep_prepare_mv "${WORKDIR}/flatbuffers-${FLATBUFFERS_COMMIT}" "${S}/third_party/flatbuffers"
		dep_prepare_mv "${WORKDIR}/fmt-${FMT_COMMIT_1}" "${S}/third_party/fmt"
		dep_prepare_mv "${WORKDIR}/foxi-${FOXI_COMMIT}" "${S}/third_party/foxi"

		dep_prepare_mv "${WORKDIR}/FBGEMM-${FBGEMM_COMMIT}" "${S}/third_party/FBGEMM"
		dep_prepare_mv "${WORKDIR}/asmjit-${ASMJIT_COMMIT}" "${S}/third_party/FBGEMM/third_party/asmjit"
		dep_prepare_mv "${WORKDIR}/cpuinfo-${CPUINFO_COMMIT_2}" "${S}/third_party/FBGEMM/third_party/cpuinfo"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_5}" "${S}/third_party/FBGEMM/third_party/googletest"
		dep_prepare_mv "${WORKDIR}/hipify_torch-${HIPIFY_TORCH_COMMIT}" "${S}/third_party/FBGEMM/third_party/hipify_torch"

		dep_prepare_mv "${WORKDIR}/FP16-${FP16_COMMIT}" "${S}/third_party/FP16"
		dep_prepare_mv "${WORKDIR}/FXdiv-${FXDIV_COMMIT}" "${S}/third_party/FXdiv"

		dep_prepare_mv "${WORKDIR}/gloo-${GLOO_COMMIT}" "${S}/third_party/gloo"
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_1}" "${S}/third_party/gloo/third-party/googletest"

		dep_prepare_mv "${WORKDIR}/ideep-${IDEEP_COMMIT}" "${S}/third_party/ideep"
		dep_prepare_mv "${WORKDIR}/oneDNN-${MKL_DNN_COMMIT}" "${S}/third_party/ideep/mkl-dnn"

		dep_prepare_mv "${WORKDIR}/ios-cmake-${IOS_CMAKE_COMMIT}" "${S}/third_party/ios-cmake"

		dep_prepare_mv "${WORKDIR}/ittapi-${ITTAPI_COMMIT}" "${S}/third_party/ittapi"
		dep_prepare_mv "${WORKDIR}/json-${NLOHMANN_COMMIT_1}" "${S}/third_party/nlohmann"

		dep_prepare_mv "${WORKDIR}/kineto-${KINETO_COMMIT}" "${S}/third_party/kineto"
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_3}" "${S}/third_party/kineto/libkineto/third_party/googletest"
		dep_prepare_mv "${WORKDIR}/fmt-${FMT_COMMIT_2}" "${S}/third_party/kineto/libkineto/third_party/fmt"

		dep_prepare_mv "${WORKDIR}/NNPACK-${NNPACK_COMMIT}" "${S}/third_party/NNPACK"

		dep_prepare_mv "${WORKDIR}/onnx-${ONNX_COMMIT_1}" "${S}/third_party/onnx"
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_3}" "${S}/third_party/onnx/third_party/benchmark"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_2}" "${S}/third_party/onnx/third_party/pybind11"

		dep_prepare_mv "${WORKDIR}/onnx-tensorrt-${ONNX_TENSORRT_COMMIT}" "${S}/third_party/onnx-tensorrt"
		dep_prepare_mv "${WORKDIR}/onnx-${ONNX_COMMIT_2}" "${S}/third_party/onnx-tensorrt/third_party/onnx"
		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_4}" "${S}/third_party/onnx-tensorrt/third_party/onnx/third_party/benchmark"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_3}" "${S}/third_party/onnx-tensorrt/third_party/onnx/third_party/pybind11"
		dep_prepare_cp "${WORKDIR}/clang-cindex-python3-${CLANG_CINDEX_PYTHON3_COMMIT}" "${S}/third_party/onnx-tensorrt/third_party/onnx/third_party/pybind11/tools/clang"

		dep_prepare_mv "${WORKDIR}/PeachPy-${PEACHPY_COMMIT}" "${S}/third_party/python-peachpy"
		dep_prepare_mv "${WORKDIR}/pocketfft-${POCKETFFT_COMMIT}" "${S}/third_party/pocketfft"

		dep_prepare_mv "${WORKDIR}/oneTBB-${TBB_COMMIT}" "${S}/third_party/tbb"

		dep_prepare_mv "${WORKDIR}/protobuf-${PROTOBUF_COMMIT}" "${S}/third_party/protobuf"
		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_2}" "${S}/third_party/protobuf/third_party/benchmark"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_2}" "${S}/third_party/protobuf/third_party/googletest"

		dep_prepare_mv "${WORKDIR}/psimd-${PSIMD_COMMIT}" "${S}/third_party/psimd"
		dep_prepare_mv "${WORKDIR}/pthreadpool-${PTHREADPOOL_COMMIT}" "${S}/third_party/pthreadpool"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1}" "${S}/third_party/pybind11"
		dep_prepare_mv "${WORKDIR}/QNNPACK-${QNNPACK_COMMIT}" "${S}/third_party/QNNPACK"
		dep_prepare_mv "${WORKDIR}/six-${PYTHON_SIX_COMMIT}" "${S}/third_party/python-six"
		dep_prepare_mv "${WORKDIR}/sleef-${SLEEF_COMMIT}" "${S}/third_party/sleef"

		dep_prepare_mv "${WORKDIR}/tensorpipe-${TENSORPIPE_COMMIT}" "${S}/third_party/tensorpipe"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_6}" "${S}/third_party/tensorpipe/third_party/googletest"
		dep_prepare_mv "${WORKDIR}/libnop-${LIBNOP_COMMIT}" "${S}/third_party/tensorpipe/third_party/libnop"
		dep_prepare_mv "${WORKDIR}/libuv-${LIBUV_COMMIT}" "${S}/third_party/tensorpipe/third_party/libuv"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_4}" "${S}/third_party/tensorpipe/third_party/pybind11"
		dep_prepare_cp "${WORKDIR}/clang-cindex-python3-${CLANG_CINDEX_PYTHON3_COMMIT}" "${S}/third_party/tensorpipe/third_party/pybind11/tools/clang"

		dep_prepare_mv "${WORKDIR}/VulkanMemoryAllocator-${VULKANMEMORYALLOCATOR_COMMIT}" "${S}/third_party/VulkanMemoryAllocator"
		dep_prepare_mv "${WORKDIR}/XNNPACK-${XNNPACK_COMMIT}" "${S}/third_party/XNNPACK"
		dep_prepare_mv "${WORKDIR}/zstd-${ZSTD_COMMIT}" "${S}/third_party/zstd"
	fi
	filter-lto #bug 862672
	cmake_src_prepare

	if use system-libs ; then
		eapply "${FILESDIR}/${PN}-1.13.1-cuda-hardcoded-paths.patch"
		eapply "${FILESDIR}/${PN}-1.13.1-rocm-hardcoded-paths.patch"
	else
		eapply "${FILESDIR}/${PN}-1.13.1-cuda-hardcoded-paths.patch"
		eapply "${FILESDIR}/${PN}-1.13.1-rocm-hardcoded-paths.patch"
		eapply "${FILESDIR}/${PN}-1.13.1-cuda-hardcoded-paths-third-party.patch"
		eapply "${FILESDIR}/${PN}-1.13.1-rocm-hardcoded-paths-third-party.patch"
	fi

	if use system-libs ; then
		pushd "torch/csrc/jit/serialization" >/dev/null 2>&1 || die
			flatc \
				--cpp \
				--gen-mutable \
				--scoped-enums \
				"mobile_bytecode.fbs" \
				|| die
		popd >/dev/null 2>&1 || die
	fi
	if use rocm ; then
		rocm_src_prepare
	fi

	if ! use jit ; then
		sed -i -e "/libtorch_edge_profiler_sources/d" "caffe2/CMakeLists.txt" || die
	fi
}

gen_cuda_arch_list() {
	if -n [[ "${TORCH_CUDA_ARCH_LIST}" ]] ; then
		echo "${TORCH_CUDA_ARCH_LIST}"
	else
		local list
		local x
		for x in ${CUDA_TARGETS_COMPAT[@]} ; do
			if use "cuda_targets_${x}" ; then
				local gen
				local ver
				local suffix=""
				if [[ "${x}" =~ "compute" ]] ; then
					suffix="+PTX"
					x="${x/_ptx/}"
				fi
				local val=",${x#*_}"
				if (( "${#val}" == 2 )) ; then
					# CC 3.5, 7.5
					ver=${val:1:1}
					gen=${val:0:1}
				elif (( "${#val}" == 3 )) ; then
					# Hypothentical CC 10.0
					ver=${val:2:1}
					gen=${val:0:2}
				fi
				list+=",${getn}.${val}${suffix}"
			fi
		done
		echo "${list:1}"
	fi
}

src_configure() {
	if use cuda && [[ -z ${TORCH_CUDA_ARCH_LIST} ]]; then
einfo
einfo "You can look up your GPU's CUDA compute capability at"
einfo
einfo "  https://developer.nvidia.com/cuda-gpus"
einfo
einfo "or by running"
einfo
einfo "  /opt/cuda/extras/demo_suite/deviceQuery | grep 'CUDA Capability'"
einfo
	fi

	if ( use amd64 && ! use fbgemm ) || ( use amd64 && ! use onednn ) ; then
ewarn "Disabling either fbgemm or onednn may cause a performance penalty on ARCH=amd64."
	fi

	if use arm64 && ! use qnnpack ; then
ewarn "Disabling qnnpack may cause a performance penalty on ARCH=arm64."
	fi

	usex_avx512() {
		if \
			   use cpu_flags_x86_avx512bw \
			&& use cpu_flags_x86_avx512dq \
			&& use cpu_flags_x86_avx512f \
			&& use cpu_flags_x86_avx512vl \
		; then
			echo "ON"
		else
			echo "OFF"
		fi
	}

	use_avx512() {
		if \
			   use cpu_flags_x86_avx512bw \
			&& use cpu_flags_x86_avx512dq \
			&& use cpu_flags_x86_avx512f \
			&& use cpu_flags_x86_avx512vl \
		; then
			return 0
		else
			return 1
		fi
	}

	use_arm_fp16_dotprod() {
		if ( use arm || use arm64 ) && use cpu_flags_arm_dotprod && use cpu_flags_arm_fp16 ; then
			echo "ON"
		else
			echo "OFF"
		fi
	}

	local mycmakeargs=(
		-DASMJIT_NO_JIT=$(usex !jit)
		-DBUILD_CUSTOM_PROTOBUF=$(usex system-libs OFF ON)
		-DBUILD_LITE_INTERPRETER=OFF
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_INSTALL_PREFIXED_DATAROOTDIR="lib/${PN}/share"
		-DCMAKE_INSTALL_PREFIXED_INCLUDEDIR="lib/${PN}/include"
		-DCMAKE_INSTALL_PREFIXED_LIBDIR="lib/${PN}/$(get_libdir)"
		-DCMAKE_INSTALL_PREFIXED_BINDIR="lib/${PN}/bin"
		-DLIBSHM_INSTALL_LIB_SUBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DONEDNN_EXPERIMENTAL_GRAPH_COMPILER_BACKEND=$(usex jit)
		-DPYBIND11_PYTHON_VERSION="${EPYTHON#python}"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DSLEEF_DISABLE_AVX=$(usex !cpu_flags_x86_avx)
		-DSLEEF_DISABLE_AVX2=$(usex !cpu_flags_x86_avx2)
		-DSLEEF_DISABLE_AVX512F=$(usex !cpu_flags_x86_avx512f)
		-DSLEEF_DISABLE_FMA4=$(usex !cpu_flags_x86_fma4)
		-DSLEEF_DISABLE_OPENMP=$(usex !openmp)
		-DSLEEF_DISABLE_RVVM1=$(usex !cpu_flags_riscv_rvv)
		-DSLEEF_DISABLE_RVVM2=$(usex !cpu_flags_riscv_rvv)
		-DSLEEF_DISABLE_SSE2=$(usex !cpu_flags_x86_sse2)
		-DSLEEF_DISABLE_SSE4=$(usex !cpu_flags_x86_sse4_1)
		-DSLEEF_DISABLE_SVE=$(usex !cpu_flags_arm_sve)
		-DSLEEF_DISABLE_VSX=$(usex !cpu_flags_ppc_vsx)
		-DSLEEF_DISABLE_VSX3=$(usex !cpu_flags_ppc_vsx3)
		-DSLEEF_DISABLE_VXE=$(usex !cpu_flags_s390_vxe_z14)
		-DSLEEF_DISABLE_VXE2=$(usex !cpu_flags_s390_vxe_z15)
		-DTORCH_INSTALL_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DUSE_AVX2=$(usex cpu_flags_x86_avx2)
		-DUSE_AVX512=$(usex_avx512)
		-DUSE_CCACHE=OFF
		-DUSE_CUDA=$(usex cuda)
		-DUSE_CUDNN=$(usex cuda)
		-DUSE_DISTRIBUTED=$(usex distributed)
		-DUSE_FAKELOWP=OFF
		-DUSE_FAST_NVCC=$(usex cuda)
		-DUSE_FBGEMM=$(usex fbgemm)
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_FLASH_ATTENTION=$(usex flash-attention $(usex cuda ON $(usex rocm OFF OFF) OFF) OFF)
		-DUSE_GFLAGS=ON
		-DUSE_GLOG=ON
		-DUSE_GLOO=$(usex gloo)
		-DUSE_GLOO_WITH_OPENSSL=$(usex gloo $(usex ssl ON OFF) OFF)
		-DUSE_ITT=OFF
		-DUSE_KINETO=$(usex kineto $(usex system-libs OFF ON) OFF)
		-DUSE_LEVELDB=OFF
		-DUSE_MAGMA=$(usex magma)
		-DUSE_MPI=$(usex mpi)
		-DUSE_NNPACK=$(usex nnpack)
		-DUSE_PYTORCH_QNNPACK=OFF
		-DUSE_QNNPACK=$(usex qnnpack)
		-DUSE_TENSORPIPE=$(usex tensorpipe)
		-DUSE_NUMPY=$(usex numpy)
		-DUSE_OPENCL=$(usex opencl)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_ROCM=$(usex rocm)
		-DUSE_SYSTEM_BENCHMARK=$(usex system-libs)
		-DUSE_SYSTEM_CLOG=$(usex system-libs)
		-DUSE_SYSTEM_CPP_HTTPLIB=$(usex system-libs)
		-DUSE_SYSTEM_CPUINFO=$(usex system-libs)
		-DUSE_SYSTEM_FBGEMM=$(usex system-libs)
		-DUSE_SYSTEM_FLATBUFFERS=$(usex system-libs)
		-DUSE_SYSTEM_FOXI=$(usex system-libs)
		-DUSE_SYSTEM_FP16=$(usex system-libs)
		-DUSE_SYSTEM_FXDIV=$(usex system-libs)
		-DUSE_SYSTEM_GLOO=$(usex system-libs)
		-DUSE_SYSTEM_KINETO=$(usex system-libs)
		-DUSE_SYSTEM_LIBFMT=$(usex system-libs)
		-DUSE_SYSTEM_NNPACK=$(usex system-libs)
		-DUSE_SYSTEM_ONNX=$(usex system-libs)
		-DUSE_SYSTEM_PSIMD=$(usex system-libs)
		-DUSE_SYSTEM_PTHREADPOOL=$(usex system-libs)
		-DUSE_SYSTEM_PYBIND11=$(usex system-libs)
		-DUSE_SYSTEM_QNNPACK=$(usex system-libs)
		-DUSE_SYSTEM_SLEEF=$(usex system-libs)
		-DUSE_SYSTEM_VALGRIND_HEADERS=$(usex system-libs)
		-DUSE_SYSTEM_XNNPACK=$(usex system-libs)
		-DUSE_UCC=OFF
		-DUSE_VALGRIND=OFF
		-DUSE_VSX=$(usex cpu_flags_ppc_vsx)
		-DUSE_XNNPACK=$(usex xnnpack)
		-DUSE_ZVECTOR=$(usex cpu_flags_s390_zvector)
		-DXNNPACK_ENABLE_ASSEMBLY=$(use_arm_fp16_dotprod)
		-DXNNPACK_ENABLE_JIT=$(usex jit)
		-Wno-dev

		-DINTERN_DISABLE_MOBILE_INTERP=OFF
	)

	if use onednn ; then
		if use amd64 && ( use cpu_flags_x86_amx || use cpu_flags_x86_avx2 || use_avx512 || use cpu_flags_x86_sse4_1 ) ; then
			mycmakeargs+=(
				-DUSE_MKLDNN=$(usex onednn)
			)
			if use system-libs ; then
				mycmakeargs+=(
					-DMKLDNN_INCLUDE_DIR="${ESYSROOT}/usr/include/oneapi/dnnl"
					-DMKLDNN_LIBRARIES="dnnl"
				)
			fi
		elif use arm64 ; then
			mycmakeargs+=(
				-DUSE_MKLDNN=OFF # Missing ComputeLibrary
			)
		else
			mycmakeargs+=(
				-DUSE_MKLDNN=OFF
			)
		fi
	else
		mycmakeargs+=(
			-DUSE_MKLDNN=OFF
		)
	fi

	if has_version "sci-libs/mkl" ; then
		if ! has_version ">=dev-cpp/eigen-3.4.0" && use system-libs ; then
eerror "Install >=dev-cpp/eigen-3.4.0 or uninstall sci-libs/mkl"
			die
		fi
	# Avoid the use of MKL, if found on the system.
		if use eigen ; then
			mycmakeargs+=(
				-DBLAS="Eigen"
			)
		else
			mycmakeargs+=(
				-DBLAS="Generic"
				-DBLAS_LIBRARIES=""
			)
		fi
#	elif use mkl ; then
#		mycmakeargs+=(
#			-DBLAS="MKL"
#		)
#
#		local flags
#		flags=""
#		if use cpu_flags_x86_sse4_1 ; then
#			flags="${flags};SSE41"
#		fi
#		if use cpu_flags_x86_avx2 ; then
#			flags="${flags};AVX2"
#		fi
#		if use_avx512 ; then
#			flags="${flags};AVX512"
#		fi
#		if use cpu_flags_x86_amx ; then
#			flags="${flags};AMX"
#		fi
#		mycmakeargs+=(
#			-DDNNL_ENABLE_PRIMITIVE_CPU_ISA="${flags:1}"
#			-DONEDNN_ENABLE_GEMM_KERNELS_ISA="${flags:1}"
#		)

	elif use openblas ; then
		mycmakeargs+=(
			-DBLAS="OpenBLAS"
		)
	else
		if use eigen ; then
			mycmakeargs+=(
				-DBLAS="Eigen"
			)
		else
			mycmakeargs+=(
				-DBLAS="Generic"
				-DBLAS_LIBRARIES=""
			)
		fi
	fi

	if use cuda ; then
		addpredict "/dev/nvidiactl" # bug 867706
		addpredict "/dev/char"

		if use cuda_targets_auto ; then
			# From U18.04 Dockerfile
			# CI for linux uses only Maxwell or 5.2
			mycmakeargs+=(
				-DTORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST:-"5.2 6.0 6.1 7.0+PTX 8.0"}
			)
		else
			mycmakeargs+=(
				-DTORCH_CUDA_ARCH_LIST=$(gen_cuda_arch_list)
			)
		fi

		mycmakeargs+=(
			-DCMAKE_CUDA_FLAGS=$(cuda_gccdir -f \
				| tr -d \")
			-DUSE_NCCL=$(usex nccl)
		)
	fi
	if use rocm ; then
		export HCC_PATH="${ESYSROOT}${EROCM_PATH}"
		export HIP_PATH="${ESYSROOT}${EROCM_PATH}"
		export HIPCUB_PATH="${ESYSROOT}${EROCM_PATH}"
		export HIPFFT_PATH="${ESYSROOT}${EROCM_PATH}"
		export HIPRAND_PATH="${ESYSROOT}${EROCM_PATH}"
		export HIPSPARSE_PATH="${ESYSROOT}${EROCM_PATH}"
		export HSA_PATH="${ESYSROOT}${EROCM_PATH}"
		export MAGMA_HOME="${ESYSROOT}${EROCM_PATH}"
		export MIOPEN_PATH="${ESYSROOT}${EROCM_PATH}"
		export RCCL_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCBLAS_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCFFT_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCM_HOME="${ESYSROOT}${EROCM_PATH}"
		export ROCM_INCLUDE_DIRS="${ESYSROOT}${EROCM_PATH}/include"
		export ROCM_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCPRIM_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCRAND_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCTRACER_PATH="${ESYSROOT}${EROCM_PATH}"
		export ROCTHRUST_PATH="${ESYSROOT}${EROCM_PATH}"
		export THRUST_PATH="${ESYSROOT}${EROCM_PATH}/include"
		mycmakeargs+=(
			-DPYTORCH_ROCM_ARCH=$(get_amdgpu_flags)
			-DUSE_NCCL=$(usex rccl)
			-DUSE_RCCL=$(usex rccl)
			-DUSE_SYSTEM_NCCL=ON
		)
	else
		mycmakeargs+=(
			-DUSE_RCCL=OFF
		)
	fi

	if use rocm ; then
		mycmakeargs+=(
			-DOpenMP_C_FLAGS="-I${ESYSROOT}/opt/rocm-${ROCM_VERSION}/llvm/include -fopenmp=libomp"
			-DOpenMP_C_LIB_NAMES="libomp"

			-DOpenMP_CXX_FLAGS="-I${ESYSROOT}/opt/rocm-${ROCM_VERSION}/llvm/include -fopenmp=libomp"
			-DOpenMP_CXX_LIB_NAMES="libomp"

			-DOpenMP_libomp_LIBRARY="${ESYSROOT}/opt/rocm-${ROCM_VERSION}/lib/libomp.so"
		)
	elif use clang ; then
		mycmakeargs+=(
			-DOpenMP_C_FLAGS="-I${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/include -fopenmp=libomp"
			-DOpenMP_C_LIB_NAMES="libomp"

			-DOpenMP_CXX_FLAGS="-I${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/include -fopenmp=libomp"
			-DOpenMP_CXX_LIB_NAMES="libomp"

			-DOpenMP_libomp_LIBRARY="${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/$(get_libdir)/libomp.so"
		)
	fi

	if ! use kineto ; then
		append-cppflags -DNO_PROFILING
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto "/var/lib/${PN}"
	doins "${BUILD_DIR}/CMakeCache.txt"

	rm -rf "python"
	mkdir -p "python/torch/include" || die
	mv \
		"${ED}/usr/lib/python"*"/site-packages/caffe2" \
		"python/" \
		|| die
	mv \
		"${ED}/usr/include/torch" \
		"python/torch/include" \
		|| die
	cp \
		"torch/version.py" \
		"python/torch/" \
		|| die
	rm -rf "${ED}/var/tmp" || die
	python_domodule "python/caffe2"
	python_domodule "python/torch"

	# FIXME: fix cmake build scripts and remove below.
	mv \
		"${ED}/usr/include/pybind11" \
		"${ED}/usr/lib/${PN}/include" \
		|| die
	dhms_end
}
