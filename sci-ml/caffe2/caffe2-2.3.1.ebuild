# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This package is a misnomer.  This is the non-python portions of pytorch.

# TODO package:
# ComputeLibrary

# TODO patch:
#   Make cmake/External/aotriton.cmake use unpacked folder.

# For requirements, see
# https://github.com/pytorch/pytorch/blob/v2.3.1/RELEASE.md?plain=1#L49
# https://github.com/pytorch/pytorch/tree/v2.3.1/third_party
# https://github.com/pytorch/pytorch/blob/v2.3.1/.ci/docker/common/install_rocm_magma.sh#L10 for magma
# https://github.com/pytorch/pytorch/blob/v2.3.1/cmake/External/aotriton.cmake

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
	 gfx942 # Suggested by aotriton for flash-attention, but not listed in rocm_agent_enumerator.
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
# Based on https://github.com/pytorch/pytorch/blob/v2.3.1/.ci/pytorch/build.sh#L162
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
#	gfx90a # MI210
	gfx90c
	 gfx942
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
AOTRITON_COMMIT="24a3fe9cb57e5cda3c923df29743f9767194cc27"
ASMJIT_COMMIT="d3fbf7c9bc7c1d1365a94a45614b91c5a3706b81" # fbgemm dep
BENCHMARK_COMMIT_1="0d98dba29d66e93259db7daa53a9327df767a415"
BENCHMARK_COMMIT_2="5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8" # protobuf dep
BENCHMARK_COMMIT_3="2dd015dfef425c866d9a43f2c67d8b52d709acb6" # onnx dep
BENCHMARK_COMMIT_4="e776aa0275e293707b6a0901e0e8d8a8a3679508" # onnx-tensorrt/third_party/onnx dep
CFLAGS_HARDENED_USE_CASES="jit untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="HO UAF"
CLANG_CINDEX_PYTHON3_COMMIT="6a00cbc4a9b8e68b71caf7f774b3f9c753ae84d5" # onnx-tensorrt/third_party/onnx/third_party/pybind11 dep
CPR_COMMIT="871ed52d350214a034f6ef8a3b8f51c5ce1bd400" # dynolog dep
CPU_FLAGS_ARM=(
	cpu_flags_arm_bf16
	cpu_flags_arm_dotprod
	cpu_flags_arm_fp16
	cpu_flags_arm_i8mm
	cpu_flags_arm_neon
	cpu_flags_arm_sve
)
CPU_FLAGS_PPC=(
	cpu_flags_ppc_vsx
	cpu_flags_ppc_vsx3
)
CPU_FLAGS_RISCV=(
	cpu_flags_riscv_rvv
	cpu_flags_riscv_rvv_fp16
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
	cpu_flags_x86_avx512vl
	cpu_flags_x86_avx512vbmi
	cpu_flags_x86_avx512vnni
	cpu_flags_x86_f16c
	cpu_flags_x86_fma
	cpu_flags_x86_fma4
	cpu_flags_x86_gfni
	cpu_flags_x86_sse2
	cpu_flags_x86_sse4_1
)
CPUINFO_COMMIT_1="d6860c477c99f1fce9e28eb206891af3c0e1a1d7"
CPUINFO_COMMIT_2="ed8b86a253800bafdb7b25c5c399f91bff9cb1f3" # fbgemm dep
CUB_COMMIT="d106ddb991a56c3df1b6d51b2409e36ba8181ce4"
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
	sm_90
	compute_50
	compute_70
)
CUDNN_FRONTEND_COMMIT="150798fe976556078f443fdb059a1ff0361f58a2"
CUTLASS_COMMIT_1="bbe579a9e3beb6ea6626d9227ec32d0dae119a49"
CUTLASS_COMMIT_2="fc9ebc645b63f3a6bc80aaefde5c063fb72110d6" # fbgemm dep
DCGM_COMMIT="ffde4e54bc7249a6039a5e6b45b395141e1217f9" # dynolog dep
DYNOLOG_COMMIT="950cd3f80a3b1d966314380e8ecdd47ee0c586cc" # kineto dep ; committer-date:<=2024-01-31
FBGEMM_COMMIT="dbc3157bf256f1339b3fa1fef2be89ac4078be0e"
FFMPEG_COMPAT=(
	"0/56.58.58" # 4.4 (U22 dockerfile)
	"0/54.56.56" # 2.8 (U16 docs)
	"0/52.54.54" # 1.2 (U14 docs)
)
FLATBUFFERS_COMMIT="01834de25e4bf3975a9a00e816292b1ad0fe184b"
FMT_COMMIT_1="e69e5f977d458f2650bb346dadf2ad30c5320281"
FMT_COMMIT_2="d9063baf227882da0f48c761abcbb08247eb1296" # kineto dep ; committer-date:<=2024-01-31
FMT_COMMIT_3="cd4af11efc9c622896a3e4cb599fa28668ca3d05" # dynolog dep
FOXI_COMMIT="c278588e34e535f0bb8f00df3880d26928038cad"
FP16_COMMIT="4dfe081cf6bcd15db339cf2680b9281b8451eeb3"
FXDIV_COMMIT="b408327ac2a15ec3e43352421954f5b1967701d1"
GCC_SLOTS=( {15..9} ) # Upstream uses 11 or 9
GFLAGS_COMMIT="e171aa2d15ed9eb17054558e0b3a6a413bb01067" # dynolog dep
GFLAGS_DOC_COMMIT="8411df715cf522606e3b1aca386ddfc0b63d34b4" # dynolog/third_party/gflags/doc dep
GLOG_COMMIT="b33e3bad4c46c8a6345525fd822af355e5ef9446" # dynolog dep
GLOO_COMMIT="5354032ea08eadd7fc4456477f7f7c6308818509"
GOOGLETEST_COMMIT_1="518387203b573f35477fa6872dd54620e70d2bdb" # gloo dep ; committer-date:<=2023-12-02
GOOGLETEST_COMMIT_2="5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081" # protobuf dep
GOOGLETEST_COMMIT_3="518387203b573f35477fa6872dd54620e70d2bdb" # kineto dep ; committer-date:<=2024-01-31
GOOGLETEST_COMMIT_4="58d77fa8070e8cec2dc1ed015d66b454c8d78850" # dynolog dep
GOOGLETEST_COMMIT_5="cbf019de22c8dd37b2108da35b2748fd702d1796" # fbgemm dep
GOOGLETEST_COMMIT_6="aee0f9d9b5b87796ee8a0ab26b7587ec30e8858e" # tensorpipe dep
EIGEN_COMMIT="3147391d946bb4b6c68edd901f2add6ac1f31f8c"
HIPIFY_TORCH_COMMIT="23f53b025b466d8ec3c45d52290d3442f7fbe6b1" # fbgemm dep
IDEEP_COMMIT="8a6cc4e09dc509f04f83c085e38786b1fb44e14d"
INCBIN_COMMIT="6e576cae5ab5810f25e2631f2e0b80cbe7dc8cbf" # aotriton dep
IOS_CMAKE_COMMIT="8abaed637d56f1337d6e1d2c4026e25c1eade724"
ITTAPI_COMMIT="5b8a7d7422611c3a0d799fb5fc5dd4abfae35b42"
KINETO_COMMIT="3f30237e868ca92b46b309da17d84b37be373a6e"
LIBNOP_COMMIT="910b55815be16109f04f4180e9adee14fb4ce281" # tensorpipe dep
LIBUV_COMMIT="1dff88e5161cba5c59276d2070d2e304e4dcb242" # tensorpipe dep
LLVM_COMPAT=(
	17 # ROCm slot
	15 12 10 9 # Upstream build.sh, pull.yml
)
LLVM_COMPAT_ARM_BF16=(
	17
	15 12
)
LLVM_COMPAT_S390_Z15=(
	17
	15 12 10
)
LLVM_COMPAT_X86_AMX=(
	17
	15 12
)
MIMALLOC_COMMIT="b66e3214d8a104669c2ec05ae91ebc26a8f5ab78"
MKL_DNN_COMMIT="86e6af5974177e513fd3fee58425e1063e7f1361"
MYPN="pytorch"
MYP="${MYPN}-${PV}"
NEON2SSE_COMMIT="97a126f08ce318023be604d03f88bf0820a9464a"
NLOHMANN_COMMIT_1="87cda1d6646592ac5866dc703c8e1839046a6806"
NLOHMANN_COMMIT_2="4f8fba14066156b73f1189a2b8bd568bde5284c5" # dynolog dep
NNPACK_COMMIT="c07e3a0400713d546e0dea2d5466dd22ea389c73"
ONNX_COMMIT_1="990217f043af7222348ca8f0301e17fa7b841781"
ONNX_COMMIT_2="765f5ee823a67a866f4bd28a9860e81f3c811ce8" # onnx-tensorrt dep
ONNX_TENSORRT_COMMIT="c153211418a7c57ce071d9ce2a41f8d1c85a878f"
PEACHPY_COMMIT="f45429b087dd7d5bc78bb40dc7cf06425c252d67"
PFS_COMMIT="f68a2fa8ea36c783bdd760371411fcb495aa3150" # dynolog dep
POCKETFFT_COMMIT="9d3ab05a7fffbc71a492bc6a17be034e83e8f0fe"
PROTOBUF_COMMIT="d1eca4e4b421cd2997495c4b4e65cea6be4e9b8a"
PSIMD_COMMIT="072586a71b55b7f8c584153d223e95687148a900"
PTHREADPOOL_COMMIT="4fe0e1e183925bf8cfa6aae24237e724a96479b8"
PYBIND11_COMMIT_1="3e9dfa2866941655c56877882565e7577de6fc7b"
PYBIND11_COMMIT_2="5b0a6fc2017fcc176545afe3e09c9f9885283242" # onnx dep
PYBIND11_COMMIT_3="a1041190c8b8ff0cd9e2f0752248ad5e3789ea0c" # onnx-tensorrt/third_party/onnx dep
PYBIND11_COMMIT_4="a23996fce38ff6ccfbcdc09f1e63f2c4be5ea2ef" # tensorpipe dep
PYBIND11_COMMIT_5="8a099e44b3d5f85b20f05828d919d2332a8de841" # aotriton dep
PYTHON_COMPAT=( "python3_11" ) # Upstream only allows <=3.11
QNNPACK_COMMIT="7d2a4e9931a82adc3814275b6219a03e24e36b4c"
inherit hip-versions
ROCM_SLOTS=(
# See https://github.com/pytorch/pytorch/blob/v2.3.1/.ci/docker/build.sh#L190
	"${HIP_6_0_VERSION}"
	"${HIP_5_7_VERSION}"
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
TRITON_COMMIT="9b73a543a5545960bcaf2830900b0560eec443c5" # aotriton dep
TRITON_SHARED_COMMIT="450e6be65f99a0b15fd130892594b85e0897574c" # aotriton/third_party/triton dep
VULKANMEMORYALLOCATOR_COMMIT="a6bfc237255a6bac1513f7c1ebde6d8aed6b5191"
XNNPACK_COMMIT="fcbf55af6cf28a4627bcd1f703ab7ad843f0f3a2"
ZSTD_COMMIT="aec56a52fbab207fc639a1937d1e708a282edca8"


inherit cflags-hardened check-compiler-switch cmake cuda dep-prepare dhms flag-o-matic llvm rocm python-single-r1 toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}/${MYP}"
SRC_URI="
https://github.com/pytorch/${MYPN}/archive/refs/tags/v${PV}.tar.gz
	-> ${MYP}.tar.gz
	!system-libs? (
https://github.com/asmjit/asmjit/archive/${ASMJIT_COMMIT}.tar.gz
	-> asmjit-${ASMJIT_COMMIT:0:7}.tar.gz
https://github.com/dtrugman/pfs/archive/${PFS_COMMIT}.tar.gz
	-> pfs-${PFS_COMMIT:0:7}.tar.gz
https://github.com/facebook/zstd/archive/${ZSTD_COMMIT}.tar.gz
	-> zstd-${ZSTD_COMMIT:0:7}.tar.gz
https://github.com/facebookincubator/dynolog/archive/${DYNOLOG_COMMIT}.tar.gz
	-> dynolog-${DYNOLOG_COMMIT:0:7}.tar.gz
https://github.com/facebookincubator/gloo/archive/${GLOO_COMMIT}.tar.gz
	-> gloo-${GLOO_COMMIT:0:7}.tar.gz
https://github.com/fmtlib/fmt/archive/${FMT_COMMIT_1}.tar.gz
	-> fmt-${FMT_COMMIT_1:0:7}.tar.gz
https://github.com/fmtlib/fmt/archive/${FMT_COMMIT_2}.tar.gz
	-> fmt-${FMT_COMMIT_2:0:7}.tar.gz
https://github.com/fmtlib/fmt/archive/${FMT_COMMIT_3}.tar.gz
	-> fmt-${FMT_COMMIT_3:0:7}.tar.gz
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
https://github.com/gflags/gflags/archive/${GFLAGS_COMMIT}.tar.gz
	-> gflags-${GFLAGS_COMMIT:0:7}.tar.gz
https://github.com/gflags/gflags/archive/${GFLAGS_DOC_COMMIT}.tar.gz
	-> gflags-${GFLAGS_DOC_COMMIT:0:7}.tar.gz
https://github.com/google/glog/archive/${GLOG_COMMIT}.tar.gz
	-> glog-${GLOG_COMMIT:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_1}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_1:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_2}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_2:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_3}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_3:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_4}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_4:0:7}.tar.gz
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
https://github.com/graphitemaster/incbin/archive/${INCBIN_COMMIT}.tar.gz
	-> incbin-${INCBIN_COMMIT:0:7}.tar.gz
https://github.com/houseroad/foxi/archive/${FOXI_COMMIT}.tar.gz
	-> foxi-${FOXI_COMMIT:0:7}.tar.gz
https://github.com/intel/ARM_NEON_2_x86_SSE/archive/${NEON2SSE_COMMIT}.tar.gz
	-> ARM_NEON_2_x86_SSE-${NEON2SSE_COMMIT:0:7}.tar.gz
https://github.com/intel/ideep/archive/${IDEEP_COMMIT}.tar.gz
	-> ideep-${IDEEP_COMMIT:0:7}.tar.gz
https://github.com/intel/ittapi/archive/${ITTAPI_COMMIT}.tar.gz
	-> ittapi-${ITTAPI_COMMIT:0:7}.tar.gz
https://github.com/libcpr/cpr/archive/${CPR_COMMIT}.tar.gz
	-> cpr-${CPR_COMMIT:0:7}.tar.gz
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
https://github.com/microsoft/mimalloc/archive/${MIMALLOC_COMMIT}.tar.gz
	-> mimalloc-${MIMALLOC_COMMIT:0:7}.tar.gz
https://github.com/microsoft/triton-shared/archive/${TRITON_SHARED_COMMIT}.tar.gz
	-> triton-shared-${TRITON_SHARED_COMMIT:0:7}.tar.gz
https://github.com/mreineck/pocketfft/archive/${POCKETFFT_COMMIT}.tar.gz
	-> pocketfft-${POCKETFFT_COMMIT:0:7}.tar.gz
https://github.com/nlohmann/json/archive/${NLOHMANN_COMMIT_1}.tar.gz
	-> nlohmann-json-${NLOHMANN_COMMIT_1:0:7}.tar.gz
https://github.com/nlohmann/json/archive/${NLOHMANN_COMMIT_2}.tar.gz
	-> nlohmann-json-${NLOHMANN_COMMIT_2:0:7}.tar.gz
https://github.com/NVIDIA/cudnn-frontend/archive/${CUDNN_FRONTEND_COMMIT}.tar.gz
	-> cudnn-frontend-${CUDNN_FRONTEND_COMMIT:0:7}.tar.gz
https://github.com/NVIDIA/cutlass/archive/${CUTLASS_COMMIT_1}.tar.gz
	-> cutlass-${CUTLASS_COMMIT_1:0:7}.tar.gz
https://github.com/NVIDIA/cutlass/archive/${CUTLASS_COMMIT_2}.tar.gz
	-> cutlass-${CUTLASS_COMMIT_2:0:7}.tar.gz
https://github.com/NVIDIA/DCGM/archive/${DCGM_COMMIT}.tar.gz
	-> DCGM-${DCGM_COMMIT:0:7}.tar.gz
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
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_5}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_5:0:7}.tar.gz
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
https://github.com/ROCm/aotriton/archive/${AOTRITON_COMMIT}.tar.gz
	-> aotriton-${AOTRITON_COMMIT:0:7}.tar.gz
https://github.com/ROCm/hipify_torch/archive/${HIPIFY_TORCH_COMMIT}.tar.gz
	-> hipify_torch-${HIPIFY_TORCH_COMMIT:0:7}.tar.gz
https://github.com/ROCm/triton/archive/${TRITON_COMMIT}.tar.gz
	-> ROCm-triton-${TRITON_COMMIT:0:7}.tar.gz
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
		Apache-2.0
	)
	(
		all-rights-reserved
		MIT
	)
	(
		Apache-2.0
		Boost-1.0
		BSD
		BSD-2
		MIT
	)
	(
		(
			BSD-2
			custom
		)
		Apache-2.0
		Boost-1.0
		BSD
		HPND
	)
	(
		CC0-1.0
		MIT
	)
	(
		custom
		MIT
	)
	(
		BSD
		BSD-2
		ISC
		MIT
	)
	Apache-2.0
	Boost-1.0
	BSD
	BSD-2
	CC-BY-4.0
	MIT
	PSF-3.3.0
	GPL-3.0
	Unlicense
	ZLIB
	|| (
		Apache-2.0
		BSD
	)
"
# ( Apache-2.0 with exception ) Apache-2.0 Boost-1.0 BSD BSD-2 MIT - third_party/LICENSES_BUNDLED.txt
# ( BSD-2 custom ) Apache-2.0 Boost-1.0 BSD HPND - NOTICE
# all-rights-reserved Apache-2.0 - third_party/kineto/third_party/dynolog/third_party/DCGM/LICENSE
# all-rights-reserved MIT - third_party/miniz-2.1.0/LICENSE
# all-rights-reserved MIT - third_party/cudnn_frontend/LICENSE.txt
# Apache-2.0 - torch/_vendor/packaging/LICENSE.APACHE
# Boost-1.0 - third_party/sleef/LICENSE.txt
# BSD - aten/src/ATen/native/quantized/cpu/qnnpack/LICENSE
# BSD - LICENSE
# BSD BSD-2 ISC MIT - third_party/tensorpipe/third_party/libuv/LICENSE
# BSD-2 - aten/src/ATen/native/quantized/cpu/qnnpack/deps/clog/LICENSE
# CC-BY-4.0 - third_party/tensorpipe/third_party/libuv/LICENSE-docs
# custom MIT - ./third_party/kineto/third_party/dynolog/third_party/fmt/LICENSE.rst
# LGPL-3.0+ GPL-3+ MPL-2.0 - ./third_party/eigen/scripts/relicense.py
# MIT - third_party/FXDIV/LICENSE
# MIT CC0-1.0 - third_party/nlohmann/docs/mkdocs/docs/home/license.md
# PSF-3.3.0 - third_party/kineto/third_party/dynolog/third_party/fmt/doc/python-license.txt
# Unlicense - caffe2/mobile/contrib/libopencl-stub/LICENSE
# GPL-3.0 - third_party/kineto/third_party/dynolog/third_party/cpr/test/LICENSE
# ZLIB - third_party/FBGEMM/third_party/asmjit/LICENSE.md
# ^^ ( Apache-2.0 BSD ) - torch/_vendor/packaging/LICENSE
# The distro's Apache-2.0 license template does not contain all rights reserved.
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
-mimalloc -mkl +nccl +mpi +nnpack +numpy +onednn -openblas -opencl -opencv +openmp
+rccl rocm roctracer -ssl system-libs +tensorpipe +qnnpack test +xnnpack
ebuild_revision_29
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
	amdgpu_targets_gfx942? (
		rocm_6_0
	)
	clang? (
		|| (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
		cpu_flags_arm_bf16? (
			|| (
				${LLVM_COMPAT_ARM_BF16[@]/#/llvm_slot_}
			)
		)
		cpu_flags_arm_dotprod? (
			|| (
				${LLVM_COMPAT[@]/#/llvm_slot_}
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
		cpu_flags_x86_gfni? (
			|| (
				${LLVM_COMPAT[@]/#/llvm_slot_}
			)
		)
		cpu_flags_x86_avx512vbmi? (
			|| (
				${LLVM_COMPAT[@]/#/llvm_slot_}
			)
		)
	)
	cpu_flags_x86_amx? (
		${REQUIRED_USE_AVX512}
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
		xnnpack
	)
	cpu_flags_x86_avx512vl? (
		${REQUIRED_USE_AVX512}
	)
	cpu_flags_x86_avx512vnni? (
		${REQUIRED_USE_AVX512}
		xnnpack
	)
	cpu_flags_x86_gfni? (
		${REQUIRED_USE_AVX512}
		xnnpack
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
		|| (
			(
				${REQUIRED_USE_AVX512}
			)
			cpu_flags_x86_avx2
		)
		rocm? (
			cpu_flags_x86_avx2
		)
	)
	ffmpeg? (
		opencv
	)
	flash-attention? (
		cuda? (
			|| (
				cuda_targets_sm_80
				cuda_targets_sm_90
			)
		)
		rocm? (
			!system-libs
			|| (
				amdgpu_targets_gfx90a
				amdgpu_targets_gfx942
			)
		)
	)
	gloo? (
		distributed
	)
	mimalloc? (
		!system-libs
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
	rocm_6_0? (
		llvm_slot_17
	)
	rocm_5_7? (
		llvm_slot_17
	)
	tensorpipe? (
		distributed
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
				~dev-libs/rocm-core-${pv}:${s}
				~dev-libs/rocr-runtime-${pv}:${s}
				~dev-util/hip-${pv}:${s}[rocm]
				~sci-libs/hipBLAS-${pv}:${s}[rocm]
				~sci-libs/hipBLASLt-${pv}:${s}$(get_rocm_usedep HIPBLASLT)
				~sci-libs/hipCUB-${pv}:${s}[rocm]
				~sci-libs/hipRAND-${pv}:${s}[rocm]
				~sci-libs/hipSOLVER-${pv}:${s}[rocm]
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
					=sci-libs/magma-2.8*:${s}$(get_rocm_usedep MAGMA_2_8)
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
CUDA_11_8_RDEPEND="
(
	=dev-util/nvidia-cuda-toolkit-11.8*:=[profiler]
	=dev-libs/cudnn-8.6*
)
"
CUDA_12_1_RDEPEND="
(
	=dev-util/nvidia-cuda-toolkit-12.1*:=[profiler]
	=dev-libs/cudnn-8.8*
)
"
RDEPEND="
	${PYTHON_DEPS}
	virtual/lapack
	cuda? (
		cuda_targets_auto? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
			)
		)
		cuda_targets_compute_50? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
			)
		)
		cuda_targets_compute_70? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
			)
		)
		cuda_targets_sm_52? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
			)
		)
		cuda_targets_sm_60? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
			)
		)
		cuda_targets_sm_61? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
			)
		)
		cuda_targets_sm_70? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
			)
		)
		cuda_targets_sm_75? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
			)
		)
		cuda_targets_sm_80? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
			)
		)
		cuda_targets_sm_86? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
			)
		)
		cuda_targets_sm_90? (
			|| (
				${CUDA_11_8_RDEPEND}
				${CUDA_12_1_RDEPEND}
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
		virtual/mpi
	)
	numpy? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
	openblas? (
		sci-libs/openblas
	)
	opencl? (
		virtual/opencl
	)
	opencv? (
		media-libs/opencv:=[${PYTHON_SINGLE_USEDEP},python]
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
		>=dev-libs/cpuinfo-2023.11.03
		>=dev-libs/libfmt-10.2.1
		>=dev-libs/protobuf-3.13.1:0/3.21
		dev-libs/protobuf:=
		>=dev-libs/pthreadpool-2023.08.28
		>=dev-libs/sleef-3.6.0[cpu_flags_x86_avx?,cpu_flags_x86_avx2?,cpu_flags_x86_avx512f?,cpu_flags_x86_fma4?,cpu_flags_x86_sse2?,cpu_flags_x86_sse4_1?]
		>=sci-ml/foxi-2021.05.26
		>=sci-ml/onnx-1.16.0
		cuda? (
			>=dev-libs/cudnn-frontend-1.1.2:0/8
		)
		fbgemm? (
			>=sci-ml/FBGEMM-2023.12.04
		)
		gloo? (
			>=sci-ml/gloo-0.5.0[cuda?,mpi?,ssl?]
		)
		mkl? (
			sci-libs/mkl
		)
		nnpack? (
			>=sci-ml/NNPACK-2020.12.21
		)
		onednn? (
			>=sci-ml/oneDNN-3.3.6
		)
		qnnpack? (
			>=sci-libs/QNNPACK-2019.08.28
		)
		tensorpipe? (
			>=sci-ml/tensorpipe-2021.12.27[cuda?]
		)
		xnnpack? (
			>=sci-ml/XNNPACK-2024.02.29[jit?,memopt,sparse]
			cpu_flags_arm_dotprod? (
				cpu_flags_arm_fp16? (
					>=sci-ml/XNNPACK-2024.02.29[assembly]
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
			>=dev-python/pybind11-2.12.0[${PYTHON_USEDEP}]
		')
		>=dev-libs/flatbuffers-23.3.3
		>=sci-ml/FP16-2020.05.14
		>=dev-libs/FXdiv-2020.04.17
		>=dev-libs/pocketfft-2023.12.30
		>=dev-libs/psimd-2020.05.17
		>=sci-ml/kineto-0.4.0_p20240131
		cuda? (
			>=dev-libs/cutlass-3.4.1
		)
		onednn? (
			>=sci-ml/ideep-3.3.6
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
					llvm-runtimes/clang-runtime:${s}[openmp]
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
	>=dev-build/cmake-3.21.0
	!clang? (
		|| (
			$(gen_gcc_bdepend)
		)
		cpu_flags_arm_bf16? (
			>=sys-devel/gcc-10.1
			>=sys-devel/binutils-2.34
		)
		cpu_flags_arm_dotprod? (
			>=sys-devel/gcc-8.1
			>=sys-devel/binutils-2.29
		)
		cpu_flags_arm_fp16? (
			>=sys-devel/gcc-7.1
			>=sys-devel/binutils-2.26
		)
		cpu_flags_arm_i8mm? (
			>=sys-devel/gcc-10.1
			>=sys-devel/binutils-2.34
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
		cpu_flags_riscv_rvv_fp16? (
			>=sys-devel/gcc-14.1
			>=sys-devel/binutils-2.42
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
		cpu_flags_x86_amx? (
			>=sys-devel/gcc-11.1
			>=sys-devel/binutils-2.36
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
		cpu_flags_x86_avx512vbmi? (
			>=sys-devel/gcc-12.1
			>=sys-devel/binutils-2.32
		)
		cpu_flags_x86_avx512vl? (
			>=sys-devel/gcc-5.1
			>=sys-devel/binutils-2.25
		)
		cpu_flags_x86_avx512vnni? (
			>=sys-devel/gcc-12.4
			>=sys-devel/binutils-2.36
		)
		cpu_flags_x86_gfni? (
			>=sys-devel/gcc-8.1
			>=sys-devel/binutils-2.30
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
PATCHES=(
	"${FILESDIR}/${PN}-2.2.2-gentoo.patch"
	"${FILESDIR}/${PN}-1.13.0-install-dirs.patch"
	"${FILESDIR}/${PN}-1.12.0-glog-0.6.0.patch"
	"${FILESDIR}/${PN}-2.3.0-cudnn_include_fix.patch"
	"${FILESDIR}/${PN}-2.1.2-fix-rpath.patch"
	"${FILESDIR}/${PN}-2.1.2-fix-openmp-link.patch"
	"${FILESDIR}/${PN}-2.3.0-rocm-fix-std-cpp17.patch"
	"${FILESDIR}/${PN}-2.2.2-musl.patch"
	"${FILESDIR}/${PN}-2.3.0-CMakeFix.patch"
	"${FILESDIR}/${PN}-2.3.0-fix-rocm-gcc14-clamp.patch"
	"${FILESDIR}/${PN}-2.3.0-optional-hipblaslt.patch"
	"${FILESDIR}/${PN}-2.3.0-fix-libcpp.patch"
	"${FILESDIR}/${PN}-2.3.0-fix-gcc-clang-abi-compat.patch"
	"${FILESDIR}/${PN}-2.3.1-prefixed-install.patch"
	"${FILESDIR}/${PN}-2.5.1-optionalize-simd.patch"
	"${FILESDIR}/${PN}-2.5.1-optionalize-simd-for-fbgemm.patch"
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
	check-compiler-switch_start
	warn_untested_gpu
	if use rocm_6_0 ; then
		LLVM_SLOT="17"
		LLVM_MAX_SLOT="${LLVM_SLOT}"
		ROCM_SLOT="6.0"
		rocm_pkg_setup
	elif use rocm_5_7 ; then
		LLVM_SLOT="17"
		LLVM_MAX_SLOT="${LLVM_SLOT}"
		ROCM_SLOT="5.7"
		rocm_pkg_setup
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
			if has_version "=dev-util/nvidia-cuda-toolkit-12.1*" ; then
				export CC="${CHOST}-gcc-12"
				export CXX="${CHOST}-g++-12"
			elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" ; then
				export CC="${CHOST}-gcc-11"
				export CXX="${CHOST}-g++-11"
			else
				local min_slot

				if use cpu_flags_riscv_rvv || use cpu_flags_riscv_rvv_fp16 ; then
					min_slot=14
				elif use cpu_flags_x86_avx512vbmi || use cpu_flags_x86_avx512vnni ; then
					min_slot=12
				elif use cpu_flags_x86_amx ; then
					min_slot=11
				elif use cpu_flags_arm_bf16 || use cpu_flags_arm_i8mm ; then
					min_slot=10
				elif use cpu_flags_s390_vxe_z14 || use cpu_flags_s390_vxe_z15 ; then
					min_slot=9
				elif use cpu_flags_arm_dotprod || use cpu_flags_x86_gfni || use cpu_flags_arm_sve ; then
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
		eapply "${FILESDIR}/${PN}-2.3.0-exclude-aotriton.patch"
		eapply "${FILESDIR}/${PN}-1.13.1-tensorpipe.patch"
		sed -i \
			-e "/third_party\/gloo/d" \
			"cmake/Dependencies.cmake" \
			|| die
	else
		dep_prepare_mv "${WORKDIR}/ARM_NEON_2_x86_SSE-${NEON2SSE_COMMIT}" "${S}/third_party/neon2sse"

		dep_prepare_mv "${WORKDIR}/aotriton-${AOTRITON_COMMIT}" "${S}/third_party/aotriton"
		dep_prepare_mv "${WORKDIR}/incbin-${INCBIN_COMMIT}" "${S}/third_party/aotriton/third_party/incbin"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_5}" "${S}/third_party/aotriton/third_party/pybind11"
		dep_prepare_mv "${WORKDIR}/triton-${TRITON_COMMIT}" "${S}/third_party/aotriton/third_party/triton"

		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_1}" "${S}/third_party/benchmark"
		dep_prepare_mv "${WORKDIR}/cpuinfo-${CPUINFO_COMMIT_1}" "${S}/third_party/cpuinfo"
		dep_prepare_mv "${WORKDIR}/cudnn-frontend-${CUDNN_FRONTEND_COMMIT}" "${S}/third_party/cudnn_frontend"
		dep_prepare_mv "${WORKDIR}/eigen-${EIGEN_COMMIT}" "${S}/third_party/eigen"
		dep_prepare_mv "${WORKDIR}/flatbuffers-${FLATBUFFERS_COMMIT}" "${S}/third_party/flatbuffers"
		dep_prepare_mv "${WORKDIR}/fmt-${FMT_COMMIT_1}" "${S}/third_party/fmt"
		dep_prepare_mv "${WORKDIR}/foxi-${FOXI_COMMIT}" "${S}/third_party/foxi"

		dep_prepare_mv "${WORKDIR}/FBGEMM-${FBGEMM_COMMIT}" "${S}/third_party/FBGEMM"
		dep_prepare_mv "${WORKDIR}/asmjit-${ASMJIT_COMMIT}" "${S}/third_party/FBGEMM/third_party/asmjit"
		dep_prepare_mv "${WORKDIR}/cpuinfo-${CPUINFO_COMMIT_2}" "${S}/third_party/FBGEMM/third_party/cpuinfo"
		dep_prepare_mv "${WORKDIR}/cutlass-${CUTLASS_COMMIT_2}" "${S}/third_party/FBGEMM/third_party/cutlass"
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

		dep_prepare_mv "${WORKDIR}/dynolog-${DYNOLOG_COMMIT}" "${S}/third_party/kineto/libkineto/third_party/dynolog"
		dep_prepare_mv "${WORKDIR}/cpr-${CPR_COMMIT}" "${S}/third_party/kineto/libkineto/third_party/dynolog/third_party/cpr"
		dep_prepare_mv "${WORKDIR}/DCGM-${DCGM_COMMIT}" "${S}/third_party/kineto/libkineto/third_party/dynolog/third_party/DCGM"
		dep_prepare_mv "${WORKDIR}/fmt-${FMT_COMMIT_3}" "${S}/third_party/kineto/libkineto/third_party/dynolog/third_party/fmt"
		dep_prepare_mv "${WORKDIR}/gflags-${GFLAGS_COMMIT}" "${S}/third_party/kineto/libkineto/third_party/dynolog/third_party/gflags"
		dep_prepare_mv "${WORKDIR}/gflags-${GFLAGS_DOC_COMMIT}" "${S}/third_party/kineto/libkineto/third_party/dynolog/third_party/gflags/doc"
		dep_prepare_mv "${WORKDIR}/glog-${GLOG_COMMIT}" "${S}/third_party/kineto/libkineto/third_party/dynolog/third_party/glog"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_4}" "${S}/third_party/kineto/libkineto/third_party/dynolog/third_party/googletest"
		dep_prepare_mv "${WORKDIR}/json-${NLOHMANN_COMMIT_2}" "${S}/third_party/kineto/libkineto/third_party/dynolog/third_party/json"
		dep_prepare_mv "${WORKDIR}/pfs-${PFS_COMMIT}" "${S}/third_party/kineto/libkineto/third_party/dynolog/third_party/pfs"

		dep_prepare_mv "${WORKDIR}/mimalloc-${MIMALLOC_COMMIT}" "${S}/third_party/mimalloc"
		dep_prepare_mv "${WORKDIR}/NNPACK-${NNPACK_COMMIT}" "${S}/third_party/NNPACK"

		dep_prepare_mv "${WORKDIR}/onnx-${ONNX_COMMIT_1}" "${S}/third_party/onnx"
		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_3}" "${S}/third_party/onnx/third_party/benchmark"
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
		eapply "${FILESDIR}/${PN}-2.3.1-cuda-hardcoded-paths.patch"
		eapply "${FILESDIR}/${PN}-2.3.1-rocm-hardcoded-paths.patch"
	else
		eapply "${FILESDIR}/${PN}-2.3.1-cuda-hardcoded-paths.patch"
		eapply "${FILESDIR}/${PN}-2.3.1-rocm-hardcoded-paths.patch"
		eapply "${FILESDIR}/${PN}-2.3.1-cuda-hardcoded-paths-third-party.patch"
		eapply "${FILESDIR}/${PN}-2.3.1-rocm-hardcoded-paths-third-party.patch"
		eapply "${FILESDIR}/${PN}-2.3.1-aotriton-offline-install.patch"
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
		ebegin "HIPifying cuda sources"
			${EPYTHON} "tools/amd_build/build_amd.py" || die
		eend $?
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
	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append
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
		-DUSE_DISTRIBUTED=$(usex distributed)
		-DUSE_FAKELOWP=OFF
		-DUSE_FBGEMM=$(usex fbgemm)
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_FLASH_ATTENTION=$(usex flash-attention $(usex cuda ON $(usex rocm ON OFF) OFF) OFF)
		-DUSE_GFLAGS=ON
		-DUSE_GLOG=ON
		-DUSE_GLOO=$(usex gloo)
		-DUSE_GLOO_WITH_OPENSSL=$(usex gloo $(usex ssl ON OFF) OFF)
		-DUSE_ITT=OFF
		-DUSE_KINETO=$(usex kineto $(usex system-libs OFF ON) OFF)
		-DUSE_LEVELDB=OFF
		-DUSE_MAGMA=$(usex magma)
		-DUSE_METAL=OFF
		-DUSE_MIMALLOC=$(usex mimalloc)
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
		-DUSE_SYSTEM_CPUINFO=$(usex system-libs)
		-DUSE_SYSTEM_FBGEMM=$(usex system-libs)
		-DUSE_SYSTEM_FLATBUFFERS=$(usex system-libs)
		-DUSE_SYSTEM_FOXI=$(usex system-libs)
		-DUSE_SYSTEM_FP16=$(usex system-libs)
		-DUSE_SYSTEM_FXDIV=$(usex system-libs)
		-DUSE_SYSTEM_GLOO=$(usex system-libs)
		-DUSE_SYSTEM_KINETO=$(usex system-libs)
		-DUSE_SYSTEM_LIBFMT=$(usex system-libs)
		-DUSE_SYSTEM_ONNX=$(usex system-libs)
		-DUSE_SYSTEM_NNPACK=$(usex system-libs)
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
		-DXNNPACK_ENABLE_ARM_BF16_VECTOR=$(usex cpu_flags_arm_bf16)
		-DXNNPACK_ENABLE_ARM_DOTPROD=$(usex cpu_flags_arm_dotprod)
		-DXNNPACK_ENABLE_ARM_FP16_VECTOR=$(usex cpu_flags_arm_fp16)
		-DXNNPACK_ENABLE_ARM_I8MM=$(usex cpu_flags_arm_i8mm)
		-DXNNPACK_ENABLE_ASSEMBLY=$(use_arm_fp16_dotprod)
		-DXNNPACK_ENABLE_AVX512AMX=$(usex cpu_flags_x86_amx)
		-DXNNPACK_ENABLE_AVXVNNI=$(usex cpu_flags_x86_avx512vnni)
		-DXNNPACK_ENABLE_JIT=$(usex jit)
		-DXNNPACK_ENABLE_RISCV_VECTOR=$(usex cpu_flags_riscv_rvv)
		-DXNNPACK_ENABLE_RISCV_FP16_VECTOR=$(usex cpu_flags_riscv_rvv_fp16)
		-DXNNPACK_ENABLE_VSX=$(usex cpu_flags_ppc_vsx)
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

	if use mkl ; then
		mycmakeargs+=(
			-DBLAS="MKL"
		)

		local flags
		flags=""
		if use cpu_flags_x86_sse4_1 ; then
			flags="${flags};SSE41"
		fi
		if use cpu_flags_x86_avx2 ; then
			flags="${flags};AVX2"
		fi
		if use_avx512 ; then
			flags="${flags};AVX512"
		fi
		if use cpu_flags_x86_amx ; then
			flags="${flags};AMX"
		fi
		mycmakeargs+=(
			-DDNNL_ENABLE_PRIMITIVE_CPU_ISA="${flags:1}"
			-DONEDNN_ENABLE_GEMM_KERNELS_ISA="${flags:1}"
		)

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
			-DUSE_CUDNN=ON
			-DTORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-3.5 7.0}"
			-DUSE_NCCL=$(usex nccl)
		)
		if use nccl ; then
ewarn "No nccl package exist in the ecosystem.  You must package nccl locally yourself."
		fi
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

	# Do not rerun cmake and the build process in src_install
	sed '/RERUN/,+1d' -i "${BUILD_DIR}/build.ninja" || die
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
	cp \
		"torch/version.py" \
		"python/torch/" \
		|| die
	rm -rf "${ED}/var/tmp" || die
	python_domodule "python/caffe2"
	python_domodule "python/torch"
	ln -s \
		"../../../../../include/torch" \
		"${D}$(python_get_sitedir)/torch/include/torch" \
		|| die # bug 923269

	# FIXME: fix cmake build scripts and remove below.
	mv \
		"${ED}/usr/include/pybind11" \
		"${ED}/usr/lib/${PN}/include" \
		|| die
	dhms_end
}
