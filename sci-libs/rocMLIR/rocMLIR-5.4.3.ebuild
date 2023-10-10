# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
PYTHON_COMPAT=( python3_{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake llvm python-r1 rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocMLIR/"
	inherit git-r3
else
	SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocMLIR/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
fi

DESCRIPTION="MLIR-based convolution and GEMM kernel generator for ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocMLIR"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	MIT
"
# Apache-2.0-with-LLVM-exceptions - mlir/LICENSE.TXT
# all rights reserved with MIT - mlir/tools/rocmlir-lib/LICENSE
# The distro MIT license template does not have all rights reserved
SLOT="${ROCM_SLOT}/${PV}"
IUSE="system-llvm r6"
RDEPEND="
	${PYTHON_DEPS}
	>=dev-db/sqlite-3:3
	>=dev-python/pybind11-2.8[${PYTHON_USEDEP}]
	dev-util/rocm-compiler:${ROCM_SLOT}[system-llvm=]
	media-libs/vulkan-loader
	virtual/libc
	~dev-util/hip-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
	dev-util/vulkan-headers
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.15.1
	dev-util/patchelf
	virtual/pkgconfig
"
RESTRICT="test"
PATCHES=(
	"${FILESDIR}/${PN}-5.4.3-path-changes.patch"
	"${FILESDIR}/${PN}-5.4.3-fix-so-suffix.patch"
)

ccmake() {
einfo "Running:  cmake ${@}"
	cmake "${@}" || die
}

mmake() {
	if [[ "${CMAKE_MAKEFILE_GENERATOR}" == "ninja" ]] ; then
einfo "Running:  ninja $@"
		eninja "$@"
	else
einfo "Running:  emake $@"
		emake "$@"
	fi
}

pkg_setup() {
	python_setup
	rocm_pkg_setup
}

src_prepare() {
ewarn "Patching may take a long time.  Please wait..."
	sed -i -e "s|FATAL_ERROR|WARNING|g" \
		external/llvm-project/llvm/cmake/modules/CheckCompilerVersion.cmake \
		external/llvm-project/llvm/cmake/modules/CheckAtomic.cmake \
		|| die
	sed -i -e "s|LLVM_VERSION_SUFFIX git|LLVM_VERSION_SUFFIX roc|g" \
		external/llvm-project/llvm/CMakeLists.txt \
		|| die
	cmake_src_prepare

        IFS=$'\n'
        sed \
                -i \
                -e "s|/lib64)|/@LIBDIR@)|g" \
                -e "s|BINARY_DIR}/lib/|BINARY_DIR}/@LIBDIR@/|g" \
                -e "s|BINARY_DIR}/lib64/|BINARY_DIR}/@LIBDIR@/|g" \
                -e "s|DESTINATION lib/|DESTINATION @LIBDIR@/|g" \
                -e "s|DESTINATION lib64/|DESTINATION @LIBDIR@/|g" \
		-e "s|INSTALL_PATH}/lib$|INSTALL_PATH}/@LIBDIR@$|g" \
                $(find . \
			\( \
				   -name "CMakeLists.txt" \
				-o -name "*.cmake" \
			\) \
		) \
                || true
        sed \
                -i \
		-e "s|/lib)|/@LIBDIR@)|g" \
                $(find . \
			\( \
				\( \
					   -name "CMakeLists.txt" \
					-o -name "*.cmake" \
				\) \
				-a -not -path "*/external/llvm-project/clang-tools-extra/include-cleaner/unittests/CMakeLists.txt" \
			\) \
		) \
                || true
        IFS=$' \t\n'

	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${S}/CMakeLists.txt"
		"${S}/cmake/llvm-project.cmake"
		"${S}/external/llvm-project/clang/lib/Driver/ToolChains/AMDGPU.cpp"
		"${S}/external/llvm-project/clang/tools/amdgpu-arch/CMakeLists.txt"
		"${S}/external/llvm-project/libc/cmake/modules/prepare_libc_gpu_build.cmake"
		"${S}/external/llvm-project/mlir/lib/Dialect/GPU/CMakeLists.txt"
		"${S}/external/llvm-project/mlir/lib/ExecutionEngine/CMakeLists.txt"
		"${S}/external/llvm-project/openmp/libomptarget/plugins/amdgpu/CMakeLists.txt"
		"${S}/external/llvm-project/openmp/libomptarget/plugins-nextgen/amdgpu/CMakeLists.txt"
		"${S}/mlir/CMakeLists.txt"
		"${S}/mlir/lib/Dialect/MIOpen/CMakeLists.txt"
		"${S}/mlir/lib/Dialect/MIOpen/Tuning/CMakeLists.txt"
		"${S}/mlir/lib/Dialect/MIOpen/Tuning/SqliteDb.cpp"
		"${S}/mlir/lib/Dialect/Rock/Tuning/CMakeLists.txt"
		"${S}/mlir/lib/Dialect/Rock/Tuning/SqliteDb.cpp"
		"${S}/mlir/lib/ExecutionEngine/ROCm/CMakeLists.txt"
		"${S}/mlir/tools/mlir-rocm-runner/CMakeLists.txt"
		"${S}/mlir/tools/rocmlir-lib/CMakeLists.txt"
		"${S}/mlir/tools/rocmlir-tuning-driver/CMakeLists.txt"
		"${S}/mlir/utils/performance/ck-benchmark-driver/CMakeLists.txt"
		"${S}/mlir/utils/performance/common/CMakeLists.txt"
		"${S}/mlir/utils/performance/parameterSweeps.py"
		"${S}/mlir/utils/performance/perfRunner.py"
		"${S}/mlir/utils/performance/rocblas-benchmark-driver/CMakeLists.txt"
		"${S}/mlir/utils/widgets/tune_MLIR_kernels.sh"
	)
	rocm_src_prepare
}

# DO NOT REMOVE/CHANGE
src_configure() { :; }

build_rocmlir() {
	export HIP_PLATFORM="amd"
	SOURCE_DIR="${S}"
	cd "${S}" || die
	mkdir -p "build_rocMLIR" || die
	cd "build_rocMLIR" || die
	declare -A _cmake_generator=(
		["emake"]="Unix Makefiles"
	        ["ninja"]="Ninja"
	)
	local libdir_suffix=$(get_libdir)
	libdir_suffix="${libdir_suffix/lib}"
	local mycmakeargs=(
		-G "${_cmake_generator[${CMAKE_MAKEFILE_GENERATOR}]}"
		-DBUILD_FAT_LIBROCKCOMPILER=ON # DO NOT CHANGE.  Static produces rocMLIR folder while shared does not.

		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_ROOT_DIR="${ESYSROOT}/${EROCM_PATH}"
		-DHIP_RUNTIME="rocclr"

		# From additional settings in HEAD
		-DLLVM_ENABLE_ZLIB=OFF
		-DLLVM_ENABLE_ZSTD=OFF

		-DMLIR_INCLUDE_TESTS=OFF
		-DCMAKE_INSTALL_PREFIX="${staging_prefix}/${EPREFIX}/${EROCM_PATH}"

		-DROCMLIR_DRIVER_ENABLED=OFF
		-DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF

		-DELLVM_VERSION_SUFFIX=roc
		# -DMLIR_MAIN_INCLUDE_DIR="${ESYSROOT}/opt/rocm-${PV}/llvm/include" # Originally this
		-DMLIR_MAIN_INCLUDE_DIR="${ESYSROOT}/${EROCM_LLVM_PATH}/llvm/include"
		-DLLVM_LIBDIR_SUFFIX="${libdir_suffix}"

		-DCMAKE_THREAD_LIBS_INIT="-lpthread"
		-DCMAKE_HAVE_THREADS_LIBRARY=1
		-DCMAKE_USE_PTHREADS_INIT=1
		-DCMAKE_USE_WIN32_THREADS_INIT=0
		-DTHREADS_PREFER_PTHREAD_FLAG=ON

		-DHAVE_SYSEXITS_H=1
	)

	if use system-llvm ; then
		export CC="${HIP_CC:-${CHOST}-clang-${LLVM_MAX_SLOT}}"
		export CXX="${HIP_CXX:-${CHOST}-clang++-${LLVM_MAX_SLOT}}"
	else
		export CC="${HIP_CC:-clang}"
		export CXX="${HIP_CXX:-clang++}"
	fi
	ccmake \
		"${mycmakeargs[@]}" \
		..
	mmake
	mmake install
}

src_compile() {
	local staging_prefix="${PWD}/install"
	build_rocmlir
}

sanitize_permissions() {
	IFS=$'\n'
	local path
	for path in $(find "${ED}") ; do
		chown root:root "${path}" || die
		if file "${path}" | grep -q "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q "ELF .* LSB shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q "ELF .* LSB pie executable" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q "symbolic link" ; then
			:;
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

src_install() {
	local staging_prefix="${PWD}/install"
	mv \
		"${staging_prefix}/"* \
		"${ED}" \
		|| die
	sanitize_permissions
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
# works
