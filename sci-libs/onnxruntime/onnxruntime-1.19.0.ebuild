# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: package
# clang-format
# dev-python/triton
# lintrunner-adapters
# neural-compressor
# onnxmltools
# pydocstyle
# tensorrt

# For deps versioning, see
# https://github.com/microsoft/onnxruntime/blob/v1.19.0/cmake/deps.txt
# https://github.com/microsoft/onnxruntime/blob/v1.19.0/tools/ci_build/github/linux/docker/scripts/manylinux/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.19.0/onnxruntime/python/tools/transformers/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.19.0/cmake/external/dnnl.cmake#L5
# https://github.com/microsoft/onnxruntime/blob/v1.19.0/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.19.0/requirements-dev.txt
# https://github.com/microsoft/onnxruntime/blob/v1.19.0/requirements-doc.txt
# https://github.com/microsoft/onnxruntime/blob/v1.19.0/requirements-lintrunner.txt
# https://github.com/microsoft/onnxruntime/blob/v1.19.0/requirements-training.txt

# clog has same version as cpuinfo

ABSEIL_CPP_COMMIT="f46495ea96f68fc3f6c394f099b2992743f6ff7f" # From cmake/deps.txt
AMDGPU_TARGETS_COMPAT=(
# See https://github.com/microsoft/onnxruntime/blob/v1.19.0/cmake/CMakeLists.txt#L299
	gfx906
	gfx908
	gfx90a # ck
	#gfx942 # ck
	gfx1030
	gfx1100
	gfx1101
)
CMAKE_IN_SOURCE_BUILD=1
CPU_FLAGS="
	cpu_flags_x86_avx
	cpu_flags_x86_avx2
	cpu_flags_x86_avx512
"
DATE_PV="3.0.1" # From cmake/deps.txt
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
CUDA_TARGETS_COMPAT=(
# See https://github.com/microsoft/onnxruntime/blob/v1.19.0/cmake/CMakeLists.txt#L1453
	sm_30
	sm_37
	sm_50
	sm_52
	sm_53
	sm_60
	sm_62
	sm_70
	sm_72
	sm_75
	sm_87
	sm_80
	sm_90
)
FLATBUFFERS_PV="23.5.26" # From cmake/deps.txt
ROCM_SLOTS=(
	rocm_6_0
	rocm_5_7
)
LLVM_COMPAT=( 17 18 )
LLVM_OPTIONAL=1
MIMALLOC_PV="2.1.1" # From cmake/deps.txt
NEURAL_SPEED_PV="0.3" # From cmake/deps.txt
ONNX_TENSORRT_COMMIT="f161f95883b4ebd8cb789de5efc67b73c0a6e694" # From cmake/deps.txt
ONNXRUNTIME_EXTENSIONS_COMMIT="94142d8391c9791ec71c38336436319a2d4ac7a0" # From cmake/deps.txt
OPENVINO_PV="2024.0"
OPENVINO_TARGETS=(
	cpu
	cpu_np
	gpu
	gpu_np
	npu
	npu_np
)
PYTHON_COMPAT=( "python3_"{10..12} )
SAFEINT_COMMIT="3.0.28" # From cmake/deps.txt

inherit cmake cuda dep-prepare distutils-r1 flag-o-matic llvm-r1 rocm toolchain-funcs


DESCRIPTION="Cross-platform inference and training machine-learning accelerator."
HOMEPAGE="
	https://onnxruntime.ai
	https://github.com/microsoft/onnxruntime
"
SRC_URI="
	https://github.com/microsoft/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/dcleblanc/SafeInt/archive/${SAFEINT_COMMIT}.tar.gz
		-> SafeInt-${SAFEINT_COMMIT:0:10}.tar.gz
	https://github.com/google/flatbuffers/archive/v${FLATBUFFERS_PV}.tar.gz
		-> flatbuffers-${FLATBUFFERS_PV}.tar.gz
	https://github.com/HowardHinnant/date/archive/v${DATE_PV}.tar.gz
		-> HowardHinnant-date-${DATE_PV}.tar.gz
	abseil-cpp? (
https://github.com/abseil/abseil-cpp/archive/${ABSEIL_CPP_COMMIT}.tar.gz
	-> abseil-cpp-${ABSEIL_CPP_COMMIT:0:7}.tar.gz
	)
	extensions? (
https://github.com/microsoft/onnxruntime-extensions/archive/${ONNXRUNTIME_EXTENSIONS_COMMIT}.tar.gz
	-> onnxruntime-extensions-${ONNXRUNTIME_EXTENSIONS_COMMIT:0:7}.tar.gz
	)
	mimalloc? (
https://github.com/microsoft/mimalloc/archive/refs/tags/v${MIMALLOC_PV}.tar.gz
	-> mimalloc-${MIMALLOC_PV}.tar.gz
	)
	neural-speed? (
https://github.com/intel/neural-speed/archive/refs/tags/v0.3.tar.gz
	-> neural-speed-${NEURAL_SPEED_PV}.tar.gz
	)
	tensorrt-oss-parser? (
https://github.com/onnx/onnx-tensorrt/archive/${ONNX_TENSORRT_COMMIT}.tar.gz
	-> onnx-tensorrt-${ONNX_TENSORRT_COMMIT:0:7}.tar.gz
	)
"
DISABLE="

"
DISABLE_2="
https://github.com/abseil/abseil-cpp/archive/${ABSEIL_CPP_COMMIT}.tar.gz
	-> abseil-cpp-${ABSEIL_CPP_COMMIT:0:7}.tar.gz
https://github.com/microsoft/onnxruntime-extensions/archive/${ONNXRUNTIME_EXTENSIONS_COMMIT}.tar.gz
	-> onnxruntime-extensions-${ONNXRUNTIME_EXTENSIONS_COMMIT:0:7}.tar.gz
https://github.com/microsoft/mimalloc/archive/refs/tags/v${MIMALLOC_PV}.tar.gz
	-> mimalloc-${MIMALLOC_PV}.tar.gz
https://github.com/intel/neural-speed/archive/refs/tags/v0.3.tar.gz
	-> neural-speed-${NEURAL_SPEED_PV}.tar.gz
https://github.com/onnx/onnx-tensorrt/archive/${ONNX_TENSORRT_COMMIT}.tar.gz
	-> onnx-tensorrt-${ONNX_TENSORRT_COMMIT:0:7}.tar.gz
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
	custom
	HPND
	ISC
	ISSL
	JSON
	MIT
	MPL-2.0
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
# custom - dockerfiles/LICENSE-IMAGE.txt
# custom keywords:  The copyright holders provide no reassurances
# The distro's Apache-2.0 license template does not contain all rights reserved.
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror test" # Untested
SLOT="0"
KEYWORDS="~amd64"
IUSE="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
${CPU_FLAGS}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${OPENVINO_TARGETS[@]/#/openvino_targets_}
${ROCM_SLOTS[@]}
onnxruntime_USE_EXTENSIONS
-abseil-cpp -benchmark -composable-kernel cpu -cuda cudnn debug doc -extensions
-javascript -llvm -lto -migraphx -mpi -mimalloc -neural-speed -onednn -openvino
+python -rocm test -tensorrt -tensorrt-oss-parser -triton -xnnpack

openvino-auto
openvino-hetero
openvino-multi
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
# For providers, see also https://github.com/microsoft/onnxruntime/blob/v1.19.0/onnxruntime/test/perftest/command_args_parser.cc#L40
REQUIRED_USE="
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	composable-kernel? (
		amdgpu_targets_gfx90a
		rocm
	)
	cuda? (
		cudnn
		!lto
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
	rocm? (
		llvm_slot_17
		migraphx
	)
	tensorrt-oss-parser? (
		cuda
		tensorrt
	)
	test? (
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
		local s=$(ver_cut 1-2 ${pv})
		local u="${s}"
		u="${u/./_}"
	# Check both the direct top and indirect bottom dependencies
		echo "
			rocm_${u}? (
				~dev-libs/rccl-${pv}:${s}$(get_rocm_usedep RCCL)
				~dev-libs/rocr-runtime-${pv}:${s}
				~dev-util/hip-${pv}:${s}[rocm]
				~dev-util/rocm-smi-${pv}:${s}
				~dev-util/roctracer-${pv}:${s}
				~sci-libs/hipCUB-${pv}:${s}$(get_rocm_usedep HIPCUB)
				~sci-libs/hipFFT-${pv}:${s}$(get_rocm_usedep HIPFFT)
				~sci-libs/hipRAND-${pv}:${s}[rocm]
				~sci-libs/miopen-${pv}:${s}$(get_rocm_usedep MIOPEN)
				~sci-libs/rocBLAS-${pv}:${s}$(get_rocm_usedep ROCBLAS)
			)
		"
		if use amdgpu_targets_gfx90a ; then
			echo "
				~sci-libs/hipBLASLt-${pv}:${s}$(get_rocm_usedep HIPBLASLT)
			"
		fi
	done
}
RDEPEND="
	${PYTHON_DEPS}
	(
		>=dev-cpp/eigen-3.4.0[cuda?]
		dev-cpp/eigen:=
	)
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
	(
		!python? (
			>=sci-libs/onnx-1.16.1[disableStaticReg]
		)
		python? (
			$(python_gen_cond_dep '
				>=sci-libs/onnx-1.16.1[${PYTHON_USEDEP},disableStaticReg]
			')
		)
		sci-libs/onnx:=
	)
	(
		>=sys-cluster/openmpi-4.0.0[cuda?]
		sys-cluster/openmpi:=
	)
	>=dev-libs/FP16-2021.03.16
	>=dev-libs/FXdiv-2020.12.08
	>=dev-libs/re2-0.2024.07.02:0/11
	>=dev-python/numpy-2.0.0
	>=sci-libs/pytorch-1.13.1
	app-admin/chrpath
	(
		>=dev-libs/nsync-1.26.0
		dev-libs/nsync:=
	)
	benchmark? (
		>=dev-cpp/benchmark-1.8.5
	)
	cuda? (
		|| (
			(
				=dev-util/nvidia-cuda-toolkit-11.8*
				!python? (
					>=sci-libs/pytorch-2.0.0
				)
				cudnn? (
					=dev-libs/cudnn-8.8*
				)
				python? (
					>=sci-libs/pytorch-2.0.0[${PYTHON_SINGLE_USEDEP}]
				)
			)
			(
				=dev-util/nvidia-cuda-toolkit-12.3*
				!python? (
					>=sci-libs/pytorch-2.1.0
				)
				cudnn? (
					=dev-libs/cudnn-8.6*
				)
				python? (
					>=sci-libs/pytorch-2.1.0[${PYTHON_SINGLE_USEDEP}]
				)
			)
		)
		dev-util/nvidia-cuda-toolkit:=
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
		>=dev-libs/oneDNN-3.0.1
		dev-libs/oneDNN:=
	)
	openvino? (
		>=sci-libs/openvino-${OPENVINO_PV}
		openvino_targets_gpu? (
			>=sci-libs/openvino-${OPENVINO_PV}[video_cards_intel]
		)
		openvino_targets_npu? (
			>=sci-libs/openvino-${OPENVINO_PV}[npu]
		)
	)
	rocm? (
		$(gen_rocm_rdepend)
		rocm_5_7? (
			!python? (
				|| (
					=sci-libs/pytorch-2.3*
					=sci-libs/pytorch-2.2*
				)
			)
			python? (
				|| (
					=sci-libs/pytorch-2.3*[${PYTHON_SINGLE_USEDEP}]
					=sci-libs/pytorch-2.2*[${PYTHON_SINGLE_USEDEP}]
				)
			)
		)
		rocm_6_0? (
			!python? (
				|| (
					=sci-libs/pytorch-2.3*
				)
			)
			python? (
				|| (
					=sci-libs/pytorch-2.3*[${PYTHON_SINGLE_USEDEP}]
				)
			)
		)
	)
	tensorrt? (
		dev-util/tensorrt:=
	)
	xnnpack? (
		>=sci-libs/XNNPACK-2023.10.19
	)
	python? (
		>=sci-libs/pytorch-1.13.1[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/flatbuffers-23.5.26[${PYTHON_USEDEP}]
			>=dev-python/numpy-2.0.0[${PYTHON_USEDEP}]
			>=sci-libs/transformers-4.18.0[${PYTHON_USEDEP}]
			dev-python/cerberus[${PYTHON_USEDEP}]
			dev-python/coloredlogs[${PYTHON_USEDEP}]
			dev-python/h5py[${PYTHON_USEDEP}]
			dev-python/packaging[${PYTHON_USEDEP}]
			dev-python/protobuf-python[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/py-cpuinfo[${PYTHON_USEDEP}]
			>=dev-python/sympy-1.12[${PYTHON_USEDEP}]
		')
	)
"
DEPEND+="
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/setuptools-68.2.2
	$(python_gen_cond_dep '
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
			dev-python/jinja[${PYTHON_USEDEP}]
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
PATCHES=(
	"${FILESDIR}/${PN}-system-dnnl.patch"
	"${FILESDIR}/re2-pkg-config-r2.patch"
	"${FILESDIR}/system-onnx-r3.patch"
	"${FILESDIR}/system-nsync.patch"
	"${FILESDIR}/system-composable_kernel-r2.patch"
	"${FILESDIR}/system-protobuf.patch"
	"${FILESDIR}/system-mp11.patch"
	"${FILESDIR}/system-gsl-r2.patch"
	#"${FILESDIR}/rocm-version-override-r2.patch"
	"${FILESDIR}/hip-gentoo.patch"
	"${FILESDIR}/shared-build-fix.patch"
	"${FILESDIR}/hip-libdir.patch"
	"${FILESDIR}/contrib-ops.patch"
	"${FILESDIR}/disabled_rules_and_transformers.patch"
	"${FILESDIR}/Werror.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
	use llvm && llvm-r1_pkg_setup

	if use rocm_6_0 ; then
		LLVM_SLOT="17"
		ROCM_SLOT="6.0"
		ROCM_VERSION="${HIP_6_0_VERSION}"
	elif use rocm_6_0 ; then
		LLVM_SLOT="17"
		ROCM_SLOT="5.7"
		ROCM_VERSION="${HIP_5_7_VERSION}"
	fi

	use rocm && rocm_pkg_setup
}

src_unpack() {
	unpack ${A}
	use abseil-cpp && dep_prepare_mv "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_COMMIT}" "${S}/cmake/_deps/abseil_cpp-src"
	use extensions && dep_prepare_mv "${WORKDIR}/onnxruntime-extensions-${ONNXRUNTIME_EXTENSIONS_COMMIT}" "${S}/cmake/external/extensions"
	use mimalloc && dep_prepare_mv "${WORKDIR}/mimalloc-${MIMALLOC_PV}" "${S}/cmake/external/mimalloc"
	use tensorrt-oss-parser && dep_prepare_mv "${WORKDIR}/onnx-tensorrt-${ONNX_TENSORRT_COMMIT}" "${S}/cmake/external/onnx_tensorrt"
	use neural-speed && dep_prepare_mv "${WORKDIR}/neural-speed-${NEURAL_SPEED_PV}" "${S}/cmake/external/neural_speed"

#	dep_prepare_mv "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_COMMIT}" "${S}/cmake/_deps/abseil_cpp-src"
#	dep_prepare_mv "${WORKDIR}/onnxruntime-extensions-${ONNXRUNTIME_EXTENSIONS_COMMIT}" "${S}/cmake/external/extensions"
#	dep_prepare_mv "${WORKDIR}/mimalloc-${MIMALLOC_PV}" "${S}/cmake/external/mimalloc"
#	dep_prepare_mv "${WORKDIR}/onnx-tensorrt-${ONNX_TENSORRT_COMMIT}" "${S}/cmake/external/onnx_tensorrt"
#	dep_prepare_mv "${WORKDIR}/neural-speed-${NEURAL_SPEED_PV}" "${S}/cmake/external/neural_speed"
}

src_prepare() {
	CMAKE_USE_DIR="${S}/cmake"

	python && python_setup

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

	strip-unsupported-flags

	append-cppflags "-I/usr/include/eigen3"

	cmake_src_prepare
	use rocm && rocm_src_prepare
}

src_configure() {
	export ROCM_PATH="${ESYSROOT}/${EROCM_PATH}"
	export MIOPEN_PATH="${ESYSROOT}/${EROCM_PATH}"
	export ROCM_VERSION="${ROCM_VERSION}"-

	python && python_setup
	CMAKE_BUILD_TYPE=$(usex debug RelWithDebInfo Release)
	CMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
	CMAKE_TLS_VERIFY=ON
	PYTHON_EXECUTABLE="/usr/bin/${EPYTHON}"
	PYTHON_INCLUDE_DIR="$(python_get_includedir)"
	PYTHON_LIBRARY="$(python_get_library_path)"

	append-cxxflags \
		-Wno-c++20-compat \
		-Wno-dangling-reference

	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR="include/${PN}"
		-Deigen_SOURCE_PATH=/usr/include/eigen3
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DFETCHCONTENT_QUIET=OFF
		-DFETCHCONTENT_SOURCE_DIR_SAFEINT="${WORKDIR}/SafeInt-${SAFEINT_COMMIT}"
		-DFETCHCONTENT_SOURCE_DIR_FLATBUFFERS="${WORKDIR}/flatbuffers-${FLATBUFFERS_PV}"
		-DFETCHCONTENT_SOURCE_DIR_DATE="${WORKDIR}/date-${DATE_PV}"
		-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
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
		-Donnxruntime_DISABLE_ABSEIL=ON
		-Donnxruntime_DISABLE_CONTRIB_OPS=ON
		-Donnxruntime_DISABLE_EXCEPTIONS=$(usex !debug)
		-Donnxruntime_DISABLE_ML_OPS=ON
		-Donnxruntime_DISABLE_RTTI=OFF
		-Donnxruntime_ENABLE_CPU_FP16_OPS=OFF
		-Donnxruntime_ENABLE_EAGER_MODE=OFF
		-Donnxruntime_ENABLE_EXTERNAL_CUSTOM_OP_SCHEMAS=OFF
		-Donnxruntime_ENABLE_LANGUAGE_INTEROP_OPS=OFF
		-Donnxruntime_ENABLE_LAZY_TENSOR=OFF
		-Donnxruntime_ENABLE_LTO=$(usex lto)
		-Donnxruntime_ENABLE_MEMLEAK_CHECKER=ON
		-Donnxruntime_ENABLE_MEMORY_PROFILE=OFF
		-Donnxruntime_ENABLE_MICROSOFT_INTERNAL=OFF
		-Donnxruntime_ENABLE_NVTX_PROFILE=OFF
		-Donnxruntime_ENABLE_PYTHON=$(usex python)
		-Donnxruntime_ENABLE_ROCM_PROFILING=OFF
		-Donnxruntime_ENABLE_TRAINING=OFF
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
		-Donnxruntime_USE_NEURAL_SPEED=$(usex neural-speed)
		-Donnxruntime_USE_NNAPI_BUILTIN=OFF
		-Donnxruntime_USE_OPENVINO=$(usex openvino)
		-Donnxruntime_USE_OPENVINO_AUTO=$(usex openvino-auto)
		-Donnxruntime_USE_OPENVINO_CPU=$(usex openvino_targets_cpu)
		-Donnxruntime_USE_OPENVINO_CPU_NP=$(usex openvino_targets_cpu_np)
		-Donnxruntime_USE_OPENVINO_GPU=$(usex openvino_targets_gpu)
		-Donnxruntime_USE_OPENVINO_GPU_NP=$(usex openvino_targets_gpu_np)
		-Donnxruntime_USE_OPENVINO_HETERO=$(usex openvino-hetero)
		-Donnxruntime_USE_OPENVINO_MULTI=$(usex openvino-multi)
		-Donnxruntime_USE_OPENVINO_NPU=$(usex openvino_targets_npu)
		-Donnxruntime_USE_OPENVINO_NPU_NP=$(usex openvino_targets_npu_np)
		-Donnxruntime_USE_PREINSTALLED_EIGEN=ON
		-Donnxruntime_USE_RKNPU=OFF
		-Donnxruntime_USE_ROCM=$(usex rocm)
		-Donnxruntime_USE_TELEMETRY=OFF
		-Donnxruntime_USE_TENSORRT=$(usex tensorrt)
		-Donnxruntime_USE_TENSORRT_BUILTIN_PARSER=$(usex !tensorrt-oss-parser)
		-Donnxruntime_USE_TVM=OFF
		-Donnxruntime_USE_VITISAI=OFF
		-Donnxruntime_USE_WINML=OFF
		-Donnxruntime_USE_XNNPACK=$(usex xnnpack)
		-Donnxruntime_TVM_USE_HASH=OFF
		-Donnxruntime_WEBASSEMBLY_RUN_TESTS_IN_BROWSER=OFF
	)

	if use abseil-cpp ; then
		mycmakeargs+=(
			-Dabseil_cpp_SOURCE_PATH="${S}/cmake/_deps/abseil_cpp-src"
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
			-Donnxruntime_CUDA_HOME=/opt/cuda
			-Donnxruntime_CUDNN_HOME=/usr
			-Donnxruntime_ENABLE_CUDA_LINE_NUMBER_INFO=OFF
			-Donnxruntime_ENABLE_CUDA_PROFILING=OFF
			-Donnxruntime_NVCC_THREADS=1
			-Donnxruntime_TVM_CUDA_RUNTIME=OFF
			-Donnxruntime_USE_NCCL=OFF # Multi GPU CUDA
		)
	fi

	if use extensions ; then
		mycmakeargs+=(
			-Dextensions_SOURCE_PATH="${S}/cmake/external/extensions"
		)
	fi

	if use mimalloc ; then
		mycmakeargs+=(
			-Dmimalloc_SOURCE_PATH="${S}/cmake/external/mimalloc"
		)
	fi

	if use neural-speed ; then
		mycmakeargs+=(
			-Dneural_speed_SOURCE_PATH="${S}/cmake/external/neural-speed"
		)
	fi

	if use rocm ; then
		mycmakeargs+=(
			-DCMAKE_HIP_ARCHITECTURES="$(get_amdgpu_flags)"
			-DCMAKE_HIP_COMPILER="${ESYSROOT}/${EROCM_PATH}/llvm/bin/clang++"
			-Donnxruntime_ENABLE_TRITON=$(usex triton)
			-Donnxruntime_USE_TRITON_KERNEL=$(usex triton)
			-Donnxruntime_USE_COMPOSABLE_KERNEL=$(usex composable-kernel)
			#-DCOMPOSABLE_KERNEL_DIR="${ESYSROOT}/${EROCM_PATH}/lib/cmake/composable-kernel" # TODO verify
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
}
