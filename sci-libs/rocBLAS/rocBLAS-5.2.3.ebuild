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
)
CMAKE_MAKEFILE_GENERATOR="emake"
DOCS_BUILDER="doxygen"
DOCS_DIR="docs"
DOCS_DEPEND="
	media-gfx/graphviz
"
HIP_SUPPORT_CUDA=1
LLVM_SLOT=14 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.2.3/llvm/CMakeLists.txt
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
	BSD
	MIT
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
benchmark cuda +rocm test ebuild-revision-19
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
		sys-libs/llvm-roc-libomp:${ROCM_SLOT}[${LLVM_ROC_LIBOMP_5_2_AMDGPU_USEDEP}]
		virtual/blas
	)
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	rocm? (
		~dev-util/Tensile-${PV}:${ROCM_SLOT}[${TENSILE_5_2_AMDGPU_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/gtest
		sys-libs/llvm-roc-libomp:${ROCM_SLOT}[${LLVM_ROC_LIBOMP_5_2_AMDGPU_USEDEP}]
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
			~dev-util/Tensile-'"${PV}:${ROCM_SLOT}"'['"${TENSILE_5_2_AMDGPU_USEDEP}"',${PYTHON_USEDEP},client]
		')
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.4.2-cpp_lib_filesystem.patch"
	"${FILESDIR}/${PN}-5.4.2-unbundle-Tensile.patch"
	"${FILESDIR}/${PN}-5.4.2-add-missing-header.patch"
	"${FILESDIR}/${PN}-5.4.2-link-cblas.patch"
	"${FILESDIR}/${PN}-5.3.3-include-virtualenv.patch"
	"${FILESDIR}/${PN}-5.2.3-hardcoded-paths.patch"
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
		-DCMAKE_INSTALL_INCLUDEDIR="include"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_SKIP_RPATH=ON
		-Dpython="${PYTHON}"
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
			-DTensile_CODE_OBJECT_VERSION="V3"
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
		if [[ -e "clients/librocblas_fortran_client.so" ]] ; then
			dolib.so "clients/librocblas_fortran_client.so"
		else
			dolib.a "clients/librocblas_fortran_client.a"
		fi
		dobin "clients/staging/rocblas-bench"
	fi
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
