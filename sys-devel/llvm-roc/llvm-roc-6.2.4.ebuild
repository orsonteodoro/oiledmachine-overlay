# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="RelWithDebInfo"
LLVM_SLOT=18
LLVM_TARGETS=(
	AMDGPU
	NVPTX
	X86
)
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
SANITIZER_FLAGS=(
	cfi
)

inherit check-compiler-switch cmake dhms flag-o-matic rocm toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}/llvm-project-rocm-${PV}/llvm"
SRC_URI="
https://github.com/RadeonOpenCompute/llvm-project/archive/rocm-${PV}.tar.gz
	-> llvm-project-rocm-${PV}.tar.gz
"

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
	NCSA-AMD
	public-domain
	rc
	SunPro
"
# Apache-2.0 - llvm-project-rocm-5.7.0/third-party/benchmark/LICENSE
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA - llvm-project-rocm-5.7.0/lldb/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions, BSD, MIT - llvm-project-rocm-5.7.0/libclc/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA, MIT, custom - llvm-project-rocm-5.7.0/openmp/LICENSE.TXT
#   Keyword search:  "all right, title, and interest"
# BSD - llvm-project-rocm-5.7.0/third-party/unittest/googlemock/LICENSE.txt
# BSD - llvm-project-rocm-5.7.0/openmp/runtime/src/thirdparty/ittnotify/LICENSE.txt
# CC0-1.0, Apache-2.0 - llvm-project-rocm-5.7.0/llvm/lib/Support/BLAKE3/LICENSE
# ISC - llvm-project-rocm-5.7.0/lldb/third_party/Python/module/pexpect-4.6/LICENSE
# MIT - llvm-project-rocm-5.7.0/polly/lib/External/isl/LICENSE
# NCSA-AMD - rocm-6.1.2/amd/device-libs/ockl/inc/hsa.h
# rc, BSD - llvm-project-rocm-5.7.0/llvm/lib/Support/COPYRIGHT.regex
# SunPro - rocm-6.1.2/amd/device-libs/ocml/src/erfcF.cl
RESTRICT="strip" # Prevent missing symbols
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
${LLVM_TARGETS[@]/#/llvm_targets_}
${SANITIZER_FLAGS[@]}
bolt -mlir profile +runtime
ebuild_revision_26
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
)

pkg_setup() {
	check-compiler-switch_start
	dhms_start
	rocm_pkg_setup
}

src_prepare() {
	pushd "${WORKDIR}/llvm-project-rocm-${PV}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/${PN}-6.2.0-hardcoded-paths.patch"

# FIXES:
# ld.bfd: tools/llvm-split/CMakeFiles/llvm-split.dir/llvm-split.cpp.o: undefined reference to symbol '_ZN4llvm6TripleC1ERKNS_5TwineE'
# ld.bfd: /var/tmp/portage/sys-devel/llvm-roc-6.2.4/work/llvm-project-rocm-6.2.4/llvm_build/./lib/libLLVMTargetParser.so.18git: error adding symbols: DSO missing from command line
# collect2: error: ld returned 1 exit status

		eapply "${FILESDIR}/${PN}-6.2.0-link-llvm-split-to-LLVMTargetParser.patch"
	popd >/dev/null 2>&1 || die

	cmake_src_prepare
	if has bolt ${IUSE_EFFECTIVE} && use bolt ; then
		pushd "${WORKDIR}/llvm-project-rocm-${PV}" >/dev/null 2>&1 || die
			eapply -p1 "${FILESDIR}/llvm-16.0.5-bolt-set-cmake-libdir.patch"
			eapply -p1 "${FILESDIR}/llvm-17.0.0.9999-v3-bolt_rt-RuntimeLibrary.cpp-path.patch"
                popd >/dev/null 2>&1 || die
	fi
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
	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	addpredict "/dev/nvidiactl"
	addpredict "/proc/self/task/"
	local mycmakeargs=()
	mycmakeargs+=(
		-DCMAKE_C_COMPILER="${CC}"
		-DCMAKE_CXX_COMPILER="${CXX}"
	)
	filter-flags "-fuse-ld=*"

# Still present in 6.1.2:
# ld.gold: internal error in do_layout, at /var/tmp/portage/sys-devel/binutils-2.40-r5/work/binutils-2.40/gold/object.cc:1939

# Breaks during configure test: fatal error: cannot find 'ld'
#	append-ldflags -fuse-ld=lld

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
# The error is not a problem for 5.7.0.
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
	if has bolt ${IUSE_EFFECTIVE} && use bolt ; then
		PROJECTS+=";bolt"
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
