# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1010
	gfx1012
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
CPU_FLAGS_X86=(
	cpu_flags_x86_f16c
)
CMAKE_MAKEFILE_GENERATOR="emake"
DOCS_BUILDER="doxygen"
DOCS_DIR="docs"
DOCS_DEPEND="
	media-gfx/graphviz
"
HIP_SUPPORT_CUDA=1
LLVM_SLOT=16 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.5.1/llvm/CMakeLists.txt
PYTHON_COMPAT=( "python3_"{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake docs edo flag-o-matic multiprocessing python-single-r1 rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz
	-> rocm-${P}.tar.gz
"

DESCRIPTION="AMD's library for BLAS on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	BSD
"
# The distro's MIT license template does not have All rights reserved.
RESTRICT="
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
${CPU_FLAGS_X86[@]}
benchmark cuda +rocm test ebuild_revision_21
"
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
	$(gen_rocm_required_use)
	rocm? (
		${ROCM_REQUIRED_USE}
	)
	^^ (
		rocm
		cuda
	)
"
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	>=dev-libs/msgpack-3.0.1
	~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	benchmark? (
		sys-libs/llvm-roc-libomp:${ROCM_SLOT}[${LLVM_ROC_LIBOMP_5_5_AMDGPU_USEDEP}]
		virtual/blas
	)
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	rocm? (
		~dev-util/Tensile-${PV}:${ROCM_SLOT}[${TENSILE_5_5_AMDGPU_USEDEP},rocm]
		$(python_gen_cond_dep '
			~dev-util/Tensile-'"${PV}:${ROCM_SLOT}"'['"${TENSILE_5_5_AMDGPU_USEDEP}"',rocm]
		')
	)
"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/gtest
		sys-libs/llvm-roc-libomp:${ROCM_SLOT}[${LLVM_ROC_LIBOMP_5_5_AMDGPU_USEDEP}]
		virtual/blas
	)
"
BDEPEND="
	${PYTHON_DEPS}
	${HIPCC_DEPEND}
	$(python_gen_cond_dep '
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	rocm? (
		$(python_gen_cond_dep '
			~dev-util/Tensile-'"${PV}:${ROCM_SLOT}"'['"${TENSILE_5_5_AMDGPU_USEDEP}"',${PYTHON_USEDEP},client,rocm]
		')
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.4.2-cpp_lib_filesystem.patch"
	"${FILESDIR}/${PN}-5.4.2-unbundle-Tensile.patch"
	"${FILESDIR}/${PN}-5.4.2-add-missing-header.patch"
	"${FILESDIR}/${PN}-5.4.2-link-cblas.patch"
	"${FILESDIR}/${PN}-5.5.1-hardcoded-paths.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
	rocm_pkg_setup

	QA_FLAGS_IGNORED="${EROCM_PATH}/$(rocm_get_libdir)/rocblas/library/.*"
}

src_prepare() {
	cmake_src_prepare
	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${S}/CMakeLists.txt"
		"${S}/clients/CMakeLists.txt"
		"${S}/clients/common/utility.cpp"
		"${S}/clients/gtest/rocblas_test.cpp"
		"${S}/clients/include/host_alloc.hpp"
		"${S}/clients/include/rocblas_data.hpp"
		"${S}/clients/include/singletons.hpp"
		"${S}/clients/include/testing_logging.hpp"
		"${S}/clients/include/testing_ostream_threadsafety.hpp"
		"${S}/clients/include/utility.hpp"
		"${S}/library/src/tensile_host.cpp"
		"${S}/rmake.py"
		"${S}/toolchain-linux.cmake"
	)
	rocm_src_prepare
	if ! use cpu_flags_x86_f16c ; then
	# Issue 1422
	# Breaks Ollama for CPUs without AVX
		sed -i \
			-e "s|-mf16c|-mno-f16c|g" \
			$(find "${S}" -name "CMakeLists.txt") \
			|| die
	fi
}

src_configure() {
	addpredict "/dev/random"
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"

	# Prevent error below for miopen
	# undefined reference to `rocblas_status_ rocblas_internal_check_numerics_matrix_template
	replace-flags '-O0' '-O1'

	export PATH="${ESYSROOT}/${EROCM_PATH}/lib/python-exec/${EPYTHON}:${ESYSROOT}/${EROCM_PATH}/bin:${PATH}"
	export PYTHONPATH="${ESYSROOT}/${EROCM_PATH}/lib/${EPYTHON}/site-packages:${PYTHONPATH}"

	local mycmakeargs=(
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DBUILD_TESTING=OFF
		-DCMAKE_INSTALL_INCLUDEDIR="include"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_SKIP_RPATH=ON
		-Dpython="${PYTHON}"
		-DROCM_SYMLINK_LIBS=OFF
	)

	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DBUILD_WITH_TENSILE=OFF
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DBUILD_WITH_TENSILE=ON
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DTensile_CODE_OBJECT_VERSION="default"
			-DTensile_COMPILER="hipcc"
			-DTensile_CPU_THREADS=$(makeopts_jobs)
			-DTensile_LIBRARY_FORMAT="msgpack"
			-DTensile_LOGIC="asm_full"
			-DTensile_ROOT="${ESYSROOT}${EROCM_PATH}/lib/${EPYTHON}/site-packages/Tensile"
			-DTensile_TENSILE_ROOT="${ESYSROOT}${EROCM_PATH}"
			-DTensile_TEST_LOCAL_PATH="${ESYSROOT}${EROCM_PATH}/lib/${EPYTHON}/site-packages/Tensile"
		)
	fi
	rocm_set_default_hipcc

# Error with HIP-Clang (llvm-roc):
#1.	<eof> parser at end of file
#2.	Code generation
#3.	Running pass 'CallGraph Pass Manager' on module '/var/tmp/portage/sci-libs/rocBLAS-5.5.1/work/rocBLAS-rocm-5.5.1/library/src/blas_ex/rocblas_geam_ex_kernels.cpp'.
#4.	Running pass 'SI optimize exec mask operations pre-RA' on function '@_ZN12_GLOBAL__N_120geam_min_plus_kernelIf15HIP_vector_typeIfLj2EEfLi8ELi32ELi64ELi256ELi4ELi64ELi4ELi64ELi4ELc78ELc84ELb0ELb0ELb1EPKfKS4_KPfEEviiiT16_PT17_ilSA_ilS8_SA_ilPT18_ili26rocblas_geam_ex_operation_'
# #0 0x00007f3b4a9c84b1 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) (/opt/rocm-5.5.1/llvm/bin/../lib/libLLVMSupport.so.16git+0x1c84b1)
	replace-flags '-O1' '-O2' # Fix for above error
	replace-flags '-O0' '-O2'
	replace-flags '-Os' '-O2'

	rocm_src_configure
}

src_compile() {
	docs_compile
	cmake_src_compile
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	export ROCBLAS_TENSILE_LIBPATH="${BUILD_DIR}/Tensile/library"
	export ROCBLAS_TEST_TIMEOUT=3600
	export LD_LIBRARY_PATH="${BUILD_DIR}/clients:${BUILD_DIR}/library/src"
	edob "./${PN,,}-test"
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dolib.a "clients/librocblas_fortran_client.a"
		dobin "clients/staging/rocblas-bench"
	fi
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
