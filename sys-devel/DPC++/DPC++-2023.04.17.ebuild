# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# LLVM 17

# We cannot unbundle this because it has to be compiled with the clang/llvm
# that we are building here. Otherwise we run into problems running the compiler.
CPU_EMUL_COMMIT="38f070a7e1de00d0398224e9d6306cc59010d147" # Search committer-date:<=2023-04-17
VC_INTR_COMMIT="3ac855c9253d608a36d10b8ff87e62aa413bbf23" # Newer versions cause compile failure \
# See https://github.com/intel/llvm/blob/sycl-nightly/20230417/llvm/lib/SYCLLowerIR/CMakeLists.txt#L19C36-L19C76
UR_COMMIT="74843ea0800e6fb7ce0f82e0ef991fc258f4b9bd" # \
# See https://github.com/intel/llvm/blob/sycl-nightly/20230417/sycl/plugins/unified_runtime/CMakeLists.txt#L7
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake python-any-r1

DOCS_BUILDER="doxygen"
DOCS_DIR="build/docs"
DOCS_CONFIG_NAME="doxygen.cfg"
DOCS_DEPEND="
	media-gfx/graphviz
	virtual/latex-base
	$(python_gen_any_dep '
		dev-python/myst-parser[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/recommonmark[${PYTHON_USEDEP}]
	')
"

inherit docs

SRC_URI="
https://github.com/intel/llvm/archive/refs/tags/sycl-nightly/${PV//./}.tar.gz
	-> ${P}.tar.gz
https://github.com/intel/vc-intrinsics/archive/${VC_INTR_COMMIT}.tar.gz
	-> ${P}-vc-intrinsics-${VC_INTR_COMMIT:0:7}.tar.gz
https://github.com/oneapi-src/unified-runtime/archive/${UR_COMMIT}.tar.gz
	-> ${P}-unified-runtime-${UR_COMMIT}.tar.gz
	esimd_emulator? (
https://github.com/intel/cm-cpu-emulation/archive/${CPU_EMUL_COMMIT}.tar.gz
	-> ${P}-cm-cpu-emulation-${CPU_EMUL_COMMIT:0:7}.tar.gz
	)
"
S="${WORKDIR}/llvm-${PV//./-}"
BUILD_DIR="${S}/build"
CMAKE_USE_DIR="${S}/llvm"

DESCRIPTION="oneAPI Data Parallel C++ compiler"
HOMEPAGE="https://github.com/intel/llvm"
LICENSE="
	Apache-2.0
	MIT
"
SLOT="0/6" # FIXME: Based on libsycl.so in SYCL_MAJOR_VERSION in \
# https://github.com/intel/llvm/blob/sycl-nightly/20230417/sycl/CMakeLists.txt#L35
#KEYWORDS="~amd64" # Needs install test
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
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/(-)?}
IUSE="
${ALL_LLVM_TARGETS[*]}
cuda hip test esimd_emulator
"
REQUIRED_USE="
	?? (
		cuda
		hip
	)
	cuda? (
		llvm_targets_NVPTX
	)
	hip? (
		llvm_targets_AMDGPU
	)
"
RESTRICT="
	!test? (
		test
	)
"
# See https://github.com/intel/llvm/blob/sycl-nightly/20230417/clang/include/clang/Basic/Cuda.h
# See https://github.com/intel/llvm/blob/sycl-nightly/20230417/sycl/doc/GetStartedGuide.md?plain=1#L191 for CUDA
# See https://github.com/intel/llvm/blob/sycl-nightly/20230417/sycl/doc/GetStartedGuide.md?plain=1#L247 for ROCm
DEPEND="
	dev-build/libtool
	dev-libs/boost:=
	dev-libs/level-zero:=
	dev-libs/opencl-icd-loader
	dev-util/opencl-headers
	dev-util/spirv-headers
	dev-util/spirv-tools
	media-libs/libva
	esimd_emulator? (
		dev-libs/libffi:=
	)
	cuda? (
		|| (
			~dev-util/nvidia-cuda-toolkit-11.8:=
		)
	)
	hip? (
		|| (
			~dev-util/hip-4.3.0:=
			~dev-util/hip-4.2.0:=
		)
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${P}-system-libs.patch"
	"${FILESDIR}/${P}-gcc13.patch"
)

src_configure() {
	# Extracted from buildbot/configure.py
	local mycmakeargs=(
		-DBOOST_MP11_SOURCE_DIR="${ESYSROOT}/usr "
		-DCLANG_INCLUDE_TESTS="$(usex test)"
		# The sycl part of the build system insists on installing during compiling
		# Install it to some temporary directory
		-DCMAKE_INSTALL_PREFIX="${BUILD_DIR}/install"
		-DCMAKE_INSTALL_MANDIR="${BUILD_DIR}/install/share/man"
		-DCMAKE_INSTALL_INFODIR="${BUILD_DIR}/install/share/info"
		-DCMAKE_INSTALL_DOCDIR="${BUILD_DIR}/install/share/doc/${PF}"
		-DLEVEL_ZERO_LIBRARY="${ESYSROOT}/usr/lib64/libze_loader.so"
		-DLEVEL_ZERO_INCLUDE_DIR="${ESYSROOT}/usr/include"
		-DLLVM_BUILD_DOCS="$(usex doc)"
		-DLLVM_BUILD_TOOLS="ON"
		-DLLVM_ENABLE_ASSERTIONS="ON"
		-DLLVM_ENABLE_DOXYGEN="$(usex doc)"
		-DLLVM_ENABLE_LLD="OFF"
		-DLLVM_ENABLE_PROJECTS="clang;sycl;llvm-spirv;opencl;libdevice;xpti;xptifw"
		-DLLVM_ENABLE_SPHINX="$(usex doc)"
		-DLLVM_EXTERNAL_XPTIFW_SOURCE_DIR="${S}/xptifw"
		-DLLVM_EXTERNAL_LIBDEVICE_SOURCE_DIR="${S}/libdevice"
		-DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR="${S}/llvm-spirv"
		-DLLVM_EXTERNAL_PROJECTS="sycl;llvm-spirv;opencl;libdevice;xpti;xptifw"
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${ESYSROOT}/usr"
		-DLLVM_EXTERNAL_SYCL_SOURCE_DIR="${S}/sycl"
		-DLLVM_EXTERNAL_XPTI_SOURCE_DIR="${S}/xpti"
		-DLLVM_INCLUDE_TESTS="$(usex test)"
		-DLLVM_SPIRV_INCLUDE_TESTS="$(usex test)"
		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVMGenXIntrinsics_SOURCE_DIR="${WORKDIR}/vc-intrinsics-${VC_INTR_PV}"
		-DSYCL_CLANG_EXTRA_FLAGS="${CXXFLAGS}"
		-DSYCL_ENABLE_WERROR="OFF"
		-DSYCL_ENABLE_PLUGINS="level_zero;opencl;$(usev esimd_emulator);$(usev hip);$(usev cuda)"
		-DSYCL_ENABLE_XPTI_TRACING="ON"
		-DSYCL_INCLUDE_TESTS="$(usex test)"
		-DUNIFIED_RUNTIME_SOURCE_DIR="${WORKDIR}/unified-runtime-${UR_COMMIT}"
		-DXPTI_SOURCE_DIR="${S}/xpti"
		-DXPTI_ENABLE_WERROR="OFF"
	)

	if use cuda; then
		mycmakeargs+=(
			-DLIBCLC_GENERATE_REMANGLED_VARIANTS="ON"
			-DLIBCLC_TARGETS_TO_BUILD=";nvptx64--;nvptx64--nvidiacl"
		)
	fi

	if use doc; then
		mycmakeargs+=(
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
		)
	fi

	if use esimd_emulator; then
		mycmakeargs+=(
			-DLibFFI_INCLUDE_DIR="${ESYSROOT}/usr/lib64/libffi/include"
			-DUSE_LOCAL_CM_EMU_SOURCE="${WORKDIR}/cm-cpu-emulation-${CPU_EMUL_PV}"
		)
	fi

	if use hip; then
		mycmakeargs+=(
			-DLIBCLC_GENERATE_REMANGLED_VARIANTS="ON"
			-DLIBCLC_TARGETS_TO_BUILD=";amdgcn--;amdgcn--amdhsa"
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
