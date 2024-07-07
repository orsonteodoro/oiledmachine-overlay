# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2021,2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="RelWithDebInfo"
LLVM_SLOT=16
LLVM_TARGETS=(
	AMDGPU
	NVPTX
	X86
)
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
SANITIZER_FLAGS=(
	cfi
)
UOPTS_GROUP="portage"
UOPTS_USER="portage"
UOPTS_SUPPORT_EBOLT=1
UOPTS_SUPPORT_EPGO=1
UOPTS_SUPPORT_TBOLT=0
UOPTS_SUPPORT_TPGO=0

inherit cmake flag-o-matic rocm uopts

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
		ZLIB
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
# Apache-2.0 - llvm-project-rocm-5.6.1/third-party/benchmark/LICENSE
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA - llvm-project-rocm-5.6.1/lldb/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions, BSD, MIT - llvm-project-rocm-5.6.1/libclc/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA, MIT, custom - llvm-project-rocm-5.6.1/openmp/LICENSE.TXT
#   Keyword search:  "all right, title, and interest"
# BSD - llvm-project-rocm-5.6.1/third-party/unittest/googlemock/LICENSE.txt
# BSD - llvm-project-rocm-5.6.1/openmp/runtime/src/thirdparty/ittnotify/LICENSE.txt
# CC0-1.0, Apache-2.0 - llvm-project-rocm-5.6.1/llvm/lib/Support/BLAKE3/LICENSE
# ISC - llvm-project-rocm-5.6.1/lldb/third_party/Python/module/pexpect-4.6/LICENSE
# MIT - llvm-project-rocm-5.6.1/polly/lib/External/isl/LICENSE
# ZLIB, BSD - llvm-project-rocm-5.6.1/llvm/lib/Support/COPYRIGHT.regex
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
${LLVM_TARGETS[@]/#/llvm_targets_}
${SANITIZER_FLAGS[@]}
bolt profile +runtime
ebuild-revision-13
"
REQUIRED_USE="
	cfi? (
		runtime
	)
"
RDEPEND="
	!sys-devel/llvm-rocm:0
	dev-libs/libxml2
	sys-libs/ncurses:=
	sys-libs/zlib
	virtual/cblas
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gcc
"
PATCHES=(
)

pkg_setup() {
ewarn
ewarn "You may need to switch to GCC 12.  If the build fails, do"
ewarn
ewarn "eselect gcc set <CHOST>-12"
ewarn "source /etc/profile"
ewarn
	rocm_pkg_setup
	uopts_setup
	if use epgo || use ebolt ; then
einfo "See comments of metadata.xml for documentation on ebolt/epgo."
		local path="/var/lib/pgo-profiles/${CATEGORY}/${PN}/${ROCM_SLOT}/${MULTILIB_ABI_FLAG}.${ABI}"
		addwrite "${path}"
		mkdir -p "${path}"
		chown -R portage:portage "${path}" || die
	fi
}

src_prepare() {
	cmake_src_prepare
	if use bolt ; then
		pushd "${WORKDIR}/llvm-project-rocm-${PV}" || die
			eapply -p1 "${FILESDIR}/llvm-16.0.5-bolt-set-cmake-libdir.patch"
			eapply -p1 "${FILESDIR}/llvm-16.0.0.9999-bolt_rt-RuntimeLibrary.cpp-path.patch"
		popd
	fi
	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${WORKDIR}/llvm-project-rocm-${PV}/bolt/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/bolt/include/bolt/RuntimeLibs/RuntimeLibrary.h"
		"${WORKDIR}/llvm-project-rocm-${PV}/bolt/lib/RuntimeLibs/HugifyRuntimeLibrary.cpp"
		"${WORKDIR}/llvm-project-rocm-${PV}/bolt/lib/RuntimeLibs/InstrumentationRuntimeLibrary.cpp"
		"${WORKDIR}/llvm-project-rocm-${PV}/bolt/lib/RuntimeLibs/RuntimeLibrary.cpp"
		"${WORKDIR}/llvm-project-rocm-${PV}/bolt/runtime/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/llvm/CMakeLists.txt"
	)
	rocm_src_prepare
	uopts_src_prepare
}

_src_configure_compiler() {
	PGO_TOOLCHAIN="${PGO_TOOLCHAIN:-gcc}"
	if [[ "${PGO_TOOLCHAIN}" == "clang" ]] ; then
		export CC="${EROCM_PATH}/bin/clang"
		export CXX="${EROCM_PATH}/bin/clang++"
	else
		export CC="${CHOST}-gcc"
		export CXX="${CHOST}-g++"
	fi
}

_src_configure() {
	local mycmakeargs=()
	mycmakeargs+=(
		-DCMAKE_C_COMPILER="${CC}"
		-DCMAKE_CXX_COMPILER="${CXX}"
	)
	uopts_src_configure
	filter-flags "-fuse-ld=*"
	#strip-unsupported-flags # Broken, strips -fprofile-use

	# Speed up composable_kernel, rocBLAS build times
	# -O3 may cause random ICE/segfault.
	replace-flags '-O0' '-O2'
	replace-flags '-O1' '-O2'
	replace-flags '-Oz' '-O2'
	replace-flags '-Os' '-O2'
	replace-flags '-Ofast' '-O2'
	replace-flags '-O4' '-O2'

	# For PGO
	if tc-is-gcc ; then
# error: number of counters in profile data for function '...' does not match its profile data (counter 'arcs', expected 7 and have 13) [-Werror=coverage-mismatch]
# The PGO profiles are isolated.  The Code is the same.
		append-flags -Wno-error=coverage-mismatch
	fi

	mycmakeargs+=(
		-DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS}"
		-DCMAKE_MODULE_LINKER_FLAGS="${LDFLAGS}"
		-DCMAKE_SHARED_LINKER_FLAGS="${LDFLAGS}"
	)
	if ( use epgo || use ebolt ) && tc-is-gcc ; then
		local gcc_slot=$(gcc-major-version)
		mycmakeargs+=(
			-DCMAKE_STATIC_LINKER_FLAGS="/usr/lib/gcc/${CHOST}/${gcc_slot}/libgcov.a"
		)
	fi

	PROJECTS="llvm;clang;lld"
	if use runtime ; then
		PROJECTS+=";compiler-rt"
	fi
	if use bolt ; then
		PROJECTS+=";bolt"
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

train_meets_requirements() {
	return 0
}

src_compile() {
	uopts_src_compile
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
	uopts_src_install
	rm -rf "${ED}/var/tmp"
}

pkg_postinst() {
	uopts_pkg_postinst
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO


