# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# We would like to use the 6.1.0 release, but it is using U22 which needs
# Python 3.10.

# Deps:  https://github.com/intel/llvm/blob/nightly-2025-01-08/devops/dependencies.json
# LLVM 20 ; See https://github.com/intel/llvm/blob/nightly-2025-01-08/cmake/Modules/LLVMVersion.cmake
# U24.04 ; See https://github.com/intel/llvm/blob/nightly-2025-01-08/sycl/doc/GetStartedGuide.md?plain=1#L310

ALL_LLVM_TARGETS=(
	AArch64
	AMDGPU
	ARM
	AVR
	BPF
	Hexagon
	Lanai
	Mips
	MSP430
	NVPTX
	PowerPC
	RISCV
	Sparc
	SystemZ
	WebAssembly
	X86
	XCore
)
ALL_LLVM_TARGETS=(
	${ALL_LLVM_TARGETS[@]/#/llvm_targets_}
)
# GPUs were tested/supported upstream.
# See https://github.com/intel/llvm/blob/nightly-2025-01-08/sycl/doc/UsersManual.md?plain=1#L74
AMDGPU_TARGETS_COMPAT=(
# See https://github.com/intel/llvm/blob/nightly-2025-01-08/clang/include/clang/Basic/Cuda.h#L74
	gfx600
	gfx601
	gfx602
	gfx700
	gfx701
	gfx702
	gfx703
	gfx704
	gfx705
	gfx801
	gfx802
	gfx803
	gfx805
	gfx810
	gfx900
	gfx902
	gfx904
	gfx906 # Tested upstream
	gfx908 # Tested upstream
	gfx909
	gfx90a # Tested upstream
	gfx90c
	gfx940 # Tested upstream
	gfx941
	gfx942
	gfx950
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
	gfx1036
	gfx1100
	gfx1101
	gfx1102
	gfx1103
	gfx1150
	gfx1151
	gfx1152
	gfx1153
	gfx1200
	gfx1201
)
AMDGPU_UNTESTED_TARGETS=(
	gfx600
	gfx601
	gfx602
	gfx700
	gfx701
	gfx702
	gfx703
	gfx704
	gfx705
	gfx801
	gfx802
	gfx803
	gfx805
	gfx810
	gfx900
	gfx902
	gfx904
#	gfx906 # Tested upstream
#	gfx908 # Tested upstream
	gfx909
#	gfx90a # Tested upstream
	gfx90c
#	gfx940 # Tested upstream
	gfx941
	gfx942
	gfx950
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
	gfx1036
	gfx1100
	gfx1101
	gfx1102
	gfx1103
	gfx1150
	gfx1151
	gfx1152
	gfx1153
	gfx1200
	gfx1201
)
BOOST_ASSERT_COMMIT="447e0b3a331930f8708ade0e42683d12de9dfbc3"
BOOST_CONFIG_COMMIT="11385ec21012926e15a612e3bf9f9a71403c1e5b"
BOOST_CONTAINER_HASH_COMMIT="6d214eb776456bf17fbee20780a034a23438084f"
BOOST_CORE_COMMIT="083b41c17e34f1fc9b43ab796b40d0d8bece685c"
BOOST_DESCRIBE_COMMIT="50719b212349f3d1268285c586331584d3dbfeb5"
BOOST_PREDEF_COMMIT="0fdfb49c3a6789e50169a44e88a07cc889001106"
BOOST_STATIC_ASSERT_COMMIT="ba72d3340f3dc6e773868107f35902292f84b07e"
BOOST_THROW_EXCEPTION_COMMIT="7c8ec2114bc1f9ab2a8afbd629b96fbdd5901294"
BOOST_UNORDERED_COMMIT="5e6b9291deb55567d41416af1e77c2516dc1250f"
BUILD_DIR="${WORKDIR}/llvm-nightly-${PV//./}/build"
CMAKE_USE_DIR="${WORKDIR}/llvm-nightly-${PV//./-}/llvm"
COMPUTE_RUNTIME_PV="24.39.31294.12"
CUDA_TARGETS_COMPAT=(
	sm_20
	sm_21
	sm_30
	sm_32
	sm_35
	sm_37
	sm_50 # Default
	sm_52
	sm_53
	sm_60
	sm_61
	sm_62
	sm_70
	# sm_71 # Tested upstream
	sm_72
	sm_75
	sm_80
	sm_86
	sm_87
	sm_89
	sm_90
	sm_90a
	sm_100
)
CUDA_PARTIAL_SUPPORT=(
	sm_20
	sm_21
	sm_30
	sm_32
	sm_35
	sm_37
)
GCC_COMPAT=( 13 ) # Should only list non EOL
# We cannot unbundle this because it has to be compiled with the clang/llvm
# that we are building here. Otherwise we run into problems running the compiler.
CPU_EMUL_COMMIT="38f070a7e1de00d0398224e9d6306cc59010d147" # Same as 1.0.31 ; Search committer-date:<=2025-01-08
EMHASH_COMMIT="96dcae6fac2f5f90ce97c9efee61a1d702ddd634"
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
LEVEL_ZERO_PV="1.19.2"
LLVM_COMPAT=( 20 18 ) # Should only list non EOL
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/(-)?}
OPENCL_HEADERS_COMMIT="542d7a8f65ecfd88b38de35d8b10aa67b36b33b2"
OPENCL_ICD_LOADER_COMMIT="804b6f040503c47148bee535230070da6b857ae4"
PARALLEL_HASHMAP_COMMIT="8a889d3699b3c09ade435641fb034427f3fd12b6"
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOTS=(
	rocm_6_3
	rocm_6_2
)
# For the UNIFIED_MEMORY_FRAMEWORK_PV, see https://github.com/oneapi-src/unified-runtime/blob/da04d13807044aaf17615b66577fb0e832011ab1/source/common/CMakeLists.txt#L38
UNIFIED_MEMORY_FRAMEWORK_PV="0.10.0"
# For UNIFIED_RUNTIME_COMMIT, see https://github.com/intel/llvm/blob/nightly-2025-01-08/sycl/cmake/modules/UnifiedRuntimeTag.cmake
UNIFIED_RUNTIME_COMMIT="da04d13807044aaf17615b66577fb0e832011ab1" # \
# For VC_INTR_COMMIT, see https://github.com/intel/llvm/blob/nightly-2025-01-08/llvm/lib/SYCLLowerIR/CMakeLists.txt#L19
VC_INTR_COMMIT="4e51b2467104a257c22788e343dafbdde72e28bb" # Newer versions cause compile failure \

inherit hip-versions
inherit check-compiler-switch cmake dep-prepare dhms flag-o-matic llvm python-any-r1 rocm toolchain-funcs

DOCS_BUILDER="doxygen"
DOCS_DIR="build/docs"
DOCS_CONFIG_NAME="doxygen.cfg"
DOCS_DEPEND="
	>=media-gfx/graphviz-2.42.2
	virtual/latex-base
	$(python_gen_any_dep '
		>=dev-python/myst-parser-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-7.2.6[${PYTHON_USEDEP}]
		>=dev-python/recommonmark-0.7.1[${PYTHON_USEDEP}]
	')
"

inherit docs

#KEYWORDS="~amd64" # Needs install test
S="${WORKDIR}/llvm-nightly-${PV//./-}"
S_UR="${WORKDIR}/unified-runtime-${UNIFIED_RUNTIME_COMMIT}"
SRC_URI="
https://github.com/intel/llvm/archive/refs/tags/nightly-${PV//./-}.tar.gz
	-> ${P}.tar.gz
https://github.com/intel/vc-intrinsics/archive/${VC_INTR_COMMIT}.tar.gz
	-> ${P}-vc-intrinsics-${VC_INTR_COMMIT:0:7}.tar.gz
https://github.com/oneapi-src/unified-runtime/archive/${UNIFIED_RUNTIME_COMMIT}.tar.gz
	-> ${P}-unified-runtime-${UNIFIED_RUNTIME_COMMIT:0:7}.tar.gz
https://github.com/oneapi-src/level-zero/archive/refs/tags/v${LEVEL_ZERO_PV}.tar.gz
	-> level-zero-${LEVEL_ZERO_PV}.tar.gz
https://github.com/intel/compute-runtime/archive/refs/tags/24.39.31294.12.tar.gz
	-> compute-runtime-${COMPUTE_RUNTIME_PV}.tar.gz
https://github.com/oneapi-src/unified-memory-framework/archive/refs/tags/v${UNIFIED_MEMORY_FRAMEWORK_PV}.tar.gz
	-> unified-memory-framework-${UNIFIED_MEMORY_FRAMEWORK_PV}.tar.gz
https://github.com/KhronosGroup/OpenCL-Headers/archive/${OPENCL_HEADERS_COMMIT}.tar.gz
	-> OpenCL-Headers-${OPENCL_HEADERS_COMMIT:0:7}.tar.gz
https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/${OPENCL_ICD_LOADER_COMMIT}.tar.gz
	-> OpenCL-ICD-Loader-${OPENCL_ICD_LOADER_COMMIT:0:7}.tar.gz


https://github.com/boostorg/assert/archive/${BOOST_ASSERT_COMMIT}.tar.gz
	-> boostorg-assert-${BOOST_ASSERT_COMMIT:0:7}.tar.gz
https://github.com/boostorg/config/archive/${BOOST_CONFIG_COMMIT}.tar.gz
	-> boostorg-config-${BOOST_CONFIG_COMMIT:0:7}.tar.gz
https://github.com/boostorg/container_hash/archive/${BOOST_CONTAINER_HASH_COMMIT}.tar.gz
	-> boostorg-container_hash-${BOOST_CONTAINER_HASH_COMMIT:0:7}.tar.gz
https://github.com/boostorg/core/archive/${BOOST_CORE_COMMIT}.tar.gz
	-> boostorg-core-${BOOST_CORE_COMMIT:0:7}.tar.gz
https://github.com/boostorg/describe/archive/${BOOST_DESCRIBE_COMMIT}.tar.gz
	-> boostorg-describe-${BOOST_DESCRIBE_COMMIT:0:7}.tar.gz
https://github.com/boostorg/predef/archive/${BOOST_PREDEF_COMMIT}.tar.gz
	-> boostorg-predef-${BOOST_PREDEF_COMMIT:0:7}.tar.gz
https://github.com/boostorg/static_assert/archive/${BOOST_STATIC_ASSERT_COMMIT}.tar.gz
	-> boostorg-static_assert-${BOOST_STATIC_ASSERT_COMMIT:0:7}.tar.gz
https://github.com/boostorg/throw_exception/archive/${BOOST_THROW_EXCEPTION_COMMIT}.tar.gz
	-> boostorg-throw_exception-${BOOST_THROW_EXCEPTION_COMMIT:0:7}.tar.gz
https://github.com/boostorg/unordered/archive/${BOOST_UNORDERED_COMMIT}.tar.gz
	-> boostorg-unordered-${BOOST_UNORDERED_COMMIT:0:7}.tar.gz

https://github.com/ktprime/emhash/archive/${EMHASH_COMMIT}.tar.gz
	-> emhash-${EMHASH_COMMIT:0:7}.tar.gz

https://github.com/greg7mdp/parallel-hashmap/archive/${PARALLEL_HASHMAP_COMMIT}.tar.gz
	-> parallel-hashmap-${PARALLEL_HASHMAP_COMMIT:0:7}.tar.gz

	esimd_emulator? (
https://github.com/intel/cm-cpu-emulation/archive/${CPU_EMUL_COMMIT}.tar.gz
	-> ${P}-cm-cpu-emulation-${CPU_EMUL_COMMIT:0:7}.tar.gz
	)
"


DESCRIPTION="oneAPI Data Parallel C++ compiler"
HOMEPAGE="https://github.com/intel/llvm"
LICENSE="
	Apache-2.0
	MIT
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/7" # Based on libsycl.so with SYCL_MAJOR_VERSION in \
# https://github.com/intel/llvm/blob/nightly-2025-01-08/sycl/CMakeLists.txt#L35
IUSE+="
${ALL_LLVM_TARGETS[*]}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_SLOTS[@]}
aot cet cfi clang cuda esimd_emulator hardened native-cpu openmp rocm +sycl-fusion test
video_cards_intel
ebuild_revision_4
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
	?? (
		cuda
		rocm
	)
	?? (
		cet
		cfi
	)
	aot? (
		video_cards_intel
	)
	cfi? (
		clang
	)
	cuda? (
		llvm_targets_NVPTX
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	rocm? (
		!cet
		${ROCM_REQUIRED_USE}
		llvm_slot_18
		llvm_targets_AMDGPU
		^^ (
			${ROCM_SLOTS[@]}
		)
	)
"
# See https://github.com/intel/llvm/blob/nightly-2025-01-08/clang/include/clang/Basic/Cuda.h#L42
# See https://github.com/intel/llvm/blob/nightly-2025-01-08/sycl/doc/GetStartedGuide.md?plain=1#L194 for CUDA
# See https://github.com/intel/llvm/blob/nightly-2025-01-08/sycl/doc/GetStartedGuide.md?plain=1#L244 for ROCm
# For compute-runtime version correspondance, see
# https://github.com/intel/compute-runtime/blob/23.52.28202.45/manifests/manifest.yml#L56
# https://github.com/oneapi-src/unified-runtime/blob/da04d13807044aaf17615b66577fb0e832011ab1/cmake/FetchLevelZero.cmake#L104
RDEPEND="
	>=dev-build/libtool-2.4.7
	>=dev-libs/boost-1.74.0:=
	>=dev-libs/level-zero-1.16.1:=
	>=dev-util/opencl-headers-2023.12.14:=
	>=dev-util/spirv-headers-1.3.275.0:=
	>=dev-util/spirv-tools-1.3.275.0
	>=media-libs/libva-2.20.0
	dev-libs/opencl-icd-loader
	aot? (
		video_cards_intel? (
			>=dev-libs/intel-compute-runtime-24.39.31294.12[l0]
		)
	)
	cuda? (
		|| (
			=dev-util/nvidia-cuda-toolkit-12.0*:=
		)
	)
	esimd_emulator? (
		>=dev-libs/libffi-3.4.6:=
	)
	rocm? (
		rocm_6_3? (
			=dev-util/hip-6.3*:=
			=sys-devel/llvm-roc-6.3*[cfi?]
		)
		rocm_6_2? (
			=dev-util/hip-6.2*:=
			=sys-devel/llvm-roc-6.2*[cfi?]
		)
	)
"
DEPEND="
	${RDEPEND}
"
gen_gcc_bdepend() {
	local s
	for s in ${GCC_COMPAT[@]} ; do
		echo "
			(
				sys-devel/gcc:${s}
			)
		"
	done
}
gen_llvm_bdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			(
				llvm-core/clang:${s}
				llvm-core/llvm:${s}
				llvm-core/lld:${s}
			)
		"
	done
}
BDEPEND="
	>=dev-build/cmake-3.28.3
	virtual/pkgconfig
	cet? (
		>=sys-devel/gcc-7.1.0[cxx]
		|| (
			$(gen_gcc_bdepend)
		)
	)
	cfi? (
		>=llvm-core/clang-3.7
		llvm-core/lld
		|| (
			$(gen_llvm_bdepend)
		)
	)
	rocm? (
		rocm_6_3? (
			~sys-devel/llvm-roc-${HIP_6_3_VERSION}:6.3/${HIP_5_4_VERSION}
		)
		rocm_6_2? (
			~sys-devel/llvm-roc-${HIP_6_2_VERSION}:6.2/${HIP_5_3_VERSION}
		)
	)
	!clang? (
		>=sys-devel/gcc-13.2.0[cxx]
	)
	clang? (
		>=sys-devel/gcc-13.2.0[cxx]
		>=llvm-core/clang-18.0
	)
"
PATCHES=(
)

warn_untested_gpu() {
	local gpu
	for gpu in ${AMDGPU_UNTESTED_TARGETS[@]} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not CI tested upstream."
		fi
	done
}

warn_partial_gpu_support() {
	local gpu
	for gpu in ${CUDA_PARTIAL_SUPPORT[@]} ; do
		if use "cuda_targets_${gpu}" ; then
ewarn "${gpu} is available but support is not feature complete."
		fi
	done
}

pkg_setup() {
	dhms_start
	check-compiler-switch_start
	warn_untested_gpu
	warn_partial_gpu_support
	if ! use clang ; then
		if ver_test $(gcc-version) -lt "13.2" ; then
eerror "Switch to >=sys-devel/gcc-13.2"
			die
		fi
	fi
	python_setup
	if use rocm ; then
		if use rocm_6_3 ; then
			export LLVM_SLOT="18"
			export ROCM_VERSION="${HIP_6_3_VERSION}"
			export ROCM_SLOT="6.3"
		elif use rocm_6_2 ; then
			export LLVM_SLOT="18"
			export ROCM_VERSION="${HIP_6_2_VERSION}"
			export ROCM_SLOT="6.2"
		fi
# Use the clang compiler in /opt/rocm-${ROCM_VERSION}/llvm/bin/ if dev-util/hip[-system-llvm]
# Use the clang compiler in /usr/lib/llvm/${LLVM_SLOT}/bin/ if dev-util/hip[system-llvm]
		rocm_pkg_setup
	else
		if use llvm_slot_18 ; then
			export LLVM_MAX_SLOT="18"
		fi
		llvm_pkg_setup
	fi
	if use cfi ; then
		if [[ -z "${LLVM_SLOT}" ]] ; then
			local s
			for s in ${LLVM_COMPAT[@]} ; do
				if \
					   has_version "llvm-core/clang:${s}" \
					&& has_version "llvm-core/lld:${s}" \
					&& has_version "llvm-core/llvm:${s}" \
				; then
					LLVM_SLOT="${s}"
					break
				fi
			done
		fi
		if ! use rocm ; then
			llvm_pkg_setup
		fi
	fi
	if tc-is-clang ; then
		if ver_test $(clang-version) -lt "18.0" ; then
eerror "Switch to >=llvm-core/clang-18.0"
			die
		fi
	fi
}

src_prepare() {
	cmake_src_prepare

	dep_prepare_cp "${WORKDIR}/level-zero-${LEVEL_ZERO_PV}"					"${WORKDIR}/_deps/level-zero-loader-src"
	dep_prepare_mv "${WORKDIR}/compute-runtime-${COMPUTE_RUNTIME_PV}/level_zero/include"	"${WORKDIR}/_deps/content-exp-headers/level_zero/include"
	dep_prepare_cp "${WORKDIR}/OpenCL-Headers-${OPENCL_HEADERS_COMMIT}"			"${WORKDIR}/_deps/opencl-headers-src"
	dep_prepare_mv "${WORKDIR}/OpenCL-Headers-${OPENCL_HEADERS_COMMIT}"			"${WORKDIR}/_deps/ocl-headers-src"
	dep_prepare_mv "${WORKDIR}/OpenCL-ICD-Loader-${OPENCL_ICD_LOADER_COMMIT}"		"${WORKDIR}/_deps/ocl-icd-src"
	dep_prepare_mv "${WORKDIR}/unified-memory-framework-${UNIFIED_MEMORY_FRAMEWORK_PV}"	"${WORKDIR}/_deps/unified-memory-framework-src"

	dep_prepare_mv "${WORKDIR}/assert-${BOOST_ASSERT_COMMIT}"				"${WORKDIR}/_deps/boost_assert-src"
	dep_prepare_mv "${WORKDIR}/config-${BOOST_CONFIG_COMMIT}"				"${WORKDIR}/_deps/boost_config-src"
	dep_prepare_mv "${WORKDIR}/container_hash-${BOOST_CONTAINER_HASH_COMMIT}"		"${WORKDIR}/_deps/boost_container_hash-src"
	dep_prepare_mv "${WORKDIR}/core-${BOOST_CORE_COMMIT}"					"${WORKDIR}/_deps/boost_core-src"
	dep_prepare_mv "${WORKDIR}/describe-${BOOST_DESCRIBE_COMMIT}"				"${WORKDIR}/_deps/boost_describe-src"
	dep_prepare_mv "${WORKDIR}/predef-${BOOST_PREDEF_COMMIT}"				"${WORKDIR}/_deps/boost_predef-src"
	dep_prepare_mv "${WORKDIR}/static_assert-${BOOST_STATIC_ASSERT_COMMIT}"			"${WORKDIR}/_deps/boost_static_assert-src"
	dep_prepare_mv "${WORKDIR}/throw_exception-${BOOST_THROW_EXCEPTION_COMMIT}"		"${WORKDIR}/_deps/boost_throw_exception-src"
	dep_prepare_mv "${WORKDIR}/unordered-${BOOST_UNORDERED_COMMIT}"				"${WORKDIR}/_deps/boost_unordered-src"

	dep_prepare_mv "${WORKDIR}/emhash-${EMHASH_COMMIT}"					"${WORKDIR}/_deps/emhash-headers-src"
	dep_prepare_mv "${WORKDIR}/parallel-hashmap-${PARALLEL_HASHMAP_COMMIT}"			"${WORKDIR}/_deps/parallel-hashmap-src"

	pushd "${S}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/${PN}-2025.01.08-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die

	pushd "${WORKDIR}/unified-runtime-${UNIFIED_RUNTIME_COMMIT}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/${PN}-2025.01.08-unified-runtime-da04d13-exp-headers-path.patch"
	popd >/dev/null 2>&1 || die

	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" files/*hardcoded-paths* | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	export PATCH_PATHS=(
		"${WORKDIR}/llvm-nightly-2025-01-08/clang/lib/Driver/ToolChains/AMDGPU.cpp"
		"${WORKDIR}/llvm-nightly-2025-01-08/libc/benchmarks/gpu/src/math/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2025-01-08/libc/src/math/amdgpu/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2025-01-08/libc/utils/gpu/loader/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2025-01-08/mlir/lib/ExecutionEngine/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2025-01-08/mlir/lib/Target/LLVM/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2025-01-08/offload/plugins-nextgen/amdgpu/CMakeLists.txt"
	)
	if use rocm ; then
		rocm_src_prepare
	else
		local x
		for x in ${PATCH_PATHS[@]} ; do
			sed -i -e "s|-@ROCM_VERSION@||g" "${x}" || die
		done
	fi
}

src_configure() {
	addpredict "/proc/self/task/"
	local mycmakeargs=()

	# Unbreak clang detection with cmake
	export PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "/ccache/d" | tr $'\n' ":")

	if use clang || use cfi ; then
		local s
		for s in ${LLVM_COMPAT[@]} ; do
			if [[ -n "${LLVM_SLOT}" ]] ; then
				if (( ${s} > ${LLVM_SLOT} )) ; then
					continue
				fi
			fi
			if \
				   has_version "llvm-core/clang:${s}" \
				&& has_version "llvm-core/lld:${s}" \
				&& has_version "llvm-core/llvm:${s}" \
			; then
				export CC="${CHOST}-clang-${s}"
				export CXX="${CHOST}-clang++-${s}"
				export CPP="${CC} -E"
				strip-unsupported-flags
				break
			fi
		done
	fi

	if use cet ; then
		local s
		for s in ${GCC_COMPAT[@]} ; do
			if has_version "sys-devel/gcc:${s}" ; then
				export CC="${CHOST}-gcc-${s}"
				export CXX="${CHOST}-g++-${s}"
				export CPP="${CC} -E"
				strip-unsupported-flags
				break
			fi
		done
		unset LD
		replace-flags "-O0" "-O1" # Promote to fix _FORTIFY_SOURCE=2
		mycmakeargs+=(
			-DEXTRA_SECURITY_FLAGS="sanitize"
		)
	elif use cfi ; then
		append-ldflags -fuse-ld=lld
		unset LD
		replace-flags "-O0" "-O2" # Promote to fix _FORTIFY_SOURCE=2
		mycmakeargs+=(
			-DEXTRA_SECURITY_FLAGS="sanitize"
		)
	elif use hardened ; then
		replace-flags "-O0" "-O2" # Promote to fix _FORTIFY_SOURCE=2
		mycmakeargs+=(
			-DEXTRA_SECURITY_FLAGS="default"
		)
	else
		mycmakeargs+=(
			-DEXTRA_SECURITY_FLAGS="none"
		)
	fi

	if use rocm ; then
		rocm_set_default_clang
	fi

	# Prevent runtime failures with llvm parts.
	replace-flags '-O*' '-O2'
	export MAKEOPTS="-j1"

	strip-unsupported-flags

	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	# Extracted from buildbot/configure.py
	mycmakeargs+=(
		-DBOOST_MP11_SOURCE_DIR="${ESYSROOT}/usr "
		-DBUG_REPORT_URL="https://github.com/intel/llvm/issues"
#		-DBUILD_SHARED_LIBS # Off by default
		-DCLANG_INCLUDE_TESTS="$(usex test)"
		# The sycl part of the build system insists on installing during compiling
		# Install it to some temporary directory
		-DCMAKE_INSTALL_DOCDIR="${BUILD_DIR}/install/share/doc/${PF}"
		-DCMAKE_INSTALL_INFODIR="${BUILD_DIR}/install/share/info"
		-DCMAKE_INSTALL_MANDIR="${BUILD_DIR}/install/share/man"
		-DCMAKE_INSTALL_PREFIX="${BUILD_DIR}/install"
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DFETCHCONTENT_QUIET=OFF
#		-DFETCHCONTENT_SOURCE_DIR_LEVEL_ZERO_LOADER="${WORKDIR}/level-zero-loader-${LEVEL_ZERO_PV}"
		-DFETCHCONTENT_SOURCE_DIR_EXP_HEADERS="${WORKDIR}/_deps/content-exp-headers/level_zero/include"
		-DEXP_HEADERS_SOURCE_DIR="${WORKDIR}/_deps/exp_headers-src"
		-DFETCHCONTENT_BASE_DIR="${WORKDIR}/_deps" # Default:  ${CMAKE_BINARY_DIR}/_deps
#		-DLEVEL_ZERO_INCLUDE_DIR="${ESYSROOT}/usr/include/level_zero"
#		-DLEVEL_ZERO_LIBRARY="${ESYSROOT}/usr/lib64/libze_loader.so"
		-DLLVM_BUILD_DOCS="$(usex doc)"
		-DLLVM_BUILD_TOOLS="ON"
		-DLLVM_ENABLE_ASSERTIONS="ON"
		-DLLVM_ENABLE_DOXYGEN="$(usex doc)"
		-DLLVM_ENABLE_LLD="OFF"
		-DLLVM_ENABLE_PROJECTS="clang;sycl;llvm-spirv;opencl;libdevice;xpti;xptifw;"$(usex rocm "libclc" "")";"$(usex cuda "libclc" "")";"$(usex rocm "lld" "")";"$(usex openmp "openmp" "")
		-DLLVM_ENABLE_SPHINX="$(usex doc)"
		-DLLVM_EXTERNAL_LIBDEVICE_SOURCE_DIR="${S}/libdevice"
		-DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR="${S}/llvm-spirv"
		-DLLVM_EXTERNAL_PROJECTS="sycl;llvm-spirv;opencl;libdevice;xpti;xptifw"
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${ESYSROOT}/usr"
		-DLLVM_EXTERNAL_SYCL_FUSION_SOURCE_DIR="${S}/sycl-fusion"
		-DLLVM_EXTERNAL_SYCL_SOURCE_DIR="${S}/sycl"
		-DLLVM_EXTERNAL_SYCL_JIT_SOURCE_DIR="${WORKDIR}/llvm-nightly-${PV//./-}/sycl-jit"
		-DLLVM_EXTERNAL_XPTI_SOURCE_DIR="${S}/xpti"
		-DLLVM_EXTERNAL_XPTIFW_SOURCE_DIR="${S}/xptifw"
		-DLLVM_INCLUDE_TESTS="$(usex test)"
		-DLLVM_SPIRV_INCLUDE_TESTS="$(usex test)"
		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVMGenXIntrinsics_SOURCE_DIR="${WORKDIR}/vc-intrinsics-${VC_INTR_COMMIT}"
		-DSYCL_CLANG_EXTRA_FLAGS="${CXXFLAGS}"
		-DSYCL_ENABLE_BACKENDS="level_zero;opencl;"$(usev esimd_emulator)";"$(usex rocm "hip" "")";"$(usev cuda)";"$(usex native-cpu "native_cpu" "")
		-DSYCL_ENABLE_EXTENSION_JIT="OFF" # FIXME
		-DSYCL_ENABLE_KERNEL_FUSION=$(usex sycl-fusion)
		-DSYCL_ENABLE_MAJOR_RELEASE_PREVIEW_LIB="OFF" # ON upstream
		-DSYCL_ENABLE_WERROR="OFF"
		-DSYCL_ENABLE_XPTI_TRACING="ON"
		-DSYCL_INCLUDE_TESTS="$(usex test)"
		-DSYCL_UR_SOURCE_DIR="${WORKDIR}/unified-runtime-${UNIFIED_RUNTIME_COMMIT}"
		-DSYCL_UR_USE_FETCH_CONTENT="OFF"
		-DXPTI_ENABLE_WERROR="OFF"
		-DXPTI_SOURCE_DIR="${S}/xpti"
	)

	if use cuda ; then
		mycmakeargs+=(
			-DCUDA_TOOLKIT_ROOT_DIR="/opt/cuda"
			-DLIBCLC_GENERATE_REMANGLED_VARIANTS="ON"
			-DLIBCLC_TARGETS_TO_BUILD=";nvptx64--;nvptx64--nvidiacl"
		)
	fi

	if use doc ; then
		mycmakeargs+=(
			-DSPHINX_WARNINGS_AS_ERRORS="OFF"
		)
	fi

	if use esimd_emulator ; then
		mycmakeargs+=(
			-DLibFFI_INCLUDE_DIR="${ESYSROOT}/usr/lib64/libffi/include"
			-DUSE_LOCAL_CM_EMU_SOURCE="${WORKDIR}/cm-cpu-emulation-${CPU_EMUL_COMMIT}"
		)
	fi

	if use native-cpu ; then
		mycmakeargs+=(
			-DLIBCLC_TARGETS_TO_BUILD=";$(gcc -dumpmachine)"
		)
	fi

	if use openmp ; then
		mycmakeargs+=(
			-DOPENMP_ENABLE_LIBOMPTARGET=ON
			-DLIBOMPTARGET_ENABLE_EXPERIMENTAL_OPENMP_GPU=ON
		)
	fi

	if use rocm ; then
		mycmakeargs+=(
			-DLIBCLC_GENERATE_REMANGLED_VARIANTS="ON"
			-DLIBCLC_TARGETS_TO_BUILD=";amdgcn--;amdgcn--amdhsa"
			-DSYCL_BUILD_PI_HIP_ROCM_DIR="/opt/rocm-${ROCM_VERSION}"
			-DSYCL_BUILD_PI_HIP_PLATFORM="AMD"
		)
	fi


	cmake_src_configure
}

src_compile() {
	# Build sycl (this also installs some stuff already)
	cmake_build deploy-sycl-toolchain

	use doc && cmake_build doxygen-sycl

	# Install all other files into the same temporary directory
	cmake_build install
}

src_test() {
	cmake_build check
}

gen_envd() {
# Copied from llvm ebuild, put env file last so we don't overwrite main llvm/clang
newenvd - "60llvm-intel" <<-_EOF_
PATH="${EPREFIX}${LLVM_INTEL_DIR}/bin"
# We need to duplicate it in ROOTPATH for Portage to respect...
ROOTPATH="${EPREFIX}${LLVM_INTEL_DIR}/bin"
MANPATH="${EPREFIX}${LLVM_INTEL_DIR}/share/man"
LDPATH="${EPREFIX}${LLVM_INTEL_DIR}/lib:${EPREFIX}${LLVM_INTEL_DIR}/lib64"
_EOF_
}

src_install() {
	einstalldocs

	local LLVM_INTEL_DIR="/usr/lib/llvm/intel"
	dodir "${LLVM_INTEL_DIR}"

	# Copy the temporary directory to the image directory.
	mv "${BUILD_DIR}/install"/* "${ED}/${LLVM_INTEL_DIR}" || die

	# Convienence symlinks
	dosym "${LLVM_INTEL_DIR}/bin/clang" "/usr/bin/icx"
	dosym "${LLVM_INTEL_DIR}/bin/clang++" "/usr/bin/icpx"

	# Do this in the ebuild instead
	#gen_envd
	dhms_end
}
