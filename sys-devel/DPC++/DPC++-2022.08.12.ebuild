# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# LLVM 16 ; See https://github.com/intel/llvm/blob/sycl-nightly/20220812/llvm/CMakeLists.txt#L19
# U20.04 ; See https://github.com/intel/llvm/blob/sycl-nightly/20220812/sycl/doc/GetStartedGuide.md?plain=1#L292

# GPUs were tested/supported upstream.
# See https://github.com/intel/llvm/blob/sycl-nightly/20220812/sycl/doc/GetStartedGuide.md
AMDGPU_TARGETS_COMPAT=(
        gfx906 # Tested upstream
	gfx908 # Tested upstream
)
CUDA_TARGETS_COMPAT=(
	sm_50 # Default
	sm_71 # Tested upstream
	#sm_86 # Set by libclc
)
# We cannot unbundle this because it has to be compiled with the clang/llvm
# that we are building here. Otherwise we run into problems running the compiler.
CPU_EMUL_COMMIT="673f2071ed7b648cd05824cd0ded24f96734e50c" # Same as 1.0.23 ; Search committer-date:<=2022-08-12
VC_INTR_COMMIT="abce9184b7a3a7fe1b02289b9285610d9dc45465" # Newer versions cause compile failure \
# See https://github.com/intel/llvm/blob/sycl-nightly/20220812/llvm/lib/SYCLLowerIR/CMakeLists.txt#L19C36-L19C76
LLVM_COMPAT=( 16 13 12 ) # Upstream tested versions
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake python-any-r1 rocm toolchain-funcs

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
SRC_URI="
https://github.com/intel/llvm/archive/refs/tags/sycl-nightly/${PV//./}.tar.gz
	-> ${P}.tar.gz
https://github.com/intel/vc-intrinsics/archive/${VC_INTR_COMMIT}.tar.gz
	-> ${P}-vc-intrinsics-${VC_INTR_COMMIT:0:7}.tar.gz
	esimd_emulator? (
https://github.com/intel/cm-cpu-emulation/archive/${CPU_EMUL_COMMIT}.tar.gz
	-> ${P}-cm-cpu-emulation-${CPU_EMUL_COMMIT:0:7}.tar.gz
	)
"
S="${WORKDIR}/llvm-sycl-nightly-${PV//./}"
BUILD_DIR="${S}/build"
CMAKE_USE_DIR="${S}/llvm"

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
SLOT="0/5" # Based on libsycl.so with SYCL_MAJOR_VERSION in \
# https://github.com/intel/llvm/blob/sycl-nightly/20220812/sycl/CMakeLists.txt#L35
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
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/(-)?}
ROCM_SLOTS=(
	rocm_4_3
	rocm_4_2
)
IUSE+="
${ALL_LLVM_TARGETS[*]}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_SLOTS[@]}
cuda esimd_emulator rocm system-llvm test
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
# See https://github.com/intel/llvm/blob/sycl-nightly/20220812/clang/include/clang/Basic/Cuda.h
# See https://github.com/intel/llvm/blob/sycl-nightly/20220812/sycl/doc/GetStartedGuide.md?plain=1#L191 for CUDA
# See https://github.com/intel/llvm/blob/sycl-nightly/20220812/sycl/doc/GetStartedGuide.md?plain=1#L247 for ROCm
RDEPEND="
	>=dev-build/libtool-2.4.6
	>=dev-libs/boost-1.71.0:=
	>=dev-util/opencl-headers-2019.08.06:=
	>=media-libs/libva-2.7.0
	dev-libs/level-zero:=
	dev-util/spirv-headers:=
	dev-util/spirv-tools
	dev-libs/opencl-icd-loader
	esimd_emulator? (
		>=dev-libs/libffi-3.3:=
	)
	cuda? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11.8*:=
		)
	)
	rocm? (
		rocm_4_3? (
			=dev-util/hip-4.3*:=[system-llvm=]
			!system-llvm? (
				=sys-devel/llvm-roc-4.3*
			)
			system-llvm? (
				=sys-devel/clang-13*
				=sys-devel/lld-13*
				=sys-devel/llvm-13*
			)
		)
		rocm_4_2? (
			=dev-util/hip-4.2*:=[system-llvm=]
			!system-llvm? (
				=sys-devel/llvm-roc-4.2*
			)
			system-llvm? (
				=sys-devel/clang-12*
				=sys-devel/lld-12*
				=sys-devel/llvm-12*
			)
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
"
PATCHES=(
	"${FILESDIR}/${PN}-2022.08.12-system-libs.patch"
	"${FILESDIR}/${PN}-2022.12-gcc13.patch"
)

pkg_setup() {
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
			export ROCM_VERSION=$(best_version "=dev-util/hip-4.3*" | sed -e "s|dev-util/hip-||g")
			export ROCM_SLOT="4.3"
		elif use rocm_4_2 ; then
			export LLVM_SLOT="12"
			export ROCM_VERSION=$(best_version "=dev-util/hip-4.2*" | sed -e "s|dev-util/hip-||g")
			export ROCM_SLOT="4.2"
		fi
# Use the clang compiler in /usr/lib64/rocm/${ROCM_SLOT}/llvm/bin/ if dev-util/hip[-system-llvm]
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

	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	export PATCH_PATHS=(
		"${S_UR}/source/adapters/hip/CMakeLists.txt"
		"${S}/clang/tools/amdgpu-arch/CMakeLists.txt"
		"${S}/libc/src/math/gpu/vendor/CMakeLists.txt"
		"${S}/libc/utils/gpu/loader/CMakeLists.txt"
		"${S}/mlir/lib/Dialect/GPU/CMakeLists.txt"
		"${S}/mlir/lib/ExecutionEngine/CMakeLists.txt"
		"${S}/mlir/lib/Target/LLVM/CMakeLists.txt"
		"${S}/opencl/CMakeLists.txt"
		"${S}/opencl/opencl-aot/CMakeLists.txt"
		"${S}/openmp/libomptarget/plugins/amdgpu/CMakeLists.txt"
		"${S}/openmp/libomptarget/plugins-nextgen/amdgpu/CMakeLists.txt"
		"${S}/sycl/CMakeLists.txt"
		"${S}/sycl/cmake/modules/AddSYCL.cmake"
		"${S}/sycl/cmake/modules/AddSYCLUnitTest.cmake"
		"${S}/sycl/include/sycl/sycl_span.hpp"
		"${S}/sycl/plugins/esimd_emulator/CMakeLists.txt"
		"${S}/sycl/plugins/hip/CMakeLists.txt"
		"${S}/sycl/plugins/level_zero/CMakeLists.txt"
		"${S}/sycl/plugins/opencl/CMakeLists.txt"
		"${S}/sycl/plugins/unified_runtime/CMakeLists.txt"
		"${S}/sycl/source/CMakeLists.txt"
		"${S}/sycl/tools/CMakeLists.txt"
		"${S}/sycl/tools/sycl-ls/CMakeLists.txt"
		"${S}/sycl/tools/sycl-prof/CMakeLists.txt"
		"${S}/sycl/tools/sycl-sanitize/CMakeLists.txt"
		"${S}/sycl/tools/sycl-trace/CMakeLists.txt"
	)
	rocm_src_prepare
}

src_configure() {
	# Unbreak clang detection with cmake
	export PATH=$(echo "${PATH}" | tr ":" $'\n' | sed -e "/ccache/d" | tr $'\n' ":")

	if use rocm && use system-llvm ; then
		export CC="${CHOST}-clang-${LLVM_SLOT}"
		export CXX="${CHOST}-clang++-${LLVM_SLOT}"
	elif use rocm ; then
		export CC="clang"
		export CXX="clang++"
	fi
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
		-DL0_INCLUDE_DIR="${ESYSROOT}/usr/include/level_zero"
		-DL0_LIBRARY="${ESYSROOT}/usr/lib64/libze_loader.so"
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
		-DXPTI_ENABLE_WERROR="OFF"
		-DXPTI_SOURCE_DIR="${S}/xpti"
	)

	if use cuda ; then
		mycmakeargs+=(
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
			-DSYCL_BUILD_PI_HIP_ROCM_DIR="/usr/lib64/rocm/${ROCM_SLOT}"
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
}
