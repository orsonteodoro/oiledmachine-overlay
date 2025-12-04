# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# GH timestamp for tagged release in "Aug 11, 2025 7:47 AM PDT" format
TAG_TIMESTAMP="Sep 26, 2025 8:42 AM PDT"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_ROCM_7_0[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CMAKE_BUILD_TYPE="RelWithDebInfo" # RelWithDebInfo assumes no assertions.  RelWithDebInfo is the default if unset.
CXX_STANDARD=17 # clang (17), llvm (17), compiler-rt-sanitizers (17), mlir (17), lld (17)
LLVM_SLOT=19
LLVM_TARGETS=(
	"AMDGPU"
	"NVPTX"
	"X86"
)
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
SANITIZER_FLAGS=(
	"asan"
	"cfi"
)

inherit check-compiler-switch cmake dhms flag-o-matic libcxx-slot libstdcxx-slot rocm toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}/llvm-project-rocm-${PV}/llvm"
S_AMDLLVM="${WORKDIR}/llvm-project-rocm-${PV}/clang/tools/amdllvm"
S_LLVM="${WORKDIR}/llvm-project-rocm-${PV}/llvm"
S_ROOT="${WORKDIR}/llvm-project-rocm-${PV}"
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
SLOT="0/${ROCM_SLOT}"
IUSE="
${LLVM_TARGETS[@]/#/llvm_targets_}
${SANITIZER_FLAGS[@]}
bolt flang -mlir profile
ebuild_revision_43
"
REQUIRED_USE="
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
"
RDEPEND="
	dev-libs/libxml2
	sys-devel/llvm-roc-symlinks:${SLOT}
	sys-devel/llvm-roc-symlinks:=
	sys-libs/ncurses:=
	sys-libs/zlib
	virtual/cblas
	asan? (
		dev-libs/rocm-comgr:${SLOT}
		dev-libs/rocr-runtime:${SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
gen_clang_bdepend() {
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/llvm:${s}[${LIBSTDCXX_USEDEP},llvm_targets_X86]
				llvm-core/llvm:=
				llvm-core/clang:${s}[${LIBSTDCXX_USEDEP},llvm_targets_X86]
				llvm-core/clang:=
				llvm-core/lld:${s}[${LIBSTDCXX_USEDEP},llvm_targets_X86]
				llvm-core/lld:=
			)
		"
	done
}
BDEPEND="
	$(gen_clang_bdepend)
"
#	${ROCM_GCC_DEPEND}
PATCHES=(
)

pkg_setup() {
	check-compiler-switch_start
	dhms_start
	rocm_pkg_setup

	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		if use "llvm_slot_${s}" ; then
			LLVM_SLOT="${s}"
			break
		fi
	done

einfo "PATH:  ${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| sed -E -e "/opt\/rocm/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin|g")
einfo "PATH:  ${PATH} (after)"

	# Upstream uses system Clang 13 to start bootstrap.
	export CC="${CHOST}-clang-${LLVM_SLOT}"
	export CXX="${CHOST}-clang++-${LLVM_SLOT}"
	export CPP="${CC} -E"
	filter-flags "-fuse-ld=*"
	append-ldflags "-fuse-ld=lld"
	strip-unsupported-flags

	"${CC}" --version || die

	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	pushd "${S_ROOT}" >/dev/null 2>&1 || die
# FIXES:
# ld.bfd: tools/llvm-split/CMakeFiles/llvm-split.dir/llvm-split.cpp.o: undefined reference to symbol '_ZN4llvm6TripleC1ERKNS_5TwineE'
# ld.bfd: /var/tmp/portage/sys-devel/llvm-roc-6.2.4/work/llvm-project-rocm-6.2.4/llvm_build/./lib/libLLVMTargetParser.so.18git: error adding symbols: DSO missing from command line
# collect2: error: ld returned 1 exit status
		eapply "${FILESDIR}/${PN}-6.2.0-link-llvm-split-to-LLVMTargetParser.patch"

		eapply "${FILESDIR}/${PN}-6.4.4-cuda-path.patch"
	popd >/dev/null 2>&1 || die

	cd "${S_LLVM}" || die
	export CMAKE_USE_DIR="${S_LLVM}"
	export BUILD_DIR="${S_LLVM}_build"
	S="${CMAKE_USE_DIR}"
	cmake_src_prepare

	if has "bolt" ${IUSE_EFFECTIVE} && use bolt ; then
		pushd "${WORKDIR}/llvm-project-rocm-${PV}" >/dev/null 2>&1 || die
			eapply -p1 "${FILESDIR}/llvm-16.0.5-bolt-set-cmake-libdir.patch"
			eapply -p1 "${FILESDIR}/llvm-17.0.0.9999-v3-bolt_rt-RuntimeLibrary.cpp-path.patch"
                popd >/dev/null 2>&1 || die
	fi
	rocm_src_prepare
}

_src_configure_compiler() {
	rocm_set_default_gcc
}

src_configure() {
	:
}

enable_sanitizer() {
	local flag
	for flag in "${SANITIZER_FLAGS[@]}" ; do
		if use "${flag}" ; then
			echo "ON"
			return
		fi
	done
	echo "OFF"
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

	# Speed up composable_kernel, rocBLAS build times
	# -O3 may cause random ICE/segfault.
	replace-flags "-O*" "-O2"

	# Reduce systemwide vulnerability backlog
	filter-flags "-flto*"

	# For PGO
	if tc-is-gcc ; then
# The error is not a problem for 5.7.0.
# error: number of counters in profile data for function '...' does not match its profile data (counter 'arcs', expected 7 and have 13) [-Werror=coverage-mismatch]
# The PGO profiles are isolated.  The Code is the same.
		append-flags "-Wno-error=coverage-mismatch"
	fi

	strip-unsupported-flags

	local projects="clang;lld;clang-tools-extra;lld"
	use bolt && projects+=";bolt"
	use mlir && projects+=";mlir"

	local runtimes="compiler-rt;libunwind;libcxx;libcxxabi"

	local repo_uri="https://github.com/RadeonOpenCompute/llvm-project"
	local tag="roc-${PV}"
	local gitdate=$(date --date="${TAG_TIMESTAMP}" --utc "+%y%U%w")
	local repo_string="${repo_uri} ${tag} ${gitdate}"

	local libdir=$(rocm_get_libdir)
	local build_sanitizer=$(enable_sanitizer)

	local mycmakeargs=()

	mycmakeargs+=(
#		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_C_COMPILER="${CC}"
		-DCMAKE_CXX_COMPILER="${CXX}"
		-DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS}"
		-DCMAKE_MODULE_LINKER_FLAGS="${LDFLAGS}"
		-DCMAKE_SHARED_LINKER_FLAGS="${LDFLAGS}"
		-DCLANG_DEFAULT_LINKER="lld"
		-DCLANG_DEFAULT_RTLIB="compiler-rt"
		-DCLANG_DEFAULT_UNWINDLIB="libgcc"
		-DCLANG_ENABLE_AMDCLANG=ON
		-DCLANG_REPOSITORY_STRING="${repo_string}"
		-DCMAKE_C_FLAGS="${CFLAGS}"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
		-DCMAKE_EXE_LINKER_FLAGS="-Wl,--enable-new-dtags,--build-id=sha1,--rpath,\$ORIGIN/../lib:\$ORIGIN/../../../lib"
		-DCMAKE_SHARED_LINKER_FLAGS="-Wl,--enable-new-dtags,--build-id=sha1,--rpath,\$ORIGIN"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}/lib/llvm"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}${EROCM_PATH}/share/man"
		-DCOMPILER_RT_BUILD_PROFILE=$(usex profile)
		-DCOMPILER_RT_BUILD_SANITIZERS="${build_sanitizer}"
		-DLIBCXX_ENABLE_SHARED=OFF
		-DLIBCXX_ENABLE_STATIC=ON
		-DLIBCXX_INSTALL_LIBRARY=OFF
		-DLIBCXX_INSTALL_HEADERS=OFF
		-DLIBCXXABI_ENABLE_SHARED=OFF
		-DLIBCXXABI_ENABLE_STATIC=ON
		-DLIBCXXABI_INSTALL_STATIC_LIBRARY=OFF
		-DLLVM_BUILD_DOCS=NO
#		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DLLVM_ENABLE_ASSERTIONS=ON					# For mlir
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_PROJECTS="${projects}"
		-DLLVM_ENABLE_RUNTIMES="${runtimes}"
		-DLLVM_ENABLE_SPHINX=NO
		-DLLVM_ENABLE_UNWIND_TABLES=ON
		-DLLVM_ENABLE_ZSTD=OFF						# For mlir
		-DLLVM_ENABLE_ZLIB=ON						# OFF for mlir, ON for lld+scudo
		-DLLVM_EXTERNAL_PROJECTS="amdllvm"
		-DLLVM_INSTALL_UTILS=ON
		-DLLVM_LIBDIR_SUFFIX="${libdir#lib}"
#		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86"
#		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=NO
		-DPACKAGE_VENDOR="AMD"						# Required for hipBLASLt's `hipcc --version` check and to reduce patching.  hipBLASLt issue #2060
		-DSANITIZER_AMDGPU=$(usex asan)
	)

	if [[ "${CMAKE_BUILD_TYPE}" == "Debug" ]] ; then
		mycmakeargs+=(
			-DLIBCXXABI_USE_LLVM_UNWINDER=ON
			-DLIBUNWIND_ENABLE_SHARED=ON # This default ON causes the error.
			-DLIBUNWIND_ENABLE_ASSERTIONS=ON
		)
	else
# Avoid check:
#CMake Error at /var/tmp/portage/sys-devel/llvm-roc-6.4.4/work/llvm-project-rocm-6.4.4/libunwind/src/CMakeLists.txt:102 (message):
#  Compiler doesn't support generation of unwind tables if exception support
#  is disabled.  Building libunwind DSO with runtime dependency on C++ ABI
#  library is not supported.
		mycmakeargs+=(
			-DLIBCXXABI_USE_LLVM_UNWINDER=OFF
			-DLIBUNWIND_ENABLE_SHARED=OFF
			-DLIBUNWIND_ENABLE_ASSERTIONS=OFF
		)
	fi

	if use flang ; then
		mycmakeargs+=(
			-DCLANG_LINK_FLANG_LEGACY=ON
			-DFLANG_INCLUDE_DOCS=OFF
			-DFLANG_RUNTIME_F128_MATH_LIB="libquadmath"
		)
	fi

	cd "${S_LLVM}" || die
	export CMAKE_USE_DIR="${S_LLVM}"
	export BUILD_DIR="${S_LLVM}_build"
	S="${CMAKE_USE_DIR}"
	rocm_src_configure
}

_src_compile() {
	cd "${S_LLVM}_build" || die
	export CMAKE_USE_DIR="${S_LLVM}"
	export BUILD_DIR="${S_LLVM}_build"
	S="${CMAKE_USE_DIR}"
	# mlir needs LLVMDemangle, LLVMSupport, LLVMTableGen

	# The bootstrapping is not necessary.
	# The distro ebuild does not bootstrap system clang for their ROCm flavor.

	# The boostrap process is 3 steps:
	# 1. Build generation 0 compiler (G0) with basic standards or features.
	# 2. Build generation 1 compiler (G1) with next standards or features using earlier generation 0 compiler (G0).
	# 3. Build generation 2 compiler (G2) with newer standards or features needed from generation 1 compiler (G1).

	# If the compiler G2 and compiler G1 are the same, then only verification is done from transistion 2 to 3 before adding to a live system.
	# More steps can be added or merged depending on the boostrap planning.

	# See also https://github.com/ROCm/ROCm/blob/rocm-7.0.2/tools/rocm-build/build_lightning.sh#L429

	# The boostrapping is being used fix amdclang dependency (libc++).
einfo "Bootstrapping HIP-Clang basic build"
	cmake_src_compile \
		"clang" \
		"lld" \
		"compiler-rt"

	cmake_src_compile \
		"runtimes" \
		"cxx"

einfo "Bootstrapping HIP-Clang full build"
	cmake_src_compile

einfo "Building HIP-Clang extras"
	cmake_src_compile \
		"clang-tidy"

	cmake_src_compile \
		"LLVMDemangle" \
		"LLVMSupport" \
		"LLVMTableGen"

#	cmake_src_compile \
#		"all" \
#		"LLVMDemangle" \
#		"LLVMSupport" \
#		"LLVMTableGen"
}

src_compile() {
	_src_configure_compiler
	_src_configure
	_src_compile
}

_src_install() {
	cd "${S_LLVM}_build" || die
	export CMAKE_USE_DIR="${S_LLVM}"
	export BUILD_DIR="${S_LLVM}_build"
	S="${CMAKE_USE_DIR}"
	DESTDIR="${D}" \
	cmake_src_install \
		"install-LLVMDemangle" \
		"install-LLVMSupport" \
		"install-LLVMTableGen"
}

gen_config() {
cat <<EOF > "${ED}/opt/rocm/lib/llvm/bin/rocm.cfg" || die
-Wl,--enable-new-dtags
--rocm-path='<CFGDIR>/../../..'
-frtlib-add-rpath
EOF
	local L=(
		"clang"
		"clang++"
		"clang-cpp"
		"clang-${LLVM_SLOT}"
		"clang-cl"
		"flang"
		"flang-new"
		"flang-classic"
	)
	local x
	for x in "${L[@]}" ; do
		cat \
			"${ED}/opt/rocm/lib/llvm/bin/rocm.cfg" \
				> \
			"${ED}/opt/rocm/lib/llvm/bin/${x}.cfg" \
			|| die
	done
}

src_install() {
	_src_install
	rm -rf "${ED}/var/tmp"
	gen_config
}

pkg_postinst() {
	dhms_end
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
