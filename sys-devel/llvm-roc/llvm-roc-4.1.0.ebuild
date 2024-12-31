# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="RelWithDebInfo"
LLVM_SLOT=12
LLVM_TARGETS=(
	AMDGPU
	NVPTX
	X86
)
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
SANITIZER_FLAGS=(
	cfi
)

inherit cmake dhms flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/llvm-project-rocm-${PV}/llvm"
SRC_URI="
https://github.com/RadeonOpenCompute/llvm-project/archive/rocm-${PV}.tar.gz
	-> llvm-project-rocm-${PV}.tar.gz
https://github.com/llvm/llvm-project/commit/c23147106f7efc4b5e29c47a08951116b4d994ac.patch
	-> llvm-project-rocm-c231471.patch
"
# c231471 -  [clang][CUDA][Windows] Fix compilation error on Windows with `uint32_t __nvvm_get_smem_pointer`
#   Fix for HIPIFY

DESCRIPTION="The ROCm™ fork of the LLVM project"
HOMEPAGE="
	https://github.com/RadeonOpenCompute/llvm-project
"
SUBPROJECTS_LICENSES="
	(
		Apache-2.0
		CC0-1.0
	)
	(
		Apache-2.0-with-LLVM-exceptions
		BSD
		MIT
	)
	(
		Apache-2.0-with-LLVM-exceptions
		custom
		MIT
		UoI-NCSA
	)
	(
		Apache-2.0-with-LLVM-exceptions
		UoI-NCSA
	)
	(
		BSD
		rc
	)
	Apache-2.0
	BSD
	ISC
	MIT
"
LICENSE="
	${SUBPROJECTS_LICENSES}
	(
		Apache-2.0-with-LLVM-exceptions
		UoI-NCSA
	)
	BSD
	rc
	public-domain
"
# Apache-2.0 - llvm-project-rocm-5.6.0/third-party/benchmark/LICENSE
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA - llvm-project-rocm-5.6.0/lldb/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions, BSD, MIT - llvm-project-rocm-5.6.0/libclc/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA, MIT, custom - llvm-project-rocm-5.6.0/openmp/LICENSE.TXT
#   Keyword search:  "all right, title, and interest"
# BSD - llvm-project-rocm-5.6.0/third-party/unittest/googlemock/LICENSE.txt
# BSD - llvm-project-rocm-5.6.0/openmp/runtime/src/thirdparty/ittnotify/LICENSE.txt
# CC0-1.0, Apache-2.0 - llvm-project-rocm-5.6.0/llvm/lib/Support/BLAKE3/LICENSE
# ISC - llvm-project-rocm-5.6.0/lldb/third_party/Python/module/pexpect-4.6/LICENSE
# MIT - llvm-project-rocm-5.6.0/polly/lib/External/isl/LICENSE
# rc, BSD - llvm-project-rocm-5.6.0/llvm/lib/Support/COPYRIGHT.regex
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
${LLVM_TARGETS[@]/#/llvm_targets_}
${SANITIZER_FLAGS[@]}
-mlir profile +runtime cfi
ebuild_revision_21
"
REQUIRED_USE="
	cfi? (
		runtime
	)
"
RDEPEND="
	!sys-devel/llvm-rocm:0
	dev-libs/libxml2
	sys-devel/llvm-roc-symlinks:${ROCM_SLOT}/${PV}
	sys-libs/ncurses:=
	sys-libs/zlib
	virtual/cblas
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_GCC_DEPEND}
"
PATCHES=(
#	"${FILESDIR}/${PN}-4.5.2-fix-linking-for-LLVMAMDGPUDisassembler.patch"
	"${FILESDIR}/${PN}-4.1.0-benchmark-register-include-limits.patch"
)

pkg_setup() {
	dhms_start
	rocm_pkg_setup
}

src_prepare() {
	pushd "${WORKDIR}/llvm-project-rocm-${PV}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/${PN}-4.1.0-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die

	cmake_src_prepare
	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${WORKDIR}/amd/hipcc/bin/hipcc.pl"
		"${WORKDIR}/amd/hipcc/bin/hipvars.pm"
		"${WORKDIR}/amd/hipcc/src/hipBin_base.h"
		"${WORKDIR}/amd/hipcc/src/hipBin_nvidia.h"
		"${WORKDIR}/bolt/CMakeLists.txt"
		"${WORKDIR}/bolt/include/bolt/RuntimeLibs/RuntimeLibrary.h"
		"${WORKDIR}/bolt/lib/RuntimeLibs/HugifyRuntimeLibrary.cpp"
		"${WORKDIR}/bolt/lib/RuntimeLibs/InstrumentationRuntimeLibrary.cpp"
		"${WORKDIR}/bolt/lib/RuntimeLibs/RuntimeLibrary.cpp"
		"${WORKDIR}/bolt/runtime/CMakeLists.txt"
		"${WORKDIR}/clang/lib/Driver/ToolChains/AMDGPU.cpp"
		"${WORKDIR}/clang/lib/Driver/ToolChains/Cuda.cpp"
		"${WORKDIR}/clang/tools/amdgpu-arch/CMakeLists.txt"
		"${WORKDIR}/compiler-rt/CMakeLists.txt"
		"${WORKDIR}/lib/Target/AMDGPU/Disassembler/CMakeLists.txt"
		"${WORKDIR}/libc/cmake/modules/prepare_libc_gpu_build.cmake"
		"${WORKDIR}/libc/src/math/gpu/vendor/CMakeLists.txt"
		"${WORKDIR}/libc/utils/gpu/loader/CMakeLists.txt"
		"${WORKDIR}/llvm/CMakeLists.txt"
		"${WORKDIR}/llvm/tools/llvm-dwarfdump/CMakeLists.txt"
		"${WORKDIR}/llvm/tools/llvm-split/CMakeLists.txt"
		"${WORKDIR}/mlir/lib/Conversion/TosaToLinalg/CMakeLists.txt"
		"${WORKDIR}/mlir/lib/Dialect/GPU/CMakeLists.txt"
		"${WORKDIR}/mlir/lib/ExecutionEngine/CMakeLists.txt"
		"${WORKDIR}/mlir/lib/Target/LLVM/CMakeLists.txt"
		"${WORKDIR}/mlir/lib/Target/LLVMIR/Dialect/NVVM/CMakeLists.txt"
		"${WORKDIR}/mlir/tools/mlir-rocm-runner/CMakeLists.txt"
		"${WORKDIR}/openmp/libomptarget/DeviceRTL/CMakeLists.txt"
		"${WORKDIR}/openmp/libomptarget/deviceRTLs/amdgcn/CMakeLists.txt"
		"${WORKDIR}/openmp/libomptarget/hostexec/CMakeLists.txt"
		"${WORKDIR}/openmp/libomptarget/hostrpc/services/CMakeLists.txt"
		"${WORKDIR}/openmp/libomptarget/plugins-nextgen/amdgpu/CMakeLists.txt"
		"${WORKDIR}/openmp/libomptarget/plugins/amdgpu/CMakeLists.txt"
		"${WORKDIR}/openmp/libomptarget/src/CMakeLists.txt"
		"${WORKDIR}/polly/lib/CodeGen/PPCGCodeGeneration.cpp"
		"${WORKDIR}/utils/benchmark/src/benchmark_register.h"
	)
	rocm_src_prepare
}

_src_configure_compiler() {
	rocm_set_default_gcc
}

src_configure() {
	:
}

_src_configure() {
	addpredict "/dev/nvidiactl"
	addpredict "/proc/self/task/"
	local mycmakeargs=()
	mycmakeargs+=(
		-DCMAKE_C_COMPILER="${CC}"
		-DCMAKE_CXX_COMPILER="${CXX}"
	)
	filter-flags "-fuse-ld=*"

# Avoid:
#collect2: fatal error: cannot find 'ld'
#compilation terminated.
	append-ldflags -fuse-ld=bfd

	# Speed up composable_kernel, rocBLAS build times
	# -O3 may cause random ICE/segfault.
	replace-flags '-O*' '-O2'

	# Reduce systemwide vulnerability backlog
	filter-flags '-flto*'

	# For PGO
	if tc-is-gcc ; then
# error: number of counters in profile data for function '...' does not match its profile data (counter 'arcs', expected 7 and have 13) [-Werror=coverage-mismatch]
# The PGO profiles are isolated.  The Code is the same.
		append-flags -Wno-error=coverage-mismatch
	fi

	strip-unsupported-flags

	mycmakeargs+=(
		-DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS}"
		-DCMAKE_MODULE_LINKER_FLAGS="${LDFLAGS}"
		-DCMAKE_SHARED_LINKER_FLAGS="${LDFLAGS}"
	)

	PROJECTS="llvm;clang;lld"
	if use runtime ; then
		PROJECTS+=";compiler-rt"
	fi
	if use mlir ; then
		PROJECTS+=";mlir"
	fi

	local flag
	local want_sanitizer="OFF"
	for flag in "${SANITIZER_FLAGS[@]}" ; do
		if use "${flag}" ; then
			want_sanitizer="ON"
			break
		fi
	done

	local libdir=$(rocm_get_libdir)
	mycmakeargs+=(
#		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_C_FLAGS="${CFLAGS}"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}/llvm"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}${EROCM_PATH}/share/man"
		-DCOMPILER_RT_BUILD_PROFILE=$(usex profile)
		-DCOMPILER_RT_BUILD_SANITIZERS="${want_sanitizer}"
		-DLLVM_BUILD_DOCS=NO
#		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DLLVM_ENABLE_ASSERTIONS=ON # For mlir
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_PROJECTS="${PROJECTS}"
		-DLLVM_ENABLE_SPHINX=NO
		-DLLVM_ENABLE_ZSTD=OFF # For mlir
		-DLLVM_ENABLE_ZLIB=ON # OFF for mlir, ON for lld+scudo
		-DLLVM_INSTALL_UTILS=ON
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
#		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86"
#		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=NO
	)
	rocm_src_configure
}

_src_compile() {
	# mlir needs LLVMDemangle, LLVMSupport, LLVMTableGen
	cmake_src_compile \
		all \
		LLVMDemangle \
		LLVMSupport \
		LLVMTableGen
}

src_compile() {
	_src_configure_compiler
	_src_configure
	_src_compile
}

_src_install() {
	DESTDIR="${D}" \
	cmake_src_install \
		install-LLVMDemangle \
		install-LLVMSupport \
		install-LLVMTableGen
}

src_install() {
	_src_install
	rm -rf "${ED}/var/tmp"
}

pkg_postinst() {
	dhms_end
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
