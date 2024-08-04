# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
DATE_PV="3.0.1" # From https://github.com/microsoft/onnxruntime/blob/v1.19.0/cmake/deps.txt#L18
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
FLATBUFFERS_PV="23.5.26" # From https://github.com/microsoft/onnxruntime/blob/v1.19.0/cmake/deps.txt#L26
ROCM_SLOTS=(
	rocm_6_0
	rocm_5_7
)
LLVM_COMPAT=( 17 18 )
LLVM_OPTIONAL=1
PYTHON_COMPAT=( "python3_"{10..12} )
SAFEINT_COMMIT="3.0.28" # From https://github.com/microsoft/onnxruntime/blob/v1.19.0/cmake/deps.txt#L54

inherit cmake cuda distutils-r1 flag-o-matic llvm-r1 rocm toolchain-funcs

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
		-> hhdate-${DATE_PV}.tar.gz
"

LICENSE="
	custom
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
# CC-BY-3.0 CC-BY-4.0 - winml/test/collateral/images/LICENSE.md
# custom - dockerfiles/LICENSE-IMAGE.txt

# custom keywords:  The copyright holders provide no reassurances

# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror test"
SLOT="0"
KEYWORDS="~amd64"
IUSE="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
${CPU_FLAGS}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_SLOTS[@]}
-benchmark -composable-kernel -cuda cudnn debug -javascript -llvm -migraphx -mpi
-mimalloc -lto onednn +python -rocm test -tensorrt -triton -xnnpack
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
	composable-kernel? (
		amdgpu_targets_gfx90a
		rocm
	)
	cuda? (
		cudnn
		!lto
	)
	rocm? (
		llvm_slot_17
		migraphx
	)
	|| (
		cudnn
		migraphx
		onednn
		tensorrt
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
				~dev-util/rocm-smi-${pv}:${s}
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
	app-admin/chrpath
	dev-cpp/eigen:=[cuda?]
	dev-cpp/ms-gsl:=
	dev-cpp/nlohmann_json
	dev-libs/cpuinfo:=
	dev-libs/date:=
	dev-libs/flatbuffers:=
	dev-libs/clog:=
	dev-libs/FP16
	dev-libs/FXdiv
	dev-libs/nsync:=
	dev-libs/protobuf:=
	dev-libs/re2
	dev-python/numpy
	sci-libs/pytorch
	sci-libs/onnx:=[disableStaticReg]
	sys-cluster/openmpi:=[cuda?]
	benchmark? (
		dev-cpp/benchmark
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	cudnn? (
		dev-libs/cudnn:=
	)
	javascript? (
		dev-util/emscripten
	)
	onednn? (
		dev-libs/oneDNN:=
	)
	rocm? (
		$(gen_rocm_rdepend)
		>=dev-libs/rocr-runtime-${ROCM_VERSION}:=
		>=dev-util/hip-${ROCM_VERSION}:=
		sci-libs/hipCUB:=
		sci-libs/hipFFT:=
	)
	xnnpack? (
		sci-libs/XNNPACK
	)
	python? (
		$(python_gen_cond_dep '
			dev-python/cerberus[${PYTHON_USEDEP}]
			dev-python/coloredlogs[${PYTHON_USEDEP}]
			dev-python/flatbuffers[${PYTHON_USEDEP}]
			dev-python/h5py[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/py-cpuinfo[${PYTHON_USEDEP}]
			dev-python/sympy[${PYTHON_USEDEP}]
		')
	)
"
DEPEND+="
"
BDEPEND+="
	${PYTHON_DEPS}
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

	#if use tensorrt; then
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
		-DOnnxruntime_GCOV_COVERAGE=OFF
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
		-Donnxruntime_USE_FULL_PROTOBUF=OFF
		-Donnxruntime_USE_JSEP=$(usex javascript)
		-Donnxruntime_USE_LLVM=$(usex llvm)
		-Donnxruntime_USE_MIGRAPHX=$(usex migraphx)
		-Donnxruntime_USE_MIMALLOC=$(usex mimalloc)
		-Donnxruntime_USE_MIMALLOC=OFF
		-Donnxruntime_USE_MPI=$(usex mpi)
		-Donnxruntime_USE_NCCL=OFF
		-Donnxruntime_USE_NNAPI_BUILTIN=OFF
		-Donnxruntime_USE_PREINSTALLED_EIGEN=ON
		-Donnxruntime_USE_RKNPU=OFF
		-Donnxruntime_USE_ROCM=$(usex rocm)
		-Donnxruntime_USE_TELEMETRY=OFF
		-Donnxruntime_USE_TENSORRT=$(usex tensorrt)
		-Donnxruntime_USE_TENSORRT_BUILTIN_PARSER=OFF
		-Donnxruntime_USE_TVM=OFF
		-Donnxruntime_USE_VITISAI=OFF
		-Donnxruntime_USE_WINML=OFF
		-Donnxruntime_USE_XNNPACK=$(usex xnnpack)
		-Donnxruntime_TVM_USE_HASH=OFF
		-Donnxruntime_WEBASSEMBLY_RUN_TESTS_IN_BROWSER=OFF
	)

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
