# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
UOPTS_SUPPORT_TBOLT=0
UOPTS_SUPPORT_TPGO=0

inherit cmake flag-o-matic rocm uopts

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
pgo +runtime
r9
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
S="${WORKDIR}/llvm-project-rocm-${PV}/llvm"
CMAKE_BUILD_TYPE="RelWithDebInfo"

pkg_setup() {
	rocm_pkg_setup
	uopts_setup
}

src_prepare() {
	cmake_src_prepare
	pushd "${WORKDIR}/llvm-project-rocm-${PV}" || die
		eapply "${FILESDIR}/llvm-roc-5.2.3-path-changes.patch"
	popd
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
	replace-flags '-O0' '-O3'
	replace-flags '-O1' '-O3'
	replace-flags '-Oz' '-O3'
	replace-flags '-Os' '-O3'
	replace-flags '-Ofast' '-O3'

	mycmakeargs+=(
		-DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS}"
		-DCMAKE_MODULE_LINKER_FLAGS="${LDFLAGS}"
		-DCMAKE_SHARED_LINKER_FLAGS="${LDFLAGS}"
	)

	PROJECTS="llvm;clang;lld"
	if use runtime ; then
		PROJECTS+=";compiler-rt"
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

_src_train() {
# Train emerge compile to try to improve build times of similar packages.
einfo "Entering PGT phase (2/3)"
	export LD_LIBRARY_PATH="${ED}/${EROCM_LLVM_PATH}/$(get_libdir):${ED}/${EROCM_CLANG_PATH}/lib/linux:${LD_LIBRARY_PATH}"
	export LLVM_ROC_ED="${ED}"
	filter-flags \
		'-fprofile-correction' \
		'-fprofile-dir=*' \
		'-fprofile-generate' \
		'-fprofile-use'
	LLVM_ROC_TRAINERS=${LLVM_ROC_TRAINERS:-"rocPRIM rocRAND rocSPARSE"}
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/composable_kernel" && "${LLVM_ROC_TRAINERS}" =~ "composable_kernel" && -n "${COMPOSABLE_KERNEL_TRAINING_USE}" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/composable_kernel" || die
cat <<EOF > "${T}/run.sh"
#!/bin/bash
export LLVM_ROC_PGO_TRAINING="1"
USE="${COMPOSABLE_KERNEL_TRAINING_USE}" ebuild composable_kernel-${PV}*.ebuild clean unpack prepare compile
EOF
			chmod +x "${T}/run.sh"
			"${T}/run.sh"
		popd || die
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocBLAS" && "${LLVM_ROC_TRAINERS}" =~ "rocBLAS" && -n "${ROCBLAS_TRAINING_USE}" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocBLAS" || die
cat <<EOF > "${T}/run.sh"
export LLVM_ROC_PGO_TRAINING="1"
USE="${ROCBLAS_TRAINING_USE}" ebuild rocBLAS-${PV}*.ebuild clean unpack prepare compile
EOF
			chmod +x "${T}/run.sh"
			"${T}/run.sh"
		popd || die
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocMLIR" && "${LLVM_ROC_TRAINERS}" =~ "rocMLIR" && -n "${ROCMLIR_TRAINING_USE}" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocMLIR" || die
cat <<EOF > "${T}/run.sh"
export LLVM_ROC_PGO_TRAINING="1"
USE="${ROCMLIR_TRAINING_USE}" ebuild rocMLIR-${PV}*.ebuild clean unpack prepare compile
EOF
			chmod +x "${T}/run.sh"
			"${T}/run.sh"
		popd || die
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocPRIM" && "${LLVM_ROC_TRAINERS}" =~ "rocPRIM" && -n "${ROCPRIM_TRAINING_USE}" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocPRIM" || die
cat <<EOF > "${T}/run.sh"
export LLVM_ROC_PGO_TRAINING="1"
USE="${ROCPRIM_TRAINING_USE}" ebuild rocPRIM-${PV}*.ebuild clean unpack prepare compile
EOF
			chmod +x "${T}/run.sh"
			"${T}/run.sh"
		popd || die
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocRAND" && "${LLVM_ROC_TRAINERS}" =~ "rocRAND" && -n "${ROCRAND_TRAINING_USE}" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocRAND" || die
cat <<EOF > "${T}/run.sh"
export LLVM_ROC_PGO_TRAINING="1"
USE="${ROCRAND_TRAINING_USE}" ebuild rocRAND-${PV}*.ebuild clean unpack prepare compile
EOF
			chmod +x "${T}/run.sh"
			"${T}/run.sh"
		popd || die
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocSPARSE" && "${LLVM_ROC_TRAINERS}" =~ "rocSPARSE" && -n "${ROCSPARSE_TRAINING_USE}" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocSPARSE" || die
cat <<EOF > "${T}/run.sh"
export LLVM_ROC_PGO_TRAINING="1"
USE="${ROCSPARSE_TRAINING_USE}" ebuild rocSPARSE-${PV}*.ebuild clean unpack prepare compile
EOF
			chmod +x "${T}/run.sh"
			"${T}/run.sh"
		popd || die
	fi
}

is_pgo_ready() {
	local pgo_ready=0
	if [[ -z "${ROCM_OVERLAY_DIR}" ]] ; then
eerror
eerror "You must define ROCM_OVERLAY_DIR to point to the root absolute path"
eerror "containing sci-libs/composable_kernel."
eerror
		pgo_ready=1
	fi
	if [[ ! -e "${ROCM_OVERLAY_DIR}/sci-libs" ]] ; then
eerror "Path to \${ROCM_OVERLAY_DIR}/sci-libs was not found"
		pgo_ready=1
	fi
	if (( "${pgo_ready}" == 1 )) ; then
ewarn "Prereqs not met.  Skipping pgo."
	fi
	return ${pgo_ready}
}

has_pgo_profile() {
	if [[ "${RESTART_PGO}" == "1" ]] ; then
		return 1
	fi
	if [[ -e "/var/lib/pgo-profiles/${CATEGORY}/${PN}/${ROCM_SLOT}" ]] ; then
		cp -aT \
			"/var/lib/pgo-profiles/${CATEGORY}/${PN}/${ROCM_SLOT}" \
			"${T}/pgo-profile" \
			|| die
		return 0
	fi
	return 1
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
	uopts_pkg_postinst
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
