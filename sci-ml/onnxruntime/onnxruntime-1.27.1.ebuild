# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22 - GCC 12.2

# TODO:
# Review and add vendored python packages.
# dawn .gitmodules
# Change configure for re2

# 1.20.0 -> 1.20.2
# 1.20.2 -> 1.26.0
# 1.26.0 -> 1.27.1

# TODO package (optional):
# lintrunner-adapters
# onnxmltools
# pydocstyle
# tensorrt
# torch-ort

# For deps versioning, see
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/cmake/deps.txt
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/tools/ci_build/github/linux/docker/scripts/manylinux/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/onnxruntime/python/tools/transformers/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/cmake/external/dnnl.cmake#L5
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/requirements-dev.txt
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/requirements-doc.txt
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/requirements-lintrunner.txt
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/requirements-training.txt
# https://github.com/google/dawn/blob/511eb80847afe6bded34ec491a38d5d78ba2d604/DEPS
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/dockerfiles/Dockerfile.cuda
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/dockerfiles/Dockerfile.openvino
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/dockerfiles/Dockerfile.rocm
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/dockerfiles/Dockerfile.tensorrt
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/onnxruntime/python/tools/transformers/models/llama/requirements-cuda.txt#L2
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/dockerfiles/README.md#cuda
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/dockerfiles/README.md#openvino
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/dockerfiles/README.md#tensorrt
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/dockerfiles/README.md#rocm
# https://github.com/microsoft/onnxruntime/blob/v1.27.1/tools/ci_build/github/linux/docker/inference/x86_64/python/openvino/Dockerfile#L25

# clog has same version as cpuinfo

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CMAKE_IN_SOURCE_BUILD=1
CXX_STANDARD=17
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
LLVM_OPTIONAL=1
PYTHON_COMPAT=( "python3_"{10..12} )
RE2_SLOT="20250512"

ABSEIL_CPP_PV_2="20250814.0" # From cmake/deps.txt
BENCHMARK_PV="1.8.5" # onnxruntime dep
COREMLTOOLS_PV="7.1" # From cmake/deps.txt
CUDNN_FRONTEND_PV="1.12.0" # From cmake/deps.txt as cudnn_frontend
CUTLASS_PV="4.4.2" # From cmake/deps.txt
DATE_PV_1="3.0.1" # From cmake/deps.txt
DIRECTX_HEADERS_PV="1.613.1"
DUKTAPE_PV="2.7.0" # From From cmake/deps.txt
EMSDK_PV="4.0.23" # From .gitmodules
FLATBUFFERS_PV="23.5.26" # From cmake/deps.txt
GOOGLETEST_PV_1="1.17.0" # From cmake/deps.txt
GSL_PV="4.2.1" # From cmake/deps.txt
JSON_PV="3.11.3" # From cmake/deps.txt
KLEIDIAI_PV="1.20.0" # From cmake/deps.txt
MP11_PV="1.82.0" # From cmake/deps.txt
ONNX_PV_1="1.21.0" # From .gitmodules or cmake/deps.txt
MIMALLOC_PV="2.1.1" # From cmake/deps.txt
OPENVINO_PV="2026.1.0"
PROTOBUF_PV_1="21.12" # From cmake/deps.txt
PYBIND11_PV="3.0.2" # From cmake/deps.txt, onnxruntime dep
RE2_PV="2024-07-02" # From cmake/deps.txt
SAFEINT_PV="3.0.28" # From cmake/deps.txt
VULKAN_HEADERS_PV="1.4.344" # From cmake/deps.txt
WIL_PV="1.0.250325.1" # From cmake/deps.txt as microsoft_wil

LIBPROTOBUF_MUTATOR_COMMIT_1="7a2ed51a6b682a83e345ff49fc4cfd7ca47550db" # From .gitmodules

CPUINFO_COMMIT="403d652dca4c1046e8145950b1c0997a9f748b57" # From cmake/deps.txt
CXXOPTS_COMMIT="3c73d91c0b04e2b59462f0a741be8c07024c1bc0" # From cmake/deps.txt
DLPACK_COMMIT_2="5c210da409e7f1e51ddf445134a4376fdbd70d7d" # From cmake/deps.txt
EIGEN_COMMIT="1d8b82b0740839c0de7f1242a3585e3390ff5f33" # From cmake/deps.txt
FP16_COMMIT="0a92994d729ff76a58f692d3028ca1b64b145d91" # From cmake/deps.txt
FXDIV_COMMIT="63058eff77e11aa15bf531df5dd34395ec3017c8" # From cmake/deps.txt
KLEIDIAI_QMX_COMMIT="2f10c9a8d32f81ffeeb6d4885a29cc35d2b0da87" # From cmake/deps.txt
PSIMD_COMMIT="072586a71b55b7f8c584153d223e95687148a900" # From cmake/deps.txt
ONNX_TENSORRT_COMMIT="d5dce67db7c2e64b07e055571f5ec06f7f254de2" # From cmake/deps.txt
ONNXRUNTIME_EXTENSIONS_COMMIT="c24b7bab0c12f53da76d0c31b03b9f0f8ec8f3b4" # From cmake/deps.txt
PTHREADPOOL_COMMIT="dcc9f28589066af0dbd4555579281230abbf74dd" # From cmake/deps.txt
TENSORBOARD_COMMIT="373eb09e4c5d2b3cc2493f0949dc4be6b6a45e81" # From cmake/deps.txt
XNNPACK_COMMIT="3cf85e705098622d59056dcb8f5f963ea7bb0a00" # From cmake/deps.txt

ONNX_COMMIT_1="dfba0ad9ca26d584a8b71e3f4569fd62f85c2932" # external/onnx-tensorrt dep
PYBIND11_COMMIT_1="a2e59f0e7065404b44dfe92a28aca47ba1378dc4" # external/onnx-tensorrt/onnx dep

BENCHMARK_COMMIT_3="5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8" # external/protobuf dep
GOOGLETEST_COMMIT_5="5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081" # external/protobuf dep

BENCHMARK_COMMIT_2="0d98dba29d66e93259db7daa53a9327df767a415" # external/flatbuffers dep, from cmake/external/flatbuffers/benchmarks/CMakeLists.txt
GOOGLETEST_COMMIT_3="e2239ee6043f73722e7aa812a459f54a28552929" # external/flatbuffers from cmake/external/flatbuffers/benchmarks/CMakeLists.txt, or dawn/swiftshader dep, dawn/angle/swiftshader dep, dawn/angle/astc-encoder dep, dawn/angle/dawn/swiftshader dep

AMDGPU_TARGETS_COMPAT=(
# See https://github.com/microsoft/onnxruntime/blob/v1.27.1/cmake/CMakeLists.txt#L299
	"gfx906"
	"gfx908"
	"gfx90a" # ck
	#"gfx942" # ck
	"gfx1030"
	"gfx1100"
	"gfx1101"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	#${LIBCXX_COMPAT_CXX17_CUDA_12_6[@]/llvm_slot_} # 18
	#${LIBCXX_COMPAT_CXX17_ROCM_6_4[@]/llvm_slot_} # 19
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}" # 18, 19
)

CPU_FLAGS_X86=(
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512"
)

CUDA_TARGETS_COMPAT=(
# See https://github.com/microsoft/onnxruntime/blob/v1.27.1/cmake/CMakeLists.txt#L1453
	"sm_30"
	"sm_37"
	"sm_50"
	"sm_52"
	"sm_53"
	"sm_60"
	"sm_62"
	"sm_70"
	"sm_72"
	"sm_75"
	"sm_87"
	"sm_80"
	"sm_90"
)

OPENVINO_TARGETS=(
	"cpu"
	"cpu_np"
	"gpu"
	"gpu_np"
	"npu"
	"npu_np"
)

ROCM_SLOTS=(
	"rocm_6_4"
)

inherit cflags-hardened check-compiler-switch cmake cuda dep-prepare distutils-r1 flag-o-matic libcxx-slot libstdcxx-slot llvm-r1 rocm toolchain-funcs

KEYWORDS="~amd64"

SRC_URI+="
https://codeload.github.com/KhronosGroup/Vulkan-Headers/tar.gz/refs/tags/v1.4.344
	-> Vulkan-Headers-${VULKAN_HEADERS_PV}.tar.gz

https://github.com/apple/coremltools/archive/refs/tags/${COREMLTOOLS_PV}.tar.gz
	-> coremltools-${COREMLTOOLS_PV}.tar.gz
https://github.com/boostorg/mp11/archive/refs/tags/boost-${MP11_PV}.tar.gz
	-> mp11-${MP11_PV}.tar.gz
https://github.com/dcleblanc/SafeInt/archive/${SAFEINT_PV}.tar.gz
	-> SafeInt-${SAFEINT_PV}.tar.gz
https://github.com/dmlc/dlpack/archive/${DLPACK_COMMIT_2}.tar.gz
	-> dlpack-${DLPACK_COMMIT_2:0:7}.tar.gz
https://github.com/emscripten-core/emsdk/archive/refs/tags/${EMSDK_PV}.tar.gz
	-> emsdk-${EMSDK_PV}.tar.gz
https://github.com/google/flatbuffers/archive/v${FLATBUFFERS_PV}.tar.gz
	-> flatbuffers-${FLATBUFFERS_PV}.tar.gz
https://github.com/google/libprotobuf-mutator/archive/${LIBPROTOBUF_MUTATOR_COMMIT_1}.tar.gz
	-> libprotobuf-mutator-${LIBPROTOBUF_MUTATOR_COMMIT_1:0:7}.tar.gz
https://github.com/google/re2/archive/refs/tags/${RE2_PV}.tar.gz
	-> re2-${RE2_PV}.tar.gz
https://github.com/HowardHinnant/date/archive/v${DATE_PV_1}.tar.gz
	-> HowardHinnant-date-${DATE_PV_1}.tar.gz
https://github.com/jarro2783/cxxopts/archive/${CXXOPTS_COMMIT}.tar.gz
	-> cxxopts-${CXXOPTS_COMMIT:0:7}.tar.gz
https://github.com/microsoft/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v${DIRECTX_HEADERS_PV}.tar.gz
	-> DirectX-Headers-${DIRECTX_HEADERS_PV}.tar.gz
https://github.com/microsoft/GSL/archive/refs/tags/v${GSL_PV}.tar.gz
	-> microsoft-gsl-${GSL_PV}.tar.gz
https://github.com/microsoft/wil/archive/refs/tags/v${WIL_PV}.tar.gz
	-> microsoft-wil-${WIL_PV}.tar.gz
https://github.com/nlohmann/json/archive/refs/tags/v${JSON_PV}.tar.gz
	-> nlohmann-json-${JSON_PV}.tar.gz

https://github.com/onnx/onnx/archive/${ONNX_COMMIT_1}.tar.gz
	-> onnx-${ONNX_COMMIT_1:0:7}.tar.gz
https://github.com/onnx/onnx/archive/refs/tags/v${ONNX_PV_1}.tar.gz
	-> onnx-${ONNX_PV_1}.tar.gz

https://github.com/protocolbuffers/protobuf/archive/refs/tags/v${PROTOBUF_PV_1}.tar.gz
	-> protobuf-${PROTOBUF_PV_1}.tar.gz
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-win64.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-win32.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-linux-x86_64.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-linux-x86_32.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-linux-aarch_64.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-osx-universal_binary.zip

https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_1}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_1:0:7}.tar.gz
https://github.com/pytorch/cpuinfo/archive/${CPUINFO_COMMIT}.tar.gz
	-> pytorch-cpuinfo-${CPUINFO_COMMIT:0:7}.tar.gz
https://github.com/qualcomm/kleidiai/archive/${KLEIDIAI_QMX_COMMIT}.tar.gz
	-> kleidiai-qmx-${KLEIDIAI_QMX_COMMIT:0:7}.tar.gz
https://github.com/svaarala/duktape/releases/download/v${DUKTAPE_PV}/duktape-${DUKTAPE_PV}.tar.xz
	-> duktape-${DUKTAPE_PV}.tar.xz
https://gitlab.arm.com/kleidi/kleidiai/-/archive/v${KLEIDIAI_PV}/kleidiai-v${KLEIDIAI_PV}.tar.gz
	-> kleidiai-${KLEIDIAI_PV}.tar.gz

	!system-eigen? (
https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_COMMIT}/eigen-${EIGEN_COMMIT}.tar.gz
	-> eigen-${EIGEN_COMMIT:0:7}.tar.gz
	)
	abseil-cpp? (
https://github.com/abseil/abseil-cpp/archive/${ABSEIL_CPP_PV_2}.tar.gz
	-> abseil-cpp-${ABSEIL_CPP_PV_2}.tar.gz
	)

	benchmark? (
https://github.com/google/benchmark/archive/refs/tags/v${BENCHMARK_PV}.tar.gz
	-> benchmark-${BENCHMARK_PV}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_3}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_3:0:7}.tar.gz
	)
	cuda? (
https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v${CUDNN_FRONTEND_PV}.tar.gz
	-> cudnn-frontend-${CUDNN_FRONTEND_PV}.tar.gz
https://github.com/NVIDIA/cutlass/archive/refs/tags/v${CUTLASS_PV}.tar.gz
	-> cutlass-${CUTLASS_PV}.tar.gz
	)
	extensions? (
https://github.com/microsoft/onnxruntime-extensions/archive/${ONNXRUNTIME_EXTENSIONS_COMMIT}.tar.gz
	-> onnxruntime-extensions-${ONNXRUNTIME_EXTENSIONS_COMMIT:0:7}.tar.gz
	)
	mimalloc? (
https://github.com/microsoft/mimalloc/archive/refs/tags/v${MIMALLOC_PV}.tar.gz
	-> mimalloc-${MIMALLOC_PV}.tar.gz
	)
	python? (
https://github.com/pybind/pybind11/archive/refs/tags/v${PYBIND11_PV}.tar.gz
	-> pybind11-${PYBIND11_PV}.tar.gz
	)
	tensorrt-oss-parser? (
https://github.com/onnx/onnx-tensorrt/archive/${ONNX_TENSORRT_COMMIT}.tar.gz
	-> onnx-tensorrt-${ONNX_TENSORRT_COMMIT:0:7}.tar.gz
	)
	test? (
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_3}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_3:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_5}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_5:0:7}.tar.gz
https://github.com/google/googletest/archive/refs/tags/v${GOOGLETEST_PV_1}.tar.gz
	-> googletest-${GOOGLETEST_PV_1}.tar.gz
	)
	training? (
https://github.com/tensorflow/tensorboard/archive/${TENSORBOARD_COMMIT}.tar.gz
	-> tensorboard-${TENSORBOARD_COMMIT:0:7}.tar.gz
	)
	xnnpack? (
https://github.com/Maratyszcza/FP16/archive/${FP16_COMMIT}.tar.gz
	-> fp16-${FP16_COMMIT:0:7}.tar.gz
https://github.com/Maratyszcza/FXdiv/archive/${FXDIV_COMMIT}.tar.gz
	-> fxdiv-${FXDIV_COMMIT:0:7}.tar.gz
https://github.com/Maratyszcza/psimd/archive/${PSMID_COMMIT}.tar.gz
	-> psimd-${PSIMD_COMMIT:0:7}.tar.gz
https://github.com/Maratyszcza/pthreadpool/archive/${PTHREADPOOL_COMMIT}.tar.gz
	-> pthreadpool-${PTHREADPOOL_COMMIT:0:7}.tar.gz
https://github.com/google/XNNPACK/archive/${XNNPACK_COMMIT}.tar.gz
	-> xnnpack-${XNNPACK_COMMIT:0:7}.tar.gz
	)
"

DESCRIPTION="Cross-platform inference and training machine-learning accelerator."
HOMEPAGE="
	https://onnxruntime.ai
	https://github.com/microsoft/onnxruntime
"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	Boost-1.0
	BSD
	BSD-2
	CC-BY-3.0
	CC-BY-4.0
	CC-PD
	CC0-1.0
	custom
	HPND
	ISC
	ISSL
	JSON
	LGPL-3+
	MIT
	MPL-2.0
	Ms-PL
	public-domain
	Unlicense
	UoI-NCSA
	ZLIB
"
# ThirdPartyNotices.txt -
#	custom
#	(
#		all-rights-reserved
#		MIT
#	)
#	Apache-2.0
#	Boost-1.0
#	BSD
#	BSD-2
#	CC-PD
#	HPND
#	ISC
#	ISSL
#	JSON
#	MIT
#	MPL-2.0
#	public-domain
#	Unlicense
#	UoI-NCSA
#	ZLIB
# all-rights-reserved Apache-2.0 - onnxruntime/core/common/status.cc
# CC-BY-3.0 CC-BY-4.0 - winml/test/collateral/images/LICENSE.md
# CC0-1.0 MIT - cmake/external/json/doc/mkdocs/docs/home/license.md
# custom - dockerfiles/LICENSE-IMAGE.txt
# custom keywords:  The copyright holders provide no reassurances
# LGPL-3+ MPL-2.0 cmake/external/eigen/scripts/relicense.py
# Ms-PL - cmake/external/safeint/Archive/license/license.json
# The distro's Apache-2.0 license template does not contain all rights reserved.
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror test" # Untested
SLOT="0"
IUSE="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
${CPU_FLAGS_X86[@]}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${OPENVINO_TARGETS[@]/#/openvino_targets_}
${ROCM_SLOTS[@]}
-abseil-cpp -benchmark -composable-kernel cpu -cuda cudnn debug doc -extensions
-javascript -llvm -lto -migraphx -mimalloc -mpi -onednn -openvino
+python -quant -rocm -system-eigen -system-composable-kernel test -tensorrt
-tensorrt-oss-parser -training training-ort -triton -xnnpack

openvino-auto
openvino-hetero
openvino-multi
ebuild_revision_30
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
# For providers, see also https://github.com/microsoft/onnxruntime/blob/v1.27.1/onnxruntime/test/perftest/command_args_parser.cc#L40
# abseil-cpp is required for protobuf and still links to it if disabled.
# webgpu banned because the G repo servers removed tarball downloads.
REQUIRED_USE="
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	abseil-cpp
	composable-kernel? (
		amdgpu_targets_gfx90a
		rocm
	)
	cuda? (
		cudnn
		!lto
		^^ (
			${LIBCXX_COMPAT_CXX17_CUDA_12_6[@]}
		)
	)
	cudnn? (
		cuda
	)
	javascript? (
		llvm_slot_18
	)
	openvino? (
		|| (
			openvino_targets_cpu
			openvino_targets_cpu_np
			openvino_targets_gpu
			openvino_targets_gpu_np
			openvino_targets_npu
			openvino_targets_npu_np
		)
		|| (
			openvino-auto
			openvino-hetero
			openvino-multi
		)
	)
	quant? (
		python
	)
	rocm? (
		llvm_slot_19
		migraphx
		^^ (
			${LIBCXX_COMPAT_CXX17_ROCM_6_4[@]}
		)
	)
	tensorrt-oss-parser? (
		cuda
		tensorrt
	)
	test? (
		python
	)
	triton? (
		python
	)
	|| (
		cpu
		cudnn
		migraphx
		onednn
		openvino
		rocm
		tensorrt
		xnnpack
	)
"
gen_rocm_rdepend() {
	local pv
	for pv in ${HIP_SLOTS[@]} ; do
		local s="0/"$(ver_cut 1-2 ${pv})
		local u=$(ver_cut 1-2 ${pv})
		u="${u/./_}"
	# Check both the direct top and indirect bottom dependencies
		echo "
			rocm_${u}? (
				>=dev-libs/rccl-${pv}:${s}[$(get_rocm_usedep RCCL)]
				dev-libs/rccl:=
				>=dev-libs/rocr-runtime-${pv}:${s}
				dev-libs/rocr-runtime:=
				>=dev-util/hip-${pv}:${s}[rocm]
				dev-util/hip:=
				>=dev-util/rocm-smi-${pv}:${s}
				dev-util/rocm-smi:=
				>=dev-util/roctracer-${pv}:${s}
				dev-util/roctracer:=
				>=sci-libs/hipCUB-${pv}:${s}[$(get_rocm_usedep HIPCUB)]
				sci-libs/hipCUB:=
				>=sci-libs/hipFFT-${pv}:${s}[$(get_rocm_usedep HIPFFT)]
				sci-libs/hipFFT:=
				>=sci-libs/hipRAND-${pv}:${s}[rocm]
				sci-libs/hipRAND:=
				>=sci-libs/miopen-${pv}:${s}[$(get_rocm_usedep MIOPEN)]
				sci-libs/miopen:=
				>=sci-libs/rocBLAS-${pv}:${s}[$(get_rocm_usedep ROCBLAS)]
				sci-libs/rocBLAS:=
				system-composable-kernel? (
					sci-libs/composable-kernel:${s}[$(get_rocm_usedep COMPOSABLE_KERNEL)]
					sci-libs/composable-kernel:=
				)
			)
		"
		if use amdgpu_targets_gfx90a ; then
			echo "
				>=sci-libs/hipBLASLt-${pv}:${s}[$(get_rocm_usedep HIPBLASLT)]
				sci-libs/hipBLASLt:=
			"
		fi
	done
}
DISABLED_RDEPEND="
	(
		>=dev-cpp/ms-gsl-4.0.0
		dev-cpp/ms-gsl:=
	)
	(
		>=dev-cpp/nlohmann_json-3.10.5
		dev-cpp/nlohmann_json:=
	)
	(
		>=dev-libs/clog-2024.07.09
		dev-libs/clog:=
	)
	(
		>=dev-libs/cpuinfo-2024.07.09
		dev-libs/cpuinfo:=
	)
	(
		>=dev-libs/date-3.0.1
		dev-libs/date:=
	)
	(
		>=dev-libs/flatbuffers-23.5.26
		dev-libs/flatbuffers:=
	)
	(
		>=dev-libs/protobuf-21.12:0/3.21
		dev-libs/protobuf:=
	)
	>=sci-ml/FP16-2021.03.16
	>=dev-libs/FXdiv-2020.12.08
	>=dev-libs/re2-0.2024.07.02:${RE2_SLOT}
	benchmark? (
		>=dev-cpp/benchmark-1.8.5
	)
	xnnpack? (
		>=sci-ml/XNNPACK-2023.10.19
	)
"
RDEPEND="
	${PYTHON_DEPS}
	(
		!python? (
			>=sci-ml/onnx-1.16.1[disableStaticReg]
		)
		python? (
			$(python_gen_cond_dep '
				>=sci-ml/onnx-1.16.1[${PYTHON_USEDEP},disableStaticReg]
			')
		)
		sci-ml/onnx:=
	)
	(
		>=sys-cluster/openmpi-4.0.0[cuda?]
		sys-cluster/openmpi:=
	)
	>=sci-ml/pytorch-1.13.1[${PYTHON_SINGLE_USEDEP}]
	app-admin/chrpath
	virtual/numpy
	cuda? (
		|| (
			(
				>=x11-drivers/nvidia-drivers-560.35
				=dev-util/nvidia-cuda-toolkit-12.6*
				!python? (
					>=sci-ml/pytorch-2.6.0[${PYTHON_SINGLE_USEDEP}]
				)
				cudnn? (
					>=dev-libs/cudnn-9.5
				)
				python? (
					>=sci-ml/pytorch-2.6.0[${PYTHON_SINGLE_USEDEP}]
				)
				virtual/cuda-compiler:0/12.6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			)
		)
		dev-util/nvidia-cuda-toolkit:=
		virtual/cuda-compiler:=
	)
	cudnn? (
		dev-libs/cudnn:=
	)
	javascript? (
		llvm_slot_18? (
			>=dev-util/emscripten-3.1.59:18-3.1
		)
	)
	onednn? (
		>=sci-ml/oneDNN-3.0.1
		sci-ml/oneDNN:=
	)
	openvino? (
		>=sci-ml/openvino-${OPENVINO_PV}[${PYTHON_SINGLE_USEDEP}]
		openvino_targets_gpu? (
			>=sci-ml/openvino-${OPENVINO_PV}[${PYTHON_SINGLE_USEDEP},video_cards_intel]
		)
		openvino_targets_npu? (
			>=sci-ml/openvino-${OPENVINO_PV}[${PYTHON_SINGLE_USEDEP},npu]
		)
	)
	rocm? (
		$(gen_rocm_rdepend)
		rocm_6_4? (
			!python? (
				|| (
					=sci-ml/pytorch-2.3*[${PYTHON_SINGLE_USEDEP}]
				)
			)
			python? (
				|| (
					=sci-ml/pytorch-2.3*[${PYTHON_SINGLE_USEDEP}]
				)
			)
		)
	)
	system-eigen? (
		>=dev-cpp/eigen-3.4.0[cuda?]
		dev-cpp/eigen:=
	)
	tensorrt? (
		>=dev-util/tensorrt-8.5.1
		=dev-util/nvidia-cuda-toolkit-11.8*
		dev-util/tensorrt:=
	)
	python? (
		>=sci-ml/transformers-4.18.0[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			training? (
				dev-python/cerberus[${PYTHON_USEDEP}]
				dev-python/h5py[${PYTHON_USEDEP}]
				sci-ml/onnx[${PYTHON_USEDEP}]
				virtual/numpy[${PYTHON_USEDEP}]
			)
			>=dev-python/flatbuffers-23.5.26[${PYTHON_USEDEP}]
			>=dev-python/sympy-1.12[${PYTHON_USEDEP}]
			dev-python/coloredlogs[${PYTHON_USEDEP}]
			dev-python/packaging[${PYTHON_USEDEP}]
			dev-python/protobuf:=[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/py-cpuinfo[${PYTHON_USEDEP}]
			virtual/numpy[${PYTHON_USEDEP}]
		')
		quant? (
			dev-python/neural-compressor[${PYTHON_SINGLE_USEDEP}]
		)
		training? (
			>=sci-ml/pytorch-1.13.1[${PYTHON_SINGLE_USEDEP}]
			sci-ml/pytorch-ort[${PYTHON_SINGLE_USEDEP}]
		)
		triton? (
			dev-python/triton[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	dev-util/patchelf
	sys-devel/gcc:12
	$(python_gen_cond_dep '
		>=dev-python/setuptools-68.2.2[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
	doc? (
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-gallery[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
	)
	test? (
		$(python_gen_cond_dep '
			>=dev-python/parameterized-0.8.1[${PYTHON_USEDEP}]
			>=dev-python/black-24.2.0[${PYTHON_USEDEP}]
			>=dev-python/isort-5.13.2[${PYTHON_USEDEP}]
			dev-python/jinja2[${PYTHON_USEDEP}]
			dev-python/mypy[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/scikit-learn[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]

			>=dev-util/ruff-0.5.4
			dev-python/clang-format[${PYTHON_USEDEP}]
			dev-python/lintrunner-adapters[${PYTHON_USEDEP}]
		')
	)
"
_PATCHES=(
	"${FILESDIR}/${PN}-1.26.0-onnx_proto-visibility.patch"
)

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
	use llvm && llvm-r1_pkg_setup

	if use rocm_6_4 ; then
		LLVM_SLOT="19"
		ROCM_SLOT="6.4"
		export ROCM_VERSION="${HIP_6_4_VERSION}"
	fi

	use rocm && rocm_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

_unpack() {
	local ARGS=( ${A} )

	local PROTOC_TARBALLS=(
		"protoc-${PROTOBUF_PV_1}-win32.zip;protoc_win32-${PROTOBUF_PV_1}"
		"protoc-${PROTOBUF_PV_1}-win64.zip;protoc_win64-${PROTOBUF_PV_1}"
		"protoc-${PROTOBUF_PV_1}-linux-aarch_64.zip;protoc_linux_aarch64-${PROTOBUF_PV_1}"
		"protoc-${PROTOBUF_PV_1}-linux-x86_32.zip;protoc_linux_x86-${PROTOBUF_PV_1}"
		"protoc-${PROTOBUF_PV_1}-linux-x86_64.zip;protoc_linux_x64-${PROTOBUF_PV_1}"
		"protoc-${PROTOBUF_PV_1}-osx-universal_binary.zip;protoc_mac_universal-${PROTOBUF_PV_1}"
	)

	local f
	for f in ${ARGS[@]} ; do
		local is_no_root_submodule=0
		local is_protoc_submodule=0
		local row

		[[ -e "${DISTDIR}/${f}" ]] || continue

		for row in ${PROTOC_TARBALLS[@]} ; do
			local f2="${row%;*}"
			local path="${row#*;}"
			if [[ "${f}" == "${f2}" ]] ; then
				mkdir -p "${WORKDIR}/${path}" || die
				pushd "${WORKDIR}/${path}" >/dev/null 2>&1 || die
					unpack "${f}"
				popd >/dev/null 2>&1 || die
				is_protoc_submodule=1
				break
			fi
		done

		if (( ${is_no_root_submodule} == 0 && ${is_protoc_submodule} == 0 )) ; then
			unpack "${f}"
		fi
	done
}

src_unpack_external_modules() { # .gitmodules
# ${S}/cmake/external for https://github.com/microsoft/onnxruntime/blob/v1.27.1/.gitmodules
	dep_prepare_cp "${WORKDIR}/emsdk-${EMSDK_PV}"							"${S}/cmake/external/emsdk"
	dep_prepare_cp "${WORKDIR}/libprotobuf-mutator-${LIBPROTOBUF_MUTATOR_COMMIT_1}"			"${S}/cmake/external/libprotobuf-mutator"
	dep_prepare_cp "${WORKDIR}/onnx-${ONNX_PV_1}"							"${S}/cmake/external/onnx"
}

src_unpack_external_deps() { # *cmake/deps.txt*
# ${S}/cmake/external for https://github.com/microsoft/onnxruntime/blob/v1.27.1/cmake/deps.txt
	dep_prepare_cp "${WORKDIR}/coremltools-${COREMLTOOLS_PV}"					"${S}/cmake/external/coremltools"
	dep_prepare_cp "${WORKDIR}/cpuinfo-${CPUINFO_COMMIT}"						"${S}/cmake/external/pytorch_cpuinfo"
	dep_prepare_cp "${WORKDIR}/date-${DATE_PV_1}"							"${S}/cmake/external/date-1"
	dep_prepare_cp "${WORKDIR}/DirectX-Headers-${DIRECTX_HEADERS_PV}"				"${S}/cmake/external/directx_headers"
	dep_prepare_cp "${WORKDIR}/duktape-${DUKTAPE_PV}"						"${S}/cmake/external/duktape"
	dep_prepare_cp "${WORKDIR}/dlpack-${DLPACK_COMMIT_2}"						"${S}/cmake/external/dlpack"
	dep_prepare_cp "${WORKDIR}/flatbuffers-${FLATBUFFERS_PV}"					"${S}/cmake/external/flatbuffers"
	dep_prepare_cp "${WORKDIR}/GSL-${GSL_PV}"							"${S}/cmake/external/microsoft_gsl"
	dep_prepare_cp "${WORKDIR}/json-${JSON_PV}"							"${S}/cmake/external/json"
	dep_prepare_cp "${WORKDIR}/kleidiai-v${KLEIDIAI_PV}"						"${S}/cmake/external/kleidiai"
	dep_prepare_cp "${WORKDIR}/kleidiai-${KLEIDIAI_QMX_COMMIT}"					"${S}/cmake/external/kleidiai-qmx"
	dep_prepare_cp "${WORKDIR}/mp11-boost-${MP11_PV}"						"${S}/cmake/external/mp11"

	dep_prepare_cp "${WORKDIR}/protobuf-${PROTOBUF_PV_1}"						"${S}/cmake/external/protobuf"

	dep_prepare_cp "${WORKDIR}/protoc_win64-${PROTOBUF_PV_1}"					"${S}/cmake/external/protoc_win64"
	dep_prepare_cp "${WORKDIR}/protoc_win32-${PROTOBUF_PV_1}"					"${S}/cmake/external/protoc_win32"
	dep_prepare_cp "${WORKDIR}/protoc_linux_x64-${PROTOBUF_PV_1}"					"${S}/cmake/external/protoc_linux_x64"
	dep_prepare_cp "${WORKDIR}/protoc_linux_x86-${PROTOBUF_PV_1}"					"${S}/cmake/external/protoc_linux_x86"
	dep_prepare_cp "${WORKDIR}/protoc_linux_aarch64-${PROTOBUF_PV_1}"				"${S}/cmake/external/protoc_linux_aarch64"
	dep_prepare_cp "${WORKDIR}/protoc_mac_universal-${PROTOBUF_PV_1}"				"${S}/cmake/external/protoc_mac_universal"

	dep_prepare_cp "${WORKDIR}/re2-${RE2_PV}"							"${S}/cmake/external/re2"
	dep_prepare_cp "${WORKDIR}/SafeInt-${SAFEINT_PV}"						"${S}/cmake/external/safeint"

	dep_prepare_cp "${WORKDIR}/Vulkan-Headers-${VULKAN_HEADERS_PV}"					"${S}/cmake/external/vulkan_headers"

	dep_prepare_cp "${WORKDIR}/wil-${WIL_PV}"							"${S}/cmake/external/microsoft_wil"

	if use abseil-cpp ; then
		dep_prepare_cp "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_PV_2}"				"${S}/cmake/external/abseil_cpp"
	fi
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_PV}"					"${S}/cmake/external/google_benchmark"
	fi
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_3}"				"${S}/cmake/external/protobuf/third_party/benchmark"
	fi
	if use cuda ; then
		dep_prepare_cp "${WORKDIR}/cudnn-frontend-${CUDNN_FRONTEND_PV}"				"${S}/cmake/external/cudnn-frontend"
		dep_prepare_cp "${WORKDIR}/cutlass-${CUTLASS_PV}"					"${S}/cmake/external/cutlass"
	fi
	if ! use system-eigen ; then
		dep_prepare_cp "${WORKDIR}/eigen-${EIGEN_COMMIT}"					"${S}/cmake/external/eigen"
	fi
	if use extensions ; then
		dep_prepare_cp "${WORKDIR}/onnxruntime-extensions-${ONNXRUNTIME_EXTENSIONS_COMMIT}"	"${S}/cmake/external/extensions"
	fi
	if use mimalloc ; then
		dep_prepare_cp "${WORKDIR}/mimalloc-${MIMALLOC_PV}"					"${S}/cmake/external/mimalloc"
	fi
	if use python ; then
		dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_PV}"					"${S}/cmake/external/pybind11"
	fi
	if use tensorrt-oss-parser ; then
		dep_prepare_cp "${WORKDIR}/onnx-tensorrt-${ONNX_TENSORRT_COMMIT}"			"${S}/cmake/external/onnx_tensorrt"
	fi
	if use training ; then
		dep_prepare_cp "${WORKDIR}/tensorboard-${TENSORBOARD_COMMIT}"				"${S}/cmake/external/tensorboard"
	fi
	if use test || use training ; then
		dep_prepare_cp "${WORKDIR}/cxxopts-${CXXOPTS_COMMIT}"					"${S}/cmake/external/cxxopts"
	fi
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_PV_1}"				"${S}/cmake/external/googletest" # For onnxruntime_external_deps.cmake
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_5}"				"${S}/cmake/external/protobuf/third_party/googletest"
	fi
	if use xnnpack ; then
		dep_prepare_cp "${WORKDIR}/FP16-${FP16_COMMIT}"						"${S}/cmake/external/fp16"
		dep_prepare_cp "${WORKDIR}/FXdiv-${FXDIV_COMMIT}"					"${S}/cmake/external/fxdiv"
		dep_prepare_cp "${WORKDIR}/psimd-${PSIMD_COMMIT}"					"${S}/cmake/external/psimd"
		dep_prepare_cp "${WORKDIR}/XNNPACK-${XNNPACK_COMMIT}"					"${S}/cmake/external/googlexnnpack"
		dep_prepare_cp "${WORKDIR}/pthreadpool-${PTHREADPOOL_COMMIT}"				"${S}/cmake/external/pthreadpool"
	fi

	if use tensorrt-oss-parser ; then
		dep_prepare_cp "${WORKDIR}/onnx-${ONNX_COMMIT_1}"					"${S}/cmake/external/onnx_tensorrt/third_party/onnx"
		dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1}"				"${S}/cmake/external/onnx_tensorrt/third_party/onnx/third_party/pybind11"
	fi

	if use test ; then
# See https://github.com/google/flatbuffers/blob/v23.5.26/benchmarks/CMakeLists.txt
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_3}"				"${S}/cmake/external/flatbuffers/third_party/googletest"
	fi
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_2}"				"${S}/cmake/external/flatbuffers/third_party/googlebenchmark"
	fi
}

src_unpack() {
	_unpack ${A}

	src_unpack_external_modules
	src_unpack_external_deps
}

src_prepare() {
	eapply ${_PATCHES[@]}

	CMAKE_USE_DIR="${S}/cmake"

	python-single-r1_pkg_setup

	use cuda && cuda_src_prepare

	if use rocm ; then
		eapply "${FILESDIR}/${PN}-1.19.0-rocm-hardcoded-paths.patch"
	fi

	# Workaround for binary drivers.
	addpredict "/dev/ati"
	addpredict "/dev/dri"
	addpredict "/dev/nvidiactl"

	# fix build with gcc12(?), take idea from https://github.com/microsoft/onnxruntime/pull/11667 and https://github.com/microsoft/onnxruntime/pull/10014
	sed \
		-i \
		-e 's|dims)|TensorShape(dims))|g' \
		"onnxruntime/contrib_ops/cuda/quantization/qordered_ops/qordered_qdq.cc" \
		|| die

	# fix missing #include <iostream>
	sed \
		-i \
		-e '11a#include <iostream>' \
		"orttraining/orttraining/test/training_api/trainer/trainer.cc" \
		|| die

	sed \
		-i \
		-e 's/\"-mavx512f\"/\"-mavx512f -Wno-error\"/g' \
		"cmake/onnxruntime_mlas.cmake" \
		|| die

	#if use tensorrt ; then
		## Tensorrt 8.6 EA
		#eapply "${FILESDIR}/15089.diff"

		## Update Tensorboard 00d59e65d866a6d4b9fe855dce81ee6ba8b40c4f
		#sed -e 's|373eb09e4c5d2b3cc2493f0949dc4be6b6a45e81|00d59e65d866a6d4b9fe855dce81ee6ba8b40c4f|g' \
			#-e 's|67b833913605a4f3f499894ab11528a702c2b381|ff427b6a135344d86b65fa2928fbd29886eefaec|g' \
			#-i cmake/deps.txt || die sed "Sed failed"
					## Update onnx_tensorrt 6872a9473391a73b96741711d52b98c2c3e25146
					#sed -e 's|369d6676423c2a6dbf4a5665c4b5010240d99d3c|6872a9473391a73b96741711d52b98c2c3e25146|g' \
						#-e 's|62119892edfb78689061790140c439b111491275|75462057c95f7fdbc256179f0a0e9e4b7be28ae3|g' \
						#-i cmake/deps.txt || die sed "Sed failed"
	#fi

	cmake_src_prepare
	use rocm && rocm_src_prepare
}

src_configure() {
	ewarn "This ebuild is still in development.  Use the 1.19.x series instead."
	export ROCM_PATH="${ESYSROOT}/${EROCM_PATH}"
	export MIOPEN_PATH="${ESYSROOT}/${EROCM_PATH}"
	#export ROCM_VERSION="${ROCM_VERSION}"-

	python && python_setup
	CMAKE_BUILD_TYPE=$(usex debug RelWithDebInfo Release)
	CMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
	CMAKE_TLS_VERIFY=ON
	PYTHON_EXECUTABLE="/usr/bin/${EPYTHON}"
	PYTHON_INCLUDE_DIR="$(python_get_includedir)"
	PYTHON_LIBRARY="$(python_get_library_path)"

	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC}"

	strip-unsupported-flags

	if use system-eigen ; then
		append-cppflags "-I/usr/include/eigen3"
	fi

#		$(test-flags-CXX -Wno-dangling-reference) \
	append-cxxflags \
		$(test-flags-CXX -Wno-c++20-compat) \
		$(test-flags-CXX -Wno-error=unused-parameter) \
		$(test-flags-CXX -Wno-error=maybe-uninitialized) \
		$(test-flags-CXX -Wno-array-bounds) \
		$(test-flags-CXX -Wno-stringop-overread)

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	local mycmakeargs=(
		-DABSL_ENABLE_INSTALL=ON
		-DCMAKE_INSTALL_INCLUDEDIR="include"
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DFETCHCONTENT_QUIET=OFF
		-DFETCHCONTENT_SOURCE_DIR_CXXOPTS="${S}/cmake/external/flatbuffers/third_party/cxxopts"
		-DFETCHCONTENT_SOURCE_DIR_DATE="${S}/cmake/external/date-1"
		-DFETCHCONTENT_SOURCE_DIR_FLATBUFFERS="${S}/cmake/external/flatbuffers"
		-DFETCHCONTENT_SOURCE_DIR_GSL="${S}/cmake/external/microsoft_gsl"
		-DFETCHCONTENT_SOURCE_DIR_MP11="${S}/cmake/external/mp11"
		-DFETCHCONTENT_SOURCE_DIR_MICROSOFT_WIL="${S}/cmake/external/microsoft_wil"
		-DFETCHCONTENT_SOURCE_DIR_NLOHMANN_JSON="${S}/cmake/external/json"
		-DFETCHCONTENT_SOURCE_DIR_ONNX="${S}/cmake/external/onnx"
		-DFETCHCONTENT_SOURCE_DIR_ABSEIL="${S}/cmake/external/onnx/third_party/abseil" # For cmake/external/onnx/CMakeLists.txt
		-DFETCHCONTENT_SOURCE_DIR_DAWN="${S}/cmake/external/dawn"
		-DFETCHCONTENT_SOURCE_DIR_KLEIDIAI="${S}/cmake/external/kleidiai"
		#-DFETCHCONTENT_SOURCE_DIR_PROTOBUF="${S}/cmake/external/onnx/third_party/protobuf" # For cmake/external/onnx/CMakeLists.txt # Disabled because it is ambiguous.
		-DFETCHCONTENT_SOURCE_DIR_PROTOBUF="${S}/cmake/external/protobuf"
		-DFETCHCONTENT_SOURCE_DIR_PYBIND11_PROJECT="${S}/cmake/external/pybind11"
		-DFETCHCONTENT_SOURCE_DIR_PYTORCH_CLOG="${S}/cmake/external/pytorch_cpuinfo"
		-DFETCHCONTENT_SOURCE_DIR_PYTORCH_CPUINFO="${S}/cmake/external/pytorch_cpuinfo"
		-DFETCHCONTENT_SOURCE_DIR_RE2="${S}/cmake/external/re2"
		-DFETCHCONTENT_SOURCE_DIR_SAFEINT="${S}/cmake/external/safeint"
		-DFETCHCONTENT_SOURCE_DIR_UTF8_RANGE="${S}/cmake/external/utf8_range"

# We use vendored packages because the build scripts get confused between system and vendored.
# Using ALWAYS causes confusion between system's abseil and vendored abseil.
		-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=NEVER

		-Donnxruntime_ARMNN_BN_USE_CPU=ON
		-Donnxruntime_ARMNN_RELU_USE_CPU=ON
		-Donnxruntime_BUILD_APPLE_FRAMEWORK=OFF
		-Donnxruntime_BUILD_BENCHMARKS=$(usex benchmark)
		-Donnxruntime_BUILD_CSHARP=OFF
		-Donnxruntime_BUILD_FOR_NATIVE_MACHINE=OFF
		-Donnxruntime_BUILD_JAVA=OFF
		-Donnxruntime_BUILD_MS_EXPERIMENTAL_OPS=OFF
		-Donnxruntime_BUILD_NODEJS=OFF
		-Donnxruntime_BUILD_OBJC=OFF
		-Donnxruntime_BUILD_SHARED_LIB=ON

		-Donnxruntime_BUILD_UNIT_TESTS=$(usex test)
		-Donnxruntime_BUILD_WEBASSEMBLY_STATIC_LIB=OFF
		-Donnxruntime_CROSS_COMPILING=$(tc-is-cross-compiler && echo ON || echo OFF)
		-Donnxruntime_DISABLE_ABSEIL=$(usex !abseil-cpp)
		-Donnxruntime_DISABLE_CONTRIB_OPS=ON
		-Donnxruntime_DISABLE_EXCEPTIONS=$(usex !debug)
		-Donnxruntime_DISABLE_ML_OPS=ON
		-Donnxruntime_DISABLE_RTTI=OFF
		-Donnxruntime_ENABLE_CPU_FP16_OPS=OFF
		-Donnxruntime_ENABLE_EAGER_MODE=OFF
		-Donnxruntime_ENABLE_EXTERNAL_CUSTOM_OP_SCHEMAS=OFF
		-Donnxruntime_ENABLE_LANGUAGE_INTEROP_OPS=OFF
		-Donnxruntime_ENABLE_LAZY_TENSOR=OFF
		-Donnxruntime_ENABLE_MEMLEAK_CHECKER=ON
		-Donnxruntime_ENABLE_MEMORY_PROFILE=OFF
		-Donnxruntime_ENABLE_MICROSOFT_INTERNAL=OFF
		-Donnxruntime_ENABLE_NVTX_PROFILE=OFF
		-Donnxruntime_ENABLE_PYTHON=$(usex python)
		-Donnxruntime_ENABLE_ROCM_PROFILING=OFF
		-Donnxruntime_ENABLE_TRAINING=$(usex training)
		-Donnxruntime_ENABLE_TRAINING_OPS=OFF
		-Donnxruntime_ENABLE_TRAINING_APIS=OFF
		-Donnxruntime_ENABLE_WEBASSEMBLY_API_EXCEPTION_CATCHING=OFF
		-Donnxruntime_ENABLE_WEBASSEMBLY_DEBUG_INFO=OFF
		-Donnxruntime_ENABLE_WEBASSEMBLY_EXCEPTION_CATCHING=ON
		-Donnxruntime_ENABLE_WEBASSEMBLY_EXCEPTION_THROWING=ON
		-Donnxruntime_ENABLE_WEBASSEMBLY_PROFILING=OFF
		-Donnxruntime_ENABLE_WEBASSEMBLY_THREADS=OFF
		-Donnxruntime_EXTENDED_MINIMAL_BUILD=OFF
		-Donnxruntime_GCOV_COVERAGE=OFF
		-Donnxruntime_MINIMAL_BUILD=OFF
		-Donnxruntime_MINIMAL_BUILD_CUSTOM_OPS=OFF
		-Donnxruntime_PYBIND_EXPORT_OPSCHEMA=OFF
		-Donnxruntime_REDUCED_OPS_BUILD=OFF
		-Donnxruntime_REQUIRE_PYTHON_EMBED_LIB=OFF
		-Donnxruntime_RUN_ONNX_TESTS=$(usex test)
		-Donnxruntime_USE_ACL=OFF
		-Donnxruntime_USE_ACL_1902=OFF
		-Donnxruntime_USE_ACL_1905=OFF
		-Donnxruntime_USE_ACL_1908=OFF
		-Donnxruntime_USE_ACL_2002=OFF
		-Donnxruntime_USE_ARMNN=OFF
		-Donnxruntime_USE_AVX=$(usex cpu_flags_x86_avx)
		-Donnxruntime_USE_AVX2=$(usex cpu_flags_x86_avx2)
		-Donnxruntime_USE_AVX512=$(usex cpu_flags_x86_avx512)
		-Donnxruntime_USE_CANN=OFF
		-Donnxruntime_USE_CUDA=$(usex cuda)
		-Donnxruntime_USE_DML=OFF
		-Donnxruntime_USE_DNNL=$(usex onednn)
		-Donnxruntime_USE_EXTENSIONS=$(usex extensions)
		-Donnxruntime_USE_FULL_PROTOBUF=OFF
		-Donnxruntime_USE_JSEP=$(usex javascript)
		-Donnxruntime_USE_LLVM=$(usex llvm)
		-Donnxruntime_USE_MIGRAPHX=$(usex migraphx)
		-Donnxruntime_USE_MIMALLOC=$(usex mimalloc)
		-Donnxruntime_USE_MPI=$(usex mpi)
		-Donnxruntime_USE_NCCL=OFF
		-Donnxruntime_USE_NNAPI_BUILTIN=OFF
		-Donnxruntime_USE_OPENVINO=$(usex openvino)
		-Donnxruntime_USE_PREINSTALLED_EIGEN=$(usex system-eigen)
		-Donnxruntime_USE_RKNPU=OFF
		-Donnxruntime_USE_ROCM=$(usex rocm)
		-Donnxruntime_USE_TELEMETRY=OFF
		-Donnxruntime_USE_TENSORRT=$(usex tensorrt)
		-Donnxruntime_USE_TENSORRT_BUILTIN_PARSER=$(usex !tensorrt-oss-parser)
		-Donnxruntime_USE_TVM=OFF
		-Donnxruntime_USE_VITISAI=OFF
		-Donnxruntime_USE_WINML=OFF
		-Donnxruntime_USE_WEBGPU=OFF
		-Donnxruntime_USE_XNNPACK=$(usex xnnpack)
		-Donnxruntime_TVM_USE_HASH=OFF
		-Donnxruntime_WEBASSEMBLY_RUN_TESTS_IN_BROWSER=OFF
	)

	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		mycmakeargs+=(
			-Donnxruntime_ENABLE_LTO=OFF
		)
	else
		mycmakeargs+=(
			-Donnxruntime_ENABLE_LTO=$(usex lto)
		)
	fi
	filter-lto

	cflags-hardened_append

	if use abseil-cpp ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_ABSEIL_CPP="${S}/cmake/external/abseil_cpp"
		)
	fi

	if use benchmark ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_GOOGLE_BENCHMARK="${S}/cmake/external/google_benchmark" # For onnxruntime_external_deps.cmake
			-DFETCHCONTENT_SOURCE_DIR_GOOGLEBENCHMARK="${S}/cmake/external/flatbuffers/third_party/googlebenchmark" # flatbuffers
			-DFETCHCONTENT_SOURCE_DIR_BENCHMARK="${S}/cmake/external/google_benchmark" # json
		)
	fi

	if use composable-kernel && use system-composable-kernel ; then
		mycmakeargs+=(
			-DCOMPOSABLE_KERNEL_DIR="${ESYSROOT}/${EROCM_PATH}/lib/cmake/composable-kernel" # TODO verify against multislot
		)
	fi

	if use cuda ; then
		local CA
		for CA in ${CUDA_TARGETS_COMPAT[*]}; do
			use "${CA/#/cuda_targets_}" && CUDA_ARCH+="${CA#sm_*}-real;"
		done
		mycmakeargs+=(
			-DCMAKE_CUDA_ARCHITECTURES="${CUDA_ARCH%%;}"
			-DCMAKE_CUDA_HOST_COMPILER="$(cuda_gccdir)"
			-DCMAKE_CUDA_FLAGS="-forward-unknown-opts -fno-lto ${NVCCFLAGS}"
			-DCMAKE_CUDA_STANDARD_REQUIRED=ON
			-DCMAKE_CXX_STANDARD_REQUIRED=ON
			-DFETCHCONTENT_SOURCE_DIR_CUDNN_FRONTEND="${S}/cmake/external/cudnn-frontend"
			-DFETCHCONTENT_SOURCE_DIR_CUTLASS="${S}/cmake/external/cutlass"
			-Donnxruntime_CUDA_HOME="/opt/cuda"
			-Donnxruntime_CUDNN_HOME="/usr"
			-Donnxruntime_ENABLE_CUDA_LINE_NUMBER_INFO=OFF
			-Donnxruntime_ENABLE_CUDA_PROFILING=OFF
			-Donnxruntime_NVCC_THREADS=1
			-Donnxruntime_TVM_CUDA_RUNTIME=OFF
			-Donnxruntime_USE_NCCL=OFF # Multi GPU CUDA
		)
	fi

	if use system-eigen ; then
		mycmakeargs+=(
			-Deigen_SOURCE_PATH="/usr/include/eigen3"
		)
	else
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_EIGEN="${S}/cmake/external/eigen"
		)
	fi

	if use extensions ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_EXTENSIONS="${S}/cmake/external/extensions"
		)
	fi

	if use mimalloc ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_MIMALLOC="${S}/cmake/external/mimalloc"
		)
	fi

	if use openvino ; then
		mycmakeargs+=(
			-Donnxruntime_USE_OPENVINO_AUTO=$(usex openvino-auto)
			-Donnxruntime_USE_OPENVINO_CPU=$(usex openvino_targets_cpu)
			-Donnxruntime_USE_OPENVINO_CPU_NP=$(usex openvino_targets_cpu_np)
			-Donnxruntime_USE_OPENVINO_GPU=$(usex openvino_targets_gpu)
			-Donnxruntime_USE_OPENVINO_GPU_NP=$(usex openvino_targets_gpu_np)
			-Donnxruntime_USE_OPENVINO_HETERO=$(usex openvino-hetero)
			-Donnxruntime_USE_OPENVINO_MULTI=$(usex openvino-multi)
			-Donnxruntime_USE_OPENVINO_NPU=$(usex openvino_targets_npu)
			-Donnxruntime_USE_OPENVINO_NPU_NP=$(usex openvino_targets_npu_np)
		)
	fi

	if use python ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_PYBIND11="${S}/cmake/external/pybind11"
		)
	fi

	if use rocm ; then
		mycmakeargs+=(
			-DCMAKE_HIP_ARCHITECTURES="$(get_amdgpu_flags)"
			-DCMAKE_HIP_COMPILER="${ESYSROOT}/${EROCM_PATH}/llvm/bin/clang++"
			-Donnxruntime_ENABLE_TRITON=$(usex triton)
			-Donnxruntime_ROCM_HOME="${ESYSROOT}/${EROCM_PATH}"
			-Donnxruntime_ROCM_VERSION="${ROCM_VERSION}"
			-Donnxruntime_USE_TRITON_KERNEL=$(usex triton)
			-Donnxruntime_USE_COMPOSABLE_KERNEL=$(usex composable-kernel)
		)
		if use amdgpu_targets_gfx90a ; then
			mycmakeargs+=(
				-Donnxruntime_USE_HIPBLASLT=ON
			)
		else
			mycmakeargs+=(
				-Donnxruntime_USE_HIPBLASLT=OFF
			)
		fi
	fi

	if use training ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_TENSORBOARD="${S}/cmake/external/tensorboard"
		)
	fi

	if use tensorrt-oss-parser ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_ONNX_TENSORRT="${S}/cmake/external/onnx_tensorrt"
			-Donnx_tensorrt_SOURCE_PATH="${S}/cmake/external/onnx-tensorrt"
		)
	fi

	if use test ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_GOOGLETEST="${S}/cmake/external/googletest" # For onnxruntime_external_deps.cmake and onnx
		)
	fi

	if use test || use training ; then
		mycmakeargs+=(
		)
	fi

	if use xnnpack ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_FP16="${S}/cmake/external/fp16"
			-DFETCHCONTENT_SOURCE_DIR_FXDIV="${S}/cmake/external/fxdiv"
			-DFETCHCONTENT_SOURCE_DIR_GOOGLEXNNPACK="${S}/cmake/external/googlexnnpack"
			-DFETCHCONTENT_SOURCE_DIR_PSIMD="${S}/cmake/external/psimd"
			-DFETCHCONTENT_SOURCE_DIR_PTHREADPOOL="${S}/cmake/external/pthreadpool"
		)
	fi


	if use rocm ; then
		rocm_src_configure
	else
		cmake_src_configure
	fi
}

src_compile() {
	cmake_src_compile
	if use python ; then
		cd "cmake" || die
		cp -a \
			"../"{"setup.py","pyproject.toml","docs"} \
			"." \
			|| die
		distutils-r1_src_compile
	fi
}

src_install() {
	cmake_src_install
	if use python ; then
		cd cmake
		distutils-r1_src_install
	fi
	if use rocm ; then
		rocm_mv_docs
		rocm_fix_rpath
	fi

# Generated from
# find /var/tmp/portage/sci-ml/onnxruntime-1.27.1/work/onnxruntime-1.27.1/cmake/_deps -name "*.so*" | cut -f 9- -d "/"
	local LIBS=(
cmake/_deps/pytorch_cpuinfo-build/libcpuinfo.so
cmake/_deps/re2-build/libre2.so.11
cmake/_deps/re2-build/libre2.so.11.0.0
cmake/_deps/re2-build/libre2.so
cmake/_deps/abseil_cpp-build/absl/types/libabsl_bad_optional_access.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/types/libabsl_bad_optional_access.so
cmake/_deps/abseil_cpp-build/absl/types/libabsl_bad_variant_access.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/types/libabsl_bad_variant_access.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_sink.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_message.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_proto.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_nullguard.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_check_op.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_log_sink_set.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_proto.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_globals.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_log_sink_set.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_globals.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_vlog_config_internal.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_format.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_fnmatch.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_format.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_entry.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_globals.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_globals.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_sink.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_check_op.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_vlog_config_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_message.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_entry.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_fnmatch.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_nullguard.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_conditions.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_conditions.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cord.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_strings_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cord_internal.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cordz_handle.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cord.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_strings_internal.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_str_format_internal.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_string_view.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cord_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_strings.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_string_view.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cordz_info.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cordz_functions.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cordz_info.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cordz_handle.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_str_format_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_strings.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cordz_functions.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_commandlineflag.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_program_name.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_private_handle_accessor.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_config.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_config.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_internal.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_private_handle_accessor.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_program_name.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_marshalling.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_marshalling.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_commandlineflag_internal.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_commandlineflag_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_reflection.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_reflection.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_commandlineflag.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/time/libabsl_civil_time.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/time/libabsl_time.so
cmake/_deps/abseil_cpp-build/absl/time/libabsl_time.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/time/libabsl_time_zone.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/time/libabsl_civil_time.so
cmake/_deps/abseil_cpp-build/absl/time/libabsl_time_zone.so
cmake/_deps/abseil_cpp-build/absl/synchronization/libabsl_synchronization.so
cmake/_deps/abseil_cpp-build/absl/synchronization/libabsl_graphcycles_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/synchronization/libabsl_graphcycles_internal.so
cmake/_deps/abseil_cpp-build/absl/synchronization/libabsl_kernel_timeout_internal.so
cmake/_deps/abseil_cpp-build/absl/synchronization/libabsl_kernel_timeout_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/synchronization/libabsl_synchronization.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/container/libabsl_raw_hash_set.so
cmake/_deps/abseil_cpp-build/absl/container/libabsl_raw_hash_set.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/container/libabsl_hashtablez_sampler.so
cmake/_deps/abseil_cpp-build/absl/container/libabsl_hashtablez_sampler.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/hash/libabsl_low_level_hash.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/hash/libabsl_hash.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/hash/libabsl_city.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/hash/libabsl_hash.so
cmake/_deps/abseil_cpp-build/absl/hash/libabsl_low_level_hash.so
cmake/_deps/abseil_cpp-build/absl/hash/libabsl_city.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_spinlock_wait.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_spinlock_wait.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/base/libabsl_base.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_strerror.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/base/libabsl_raw_logging_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/base/libabsl_throw_delegate.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_malloc_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/base/libabsl_throw_delegate.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/base/libabsl_log_severity.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/base/libabsl_malloc_internal.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_strerror.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_raw_logging_internal.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_log_severity.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_base.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/numeric/libabsl_int128.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/numeric/libabsl_int128.so
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc_cord_state.so
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc_internal.so
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc32c.so
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc_cord_state.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc_cpu_detect.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc_cpu_detect.so
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc32c.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_examine_stack.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_utf8_for_code_point.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_demangle_rust.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_symbolize.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_stacktrace.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_demangle_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_stacktrace.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_debugging_internal.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_utf8_for_code_point.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_demangle_rust.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_symbolize.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_decode_rust_punycode.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_decode_rust_punycode.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_debugging_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_demangle_internal.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_examine_stack.so
cmake/_deps/abseil_cpp-build/absl/profiling/libabsl_exponential_biased.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/profiling/libabsl_exponential_biased.so
cmake/_deps/onnx-build/libonnx_proto.so
cmake/_deps/onnx-build/libonnx.so
cmake/_deps/protobuf-build/libprotobuf.so.32
cmake/_deps/protobuf-build/libprotobuf-lite.so.32
cmake/_deps/protobuf-build/libprotoc.so
cmake/_deps/protobuf-build/libprotobuf.so
cmake/_deps/protobuf-build/libprotoc.so.3.21.12.0
cmake/_deps/protobuf-build/libprotobuf-lite.so
cmake/_deps/protobuf-build/libprotobuf-lite.so.3.21.12.0
cmake/_deps/protobuf-build/libprotoc.so.32
cmake/_deps/protobuf-build/libprotobuf.so.3.21.12.0
	)

	cd "${S}" || die
	keepdir "/usr/$(get_libdir)/${PN}"
	exeinto "/usr/$(get_libdir)/${PN}"
	local path
	for path in ${LIBS[@]} ; do
		if [[ -L "${path}" ]] ; then
			cp -a "${path}" "${ED}/usr/$(get_libdir)/${PN}" || die
		else
			doexe "${path}"
		fi
	done

	for path in $(find "${ED}" -type f) ; do
		if file "${path}" | grep -q "ELF.*shared object" ; then
			patchelf --set-rpath "/usr/$(get_libdir)/${PN}:\$ORIGIN" "${path}" || die
		fi
	done
}
