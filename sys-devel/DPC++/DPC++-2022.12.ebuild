# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Deps:  https://github.com/intel/llvm/blob/2022-12/devops/dependencies.json
# LLVM 16 ; See https://github.com/intel/llvm/blob/2022-12/llvm/CMakeLists.txt#L12
# U20.04 ; See https://github.com/intel/llvm/blob/2022-12/sycl/doc/GetStartedGuide.md?plain=1#L292

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
# See https://github.com/intel/llvm/blob/2022-12/sycl/doc/UsersManual.md?plain=1#L60
# https://github.com/intel/llvm/blob/2022-12/clang/lib/Driver/ToolChains/SYCL.cpp
AMDGPU_TARGETS_COMPAT=(
# https://github.com/intel/llvm/blob/2022-12/clang/include/clang/Basic/Cuda.h#L72
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
	gfx90a
	gfx90c
	gfx940
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
	gfx90a
	gfx90c
	gfx940
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
)
BUILD_DIR="${WORKDIR}/llvm-${PV//./}/build"
CMAKE_USE_DIR="${WORKDIR}/llvm-${PV//./-}/llvm"
# We cannot unbundle this because it has to be compiled with the clang/llvm
# that we are building here. Otherwise we run into problems running the compiler.
CPU_EMUL_COMMIT="0c5fc287f34ae38d3184ab70ea5513d9fb1ff338" # Search committer-date:<=2022-12-13
CUDA_PARTIAL_SUPPORT=(
	sm_20
	sm_21
	sm_30
	sm_32
	sm_35
	sm_37
)
CUDA_TARGETS_COMPAT=(
# See https://github.com/intel/llvm/blob/2022-12/clang/include/clang/Basic/Cuda.h#L52
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
)
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/(-)?}
UR_COMMIT="fd711c920acc4434cb52ff18b078c082d9d7f44d" # \
# For UR_COMMIT, see https://github.com/intel/llvm/blob/2022-12/sycl/plugins/unified_runtime/CMakeLists.txt#L7
LLVM_COMPAT=( 16 13 12 ) # Upstream tested versions
PYTHON_COMPAT=( "python3_"{10..12} )
ROCM_SLOTS=(
	rocm_4_3
	rocm_4_2
)
# For VC_INTR_COMMIT, see https://github.com/intel/llvm/blob/2022-12/llvm/lib/SYCLLowerIR/CMakeLists.txt#L19
VC_INTR_COMMIT="782fbf7301dc73acaa049a4324c976ad94f587f7" # Newer versions cause compile failure \

inherit hip-versions
inherit cmake dhms flag-o-matic python-any-r1 rocm toolchain-funcs

DOCS_BUILDER="doxygen"
DOCS_DIR="build/docs"
DOCS_CONFIG_NAME="doxygen.cfg"
DOCS_DEPEND="
	>=media-gfx/graphviz-2.42.2
	virtual/latex-base
	$(python_gen_any_dep '
		>=dev-python/sphinx-1.8.5[${PYTHON_USEDEP}]
		>=dev-python/recommonmark-0.4.0[${PYTHON_USEDEP}]
		dev-python/myst-parser[${PYTHON_USEDEP}]
	')
"

inherit docs

#KEYWORDS="~amd64" # Needs install test
S="${WORKDIR}/llvm-${PV//./-}"
S_UR="${WORKDIR}/unified-runtime-${UR_COMMIT}"
SRC_URI="
https://github.com/intel/llvm/archive/refs/tags/sycl-nightly/${PV//./}.tar.gz
	-> ${P}.tar.gz
https://github.com/intel/vc-intrinsics/archive/${VC_INTR_COMMIT}.tar.gz
	-> ${P}-vc-intrinsics-${VC_INTR_COMMIT:0:7}.tar.gz
https://github.com/oneapi-src/unified-runtime/archive/${UR_COMMIT}.tar.gz
	-> ${P}-unified-runtime-${UR_COMMIT:0:7}.tar.gz
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
SLOT="0/6" # Based on libsycl.so with SYCL_MAJOR_VERSION in \
# https://github.com/intel/llvm/blob/2022-12/sycl/CMakeLists.txt#L35
IUSE+="
${ALL_LLVM_TARGETS[*]}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_SLOTS[@]}
aot cuda esimd_emulator rocm test video_cards_intel
ebuild_revision_2
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
	aot? (
		video_cards_intel
	)
	cuda? (
		llvm_targets_NVPTX
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	rocm? (
		${ROCM_REQUIRED_USE}
		llvm_targets_AMDGPU
		^^ (
			${ROCM_SLOTS[@]}
		)
	)
"
# See https://github.com/intel/llvm/blob/2022-12/clang/include/clang/Basic/Cuda.h
# See https://github.com/intel/llvm/blob/2022-12/sycl/doc/GetStartedGuide.md?plain=1#L191 for CUDA
# See https://github.com/intel/llvm/blob/2022-12/sycl/doc/GetStartedGuide.md?plain=1#L247 for ROCm
RDEPEND="
	>=dev-build/libtool-2.4.6
	>=dev-libs/boost-1.71.0:=
	>=dev-util/opencl-headers-2019.08.06:=
	>=media-libs/libva-2.7.0
	dev-libs/level-zero:=
	dev-util/spirv-headers:=
	dev-util/spirv-tools
	dev-libs/opencl-icd-loader
	aot? (
		video_cards_intel? (
			dev-libs/intel-compute-runtime[l0]
		)
	)
	cuda? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11.8*:=
		)
	)
	esimd_emulator? (
		>=dev-libs/libffi-3.3:=
	)
	rocm? (
		rocm_4_3? (
			=dev-util/hip-4.3*:=
			=sys-devel/llvm-roc-4.3*
		)
		rocm_4_2? (
			=dev-util/hip-4.2*:=
			=sys-devel/llvm-roc-4.2*
		)
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.16.3
	>=sys-devel/gcc-7.1.0[cxx]
	virtual/pkgconfig
	rocm? (
		rocm_4_3? (
			~sys-devel/llvm-roc-${HIP_4_3_VERSION}:4.3/${HIP_4_3_VERSION}
		)
		rocm_4_2? (
			~sys-devel/llvm-roc-${HIP_4_2_VERSION}:4.2/${HIP_4_2_VERSION}
		)
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-2022.12-system-libs.patch"
	"${FILESDIR}/${PN}-2022.12-gcc13.patch"
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
	warn_untested_gpu
	warn_partial_gpu_support
	if tc-is-gcc ; then
		if ver_test $(gcc-version) -lt "7.1" ; then
eerror "Switch to >=sys-devel/gcc-7.1"
			die
		fi
	fi
	python_setup
	if use rocm ; then
		if use rocm_4_3 ; then
			export LLVM_SLOT="13"
			export ROCM_VERSION="${HIP_4_3_VERSION}"
			export ROCM_SLOT="4.3"
		elif use rocm_4_2 ; then
			export LLVM_SLOT="12"
			export ROCM_VERSION="${HIP_4_2_VERSION}"
			export ROCM_SLOT="4.2"
		fi
# Use the clang compiler in /opt/rocm-${ROCM_VERSION}/llvm/bin/ if dev-util/hip[-system-llvm]
# Use the clang compiler in /usr/lib/llvm/${LLVM_SLOT}/bin/ if dev-util/hip[system-llvm]
		rocm_pkg_setup
	else
		if use llvm_slot_16 ; then
			export LLVM_MAX_SLOT="16"
		elif use llvm_slot_13 ; then
			export LLVM_MAX_SLOT="13"
		elif use llvm_slot_12 ; then
			export LLVM_MAX_SLOT="12"
		fi
		llvm_pkg_setup
	fi
}

src_prepare() {
	cmake_src_prepare

	pushd "${WORKDIR}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/${PN}-2022.12-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die

	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" files/*hardcoded-paths* | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	export PATCH_PATHS=(
		"${WORKDIR}/llvm-2022-12/clang/lib/Driver/ToolChains/AMDGPU.cpp"
		"${WORKDIR}/llvm-2022-12/clang/tools/amdgpu-arch/CMakeLists.txt"
		"${WORKDIR}/llvm-2022-12/mlir/lib/Dialect/GPU/CMakeLists.txt"
		"${WORKDIR}/llvm-2022-12/mlir/lib/ExecutionEngine/CMakeLists.txt"
		"${WORKDIR}/llvm-2022-12/openmp/libomptarget/plugins/amdgpu/CMakeLists.txt"
		"${WORKDIR}/llvm-2022-12/sycl/plugins/hip/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2023-10-26/clang/lib/Driver/ToolChains/AMDGPU.cpp"
		"${WORKDIR}/llvm-nightly-2023-10-26/libc/cmake/modules/prepare_libc_gpu_build.cmake"
		"${WORKDIR}/llvm-nightly-2023-10-26/libc/src/math/gpu/vendor/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2023-10-26/libc/utils/gpu/loader/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2023-10-26/mlir/lib/Dialect/GPU/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2023-10-26/mlir/lib/ExecutionEngine/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2023-10-26/mlir/lib/Target/LLVM/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2023-10-26/openmp/libomptarget/plugins-nextgen/amdgpu/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2023-10-26/sycl/plugins/hip/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2024-03-15/clang/lib/Driver/ToolChains/AMDGPU.cpp"
		"${WORKDIR}/llvm-nightly-2024-03-15/libc/src/math/amdgpu/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2024-03-15/libc/utils/gpu/loader/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2024-03-15/mlir/lib/Dialect/GPU/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2024-03-15/mlir/lib/ExecutionEngine/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2024-03-15/mlir/lib/Target/LLVM/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2024-03-15/openmp/libomptarget/plugins-nextgen/amdgpu/CMakeLists.txt"
		"${WORKDIR}/llvm-nightly-2024-03-15/sycl/plugins/hip/CMakeLists.txt"
		"${WORKDIR}/llvm-sycl-nightly-20220812/clang/lib/Driver/ToolChains/AMDGPU.cpp"
		"${WORKDIR}/llvm-sycl-nightly-20220812/clang/tools/amdgpu-arch/CMakeLists.txt"
		"${WORKDIR}/llvm-sycl-nightly-20220812/mlir/lib/Dialect/GPU/CMakeLists.txt"
		"${WORKDIR}/llvm-sycl-nightly-20220812/mlir/lib/ExecutionEngine/CMakeLists.txt"
		"${WORKDIR}/llvm-sycl-nightly-20220812/openmp/libomptarget/plugins/amdgpu/CMakeLists.txt"
		"${WORKDIR}/llvm-sycl-nightly-20220812/sycl/plugins/hip/CMakeLists.txt"
		"${WORKDIR}/llvm-sycl-nightly-20230417/clang/lib/Driver/ToolChains/AMDGPU.cpp"
		"${WORKDIR}/llvm-sycl-nightly-20230417/clang/tools/amdgpu-arch/CMakeLists.txt"
		"${WORKDIR}/llvm-sycl-nightly-20230417/libc/cmake/modules/prepare_libc_gpu_build.cmake"
		"${WORKDIR}/llvm-sycl-nightly-20230417/libc/utils/gpu/loader/CMakeLists.txt"
		"${WORKDIR}/llvm-sycl-nightly-20230417/mlir/lib/Dialect/GPU/CMakeLists.txt"
		"${WORKDIR}/llvm-sycl-nightly-20230417/mlir/lib/ExecutionEngine/CMakeLists.txt"
		"${WORKDIR}/llvm-sycl-nightly-20230417/openmp/libomptarget/plugins-nextgen/amdgpu/CMakeLists.txt"
		"${WORKDIR}/llvm-sycl-nightly-20230417/openmp/libomptarget/plugins/amdgpu/CMakeLists.txt"
		"${WORKDIR}/llvm-sycl-nightly-20230417/sycl/plugins/hip/CMakeLists.txt"
		"${WORKDIR}/unified-runtime-cf26de283a1233e6c93feb085acc10c566888b59/source/adapters/hip/CMakeLists.txt"
		"${WORKDIR}/unified-runtime-ec634ff05b067d7922ec45059dda94665e5dcd9b/source/adapters/hip/CMakeLists.txt"
	)
	rocm_src_prepare
}

src_configure() {
	addpredict "/proc/self/task/"
	# Unbreak clang detection with cmake
	export PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "/ccache/d" | tr $'\n' ":")

	if use rocm ; then
		rocm_set_default_clang
	fi

	# Prevent runtime failures with llvm parts.
	replace-flags '-O*' '-O2'

	strip-unsupported-flags

	# Extracted from buildbot/configure.py
	local mycmakeargs=(
		-DBOOST_MP11_SOURCE_DIR="${ESYSROOT}/usr "
#		-DBUILD_SHARED_LIBS # Off by default
		-DCLANG_INCLUDE_TESTS="$(usex test)"
		# The sycl part of the build system insists on installing during compiling
		# Install it to some temporary directory
		-DCMAKE_INSTALL_DOCDIR="${BUILD_DIR}/install/share/doc/${PF}"
		-DCMAKE_INSTALL_INFODIR="${BUILD_DIR}/install/share/info"
		-DCMAKE_INSTALL_MANDIR="${BUILD_DIR}/install/share/man"
		-DCMAKE_INSTALL_PREFIX="${BUILD_DIR}/install"
		-DLEVEL_ZERO_INCLUDE_DIR="${ESYSROOT}/usr/include/level_zero"
		-DLEVEL_ZERO_LIBRARY="${ESYSROOT}/usr/lib64/libze_loader.so"
		-DLLVM_BUILD_DOCS="$(usex doc)"
		-DLLVM_BUILD_TOOLS="ON"
		-DLLVM_ENABLE_ASSERTIONS="ON"
		-DLLVM_ENABLE_DOXYGEN="$(usex doc)"
		-DLLVM_ENABLE_LLD="OFF"
		-DLLVM_ENABLE_PROJECTS="clang;sycl;llvm-spirv;opencl;libdevice;xpti;xptifw;"$(usex rocm "libclc" "")";"$(usex cuda "libclc" "")";"$(usex rocm "lld" "")
		-DLLVM_ENABLE_SPHINX="$(usex doc)"
		-DLLVM_EXTERNAL_LIBDEVICE_SOURCE_DIR="${S}/libdevice"
		-DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR="${S}/llvm-spirv"
		-DLLVM_EXTERNAL_PROJECTS="sycl;llvm-spirv;opencl;libdevice;xpti;xptifw"
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${ESYSROOT}/usr"
		-DLLVM_EXTERNAL_SYCL_SOURCE_DIR="${S}/sycl"
		-DLLVM_EXTERNAL_XPTI_SOURCE_DIR="${S}/xpti"
		-DLLVM_EXTERNAL_XPTIFW_SOURCE_DIR="${S}/xptifw"
		-DLLVM_INCLUDE_TESTS="$(usex test)"
		-DLLVM_SPIRV_INCLUDE_TESTS="$(usex test)"
		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVMGenXIntrinsics_SOURCE_DIR="${WORKDIR}/vc-intrinsics-${VC_INTR_COMMIT}"
		-DSYCL_CLANG_EXTRA_FLAGS="${CXXFLAGS}"
		-DSYCL_ENABLE_PLUGINS="level_zero;opencl;"$(usev esimd_emulator)";"$(usex rocm "hip" "")";"$(usev cuda)
		-DSYCL_ENABLE_WERROR="OFF"
		-DSYCL_ENABLE_XPTI_TRACING="ON"
		-DSYCL_INCLUDE_TESTS="$(usex test)"
		-DSYCL_PI_UR_SOURCE_DIR="${WORKDIR}/unified-runtime-${UR_COMMIT}"
		-DSYCL_PI_UR_USE_FETCH_CONTENT="OFF"
		-DUNIFIED_RUNTIME_SOURCE_DIR="${WORKDIR}/unified-runtime-${UR_COMMIT}"
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
