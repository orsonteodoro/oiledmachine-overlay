# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
UOPTS_SUPPORT_TBOLT=0
UOPTS_SUPPORT_TPGO=0

inherit cmake flag-o-matic rocm uopts

SRC_URI="
https://github.com/RadeonOpenCompute/llvm-project/archive/rocm-${PV}.tar.gz
	-> llvm-project-rocm-${PV}.tar.gz
	bolt? (
		https://github.com/llvm/llvm-project/commit/9029ed2e4b2fda3b4c138eefeed686234e163495.patch
			-> llvm-commit-9029ed2.patch
		https://github.com/llvm/llvm-project/commit/61cff9079c083fdcfb9fa324e50b9e480165037e.patch
			-> llvm-commit-61cff90.patch
		https://github.com/llvm/llvm-project/commit/90dcdc4b6e7d86cb3d5049bd766aecddd549dd7d.patch
			-> llvm-commit-90dcdc4.patch
	)
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
# ZLIB, BSD - llvm-project-rocm-5.6.0/llvm/lib/Support/COPYRIGHT.regex
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
LLVM_TARGETS=(
	AMDGPU
	NVPTX
	X86
)
IUSE="
${LLVM_TARGETS[@]/#/llvm_targets_}
bolt pgo +runtime
r10
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
	bolt? (
		dev-util/patchutils
	)
"
PATCHES=(
)
S="${WORKDIR}/llvm-project-rocm-${PV}/llvm"
CMAKE_BUILD_TYPE="RelWithDebInfo"

pkg_setup() {
	rocm_pkg_setup
	uopts_setup
	if use epgo || use ebolt ; then
einfo "See comments of metadata.xml for documentation on ebolt/epgo."
	fi
}

src_prepare() {
	cmake_src_prepare
	pushd "${WORKDIR}/llvm-project-rocm-${PV}" || die
		eapply "${FILESDIR}/llvm-roc-5.3.3-path-changes.patch"
	popd
	if use bolt ; then
		pushd "${WORKDIR}/llvm-project-rocm-${PV}" || die
			eapply -p1 "${FILESDIR}/llvm-14.0.6-bolt-set-cmake-libdir.patch"
			eapply -p1 "${FILESDIR}/llvm-14.0.6-bolt_rt-RuntimeLibrary.cpp-path.patch"
			eapply -p1 "${FILESDIR}/llvm-commit-90dcdc4-v2.patch"
			eapply -p1 "${DISTDIR}/llvm-commit-9029ed2.patch"
			filterdiff \
				-x "*/bat-dump/*" \
				-x "*/bolt/unittests/Profile/CMakeLists.txt" \
				$(realpath "${DISTDIR}/llvm-commit-61cff90.patch") \
				> "${T}/llvm-commit-61cff90.patch" || die
			eapply -p1 "${T}/llvm-commit-61cff90.patch"
		popd
	fi
	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${WORKDIR}/llvm-project-rocm-${PV}/clang/lib/Driver/ToolChains/AMDGPU.cpp"
		"${WORKDIR}/llvm-project-rocm-${PV}/clang/lib/Driver/ToolChains/AMDGPUOpenMP.cpp"
		"${WORKDIR}/llvm-project-rocm-${PV}/clang/tools/amdgpu-arch/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/compiler-rt/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/compiler-rt/test/asan/lit.cfg.py"
		"${WORKDIR}/llvm-project-rocm-${PV}/libc/cmake/modules/prepare_libc_gpu_build.cmake"
		"${WORKDIR}/llvm-project-rocm-${PV}/libc/utils/gpu/loader/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/mlir/lib/Dialect/GPU/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/mlir/lib/Dialect/GPU/Transforms/SerializeToHsaco.cpp"
		"${WORKDIR}/llvm-project-rocm-${PV}/mlir/lib/ExecutionEngine/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/openmp/libomptarget/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/openmp/libomptarget/DeviceRTL/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/openmp/libomptarget/deviceRTLs/amdgcn/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/openmp/libomptarget/deviceRTLs/libm/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/openmp/libomptarget/hostexec/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/openmp/libomptarget/hostexec/CMakeLists.txt.with400files"
		"${WORKDIR}/llvm-project-rocm-${PV}/openmp/libomptarget/hostrpc/services/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/openmp/libomptarget/libm/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/openmp/libomptarget/plugins/amdgpu/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/openmp/libomptarget/plugins/amdgpu/rtl_test/buildrun.sh"
		"${WORKDIR}/llvm-project-rocm-${PV}/openmp/libomptarget/plugins-nextgen/amdgpu/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/openmp/libomptarget/src/CMakeLists.txt"
	)
	rocm_src_prepare
	uopts_src_prepare
}

_src_configure() {
	local mycmakeargs=()
	PGO_TOOLCHAIN="${PGO_TOOLCHAIN:-gcc}"
	if [[ "${PGO_TOOLCHAIN}" == "clang" ]] ; then
		export CC="${EROCM_PATH}/bin/clang"
		export CXX="${EROCM_PATH}/bin/clang++"
	else
		export CC="${CHOST}-gcc"
		export CXX="${CHOST}-g++"
	fi
	mycmakeargs+=(
		-DCMAKE_C_COMPILER="${CC}"
		-DCMAKE_CXX_COMPILER="${CXX}"
	)
	uopts_src_configure
	filter-flags "-fuse-ld=*"
	strip-unsupported-flags

	# Speed up composable_kernel, rocBLAS build times
	# -O3 may cause random ICE/segfault.
	replace-flags '-O0' '-O2'
	replace-flags '-O1' '-O2'
	replace-flags '-Oz' '-O2'
	replace-flags '-Os' '-O2'
	replace-flags '-Ofast' '-O2'

	mycmakeargs+=(
		-DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS}"
		-DCMAKE_MODULE_LINKER_FLAGS="${LDFLAGS}"
		-DCMAKE_SHARED_LINKER_FLAGS="${LDFLAGS}"
	)

	PROJECTS="llvm;clang;lld"
	if use runtime ; then
		PROJECTS+=";compiler-rt"
	fi
	if use bolt ; then
		PROJECTS+=";bolt"
	fi
	local libdir=$(get_libdir)
	mycmakeargs+=(
#		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_C_FLAGS="${CFLAGS}"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}/llvm"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}${EROCM_PATH}/share/man"
		-DLLVM_BUILD_DOCS=NO
#		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DLLVM_ENABLE_ASSERTIONS=ON # For mlir
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_PROJECTS="${PROJECTS}"
		-DLLVM_ENABLE_SPHINX=NO
		-DLLVM_ENABLE_ZSTD=OFF # For mlir
		-DLLVM_ENABLE_ZLIB=OFF # For mlir
		-DLLVM_INSTALL_UTILS=ON
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
#		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86"
#		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=NO
	)
	cmake_src_configure
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
}

pkg_postinst() {
	uopts_pkg_postinst
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
