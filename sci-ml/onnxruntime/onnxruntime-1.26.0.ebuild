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

# TODO package (optional):
# lintrunner-adapters
# onnxmltools
# pydocstyle
# tensorrt
# torch-ort

# For deps versioning, see
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/cmake/deps.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/tools/ci_build/github/linux/docker/scripts/manylinux/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/onnxruntime/python/tools/transformers/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/cmake/external/dnnl.cmake#L5
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/requirements-dev.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/requirements-doc.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/requirements-lintrunner.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/requirements-training.txt
# https://github.com/apache/tvm/blob/2379917985919ed3918dc12cad47f469f245be7a/python/gen_requirements.py#L65 ; commit from https://github.com/microsoft/onnxruntime/blob/v1.26.0/cmake/external/tvm.cmake
# https://github.com/google/dawn/blob/511eb80847afe6bded34ec491a38d5d78ba2d604/DEPS
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/Dockerfile.cuda
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/Dockerfile.openvino
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/Dockerfile.rocm
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/Dockerfile.tensorrt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/onnxruntime/python/tools/transformers/models/llama/requirements-cuda.txt#L2
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/README.md#cuda
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/README.md#openvino
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/README.md#tensorrt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/README.md#rocm

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

# https://github.com/abseil/abseil-cpp/releases/download/20240722.0/abseil-cpp-20240722.0.tar.gz
OPENVINO_PV="2024.2.0"

AMDGPU_TARGETS_COMPAT=(
# See https://github.com/microsoft/onnxruntime/blob/v1.26.0/cmake/CMakeLists.txt#L299
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
# See https://github.com/microsoft/onnxruntime/blob/v1.26.0/cmake/CMakeLists.txt#L1453
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

inherit cflags-hardened check-compiler-switch cmake cuda dep-prepare distutils-r1 flag-o-matic libcxx-slot libstdcxx-slot llvm-r1 rocm sandbox-changes toolchain-funcs

# Vendored packages need to be added or reviewed for compleness.
# The reason for delay is submodule hell (the analog of dll hell or dependency hell).
KEYWORDS="~amd64"
EGIT_REPO_URI="https://github.com/microsoft/onnxruntime.git"
EGIT_BRANCH="main"
EGIT_COMMIT="v${PV}"
inherit git-r3

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
# Unlicense - cmake/external/tvm/3rdparty/rang/LICENSE
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
-tensorrt-oss-parser -training training-ort -triton -tvm -xnnpack

openvino-auto
openvino-hetero
openvino-multi
ebuild_revision_28
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
# For providers, see also https://github.com/microsoft/onnxruntime/blob/v1.26.0/onnxruntime/test/perftest/command_args_parser.cc#L40
# abseil-cpp is required for protobuf and still links to it if disabled.
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
	tvm? (
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
		>=dev-libs/nsync-1.26.0
		dev-libs/nsync:=
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
	>=dev-python/numpy-1.21.6
	>=sci-ml/pytorch-1.13.1[${PYTHON_SINGLE_USEDEP}]
	app-admin/chrpath
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
	tvm? (
		$(python_gen_cond_dep '
			dev-python/attrs[${PYTHON_USEDEP}]
			dev-python/cloudpickle[${PYTHON_USEDEP}]
			dev-python/decorator[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
			dev-python/synr[${PYTHON_USEDEP}]
			dev-python/tornado[${PYTHON_USEDEP}]
		')
	)
	python? (
		>=sci-ml/transformers-4.18.0[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			training? (
				>=dev-python/numpy-1.16.6[${PYTHON_USEDEP}]
				dev-python/cerberus[${PYTHON_USEDEP}]
				dev-python/h5py[${PYTHON_USEDEP}]
				sci-ml/onnx[${PYTHON_USEDEP}]
			)
			>=dev-python/flatbuffers-23.5.26[${PYTHON_USEDEP}]
			>=dev-python/numpy-1.21.6[${PYTHON_USEDEP}]
			dev-python/coloredlogs[${PYTHON_USEDEP}]
			dev-python/packaging[${PYTHON_USEDEP}]
			dev-python/protobuf:=[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/py-cpuinfo[${PYTHON_USEDEP}]
			>=dev-python/sympy-1.12[${PYTHON_USEDEP}]
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
	"${FILESDIR}/${PN}-1.20.0-use-system-composable-kernel.patch"
	"${FILESDIR}/${PN}-1.20.0-drop-nsync.patch"
	"${FILESDIR}/${PN}-1.19.2-onnx_proto-visibility.patch"
	"${FILESDIR}/${PN}-1.20.2-fix-eigen-external-deps.patch"
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
	sandbox-changes_no_network_sandbox "For downloading over 175 submodules"
}

src_unpack() {
einfo "This ebuild is a Work In Progress (WIP)"
# Save for offline cache
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	export DOWNLOAD_DIR="${EDISTDIR}/onnxruntime-${PV}" # Do not simplify
	addwrite "${DOWNLOAD_DIR}"
einfo "DOWNLOAD_DIR (CMake offline cache):  ${DOWNLOAD_DIR}"

	git-r3_fetch
	git-r3_checkout
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
		-Donnxruntime_USE_TVM=$(usex tvm)
		-Donnxruntime_USE_VITISAI=OFF
		-Donnxruntime_USE_WINML=OFF
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

	if use tensorrt-oss-parser ; then
		mycmakeargs+=(
			-Donnx_tensorrt_SOURCE_PATH="${S}/cmake/external/onnx-tensorrt"
		)
	fi

	if use test || use training ; then
		mycmakeargs+=(
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
# find /var/tmp/portage/sci-ml/onnxruntime-1.26.0/work/onnxruntime-1.26.0/cmake/_deps -name "*.so*" | cut -f 9- -d "/"
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
