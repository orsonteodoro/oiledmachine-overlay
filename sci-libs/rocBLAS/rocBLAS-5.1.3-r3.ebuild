# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_OVERRIDE=(
	gfx803
	gfx900
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1010
	gfx1012
	gfx1030
	 gfx1031 # Unofficial
)
DOCS_BUILDER="doxygen"
DOCS_DIR="docs"
DOCS_DEPEND="
	media-gfx/graphviz
"
LLVM_MAX_SLOT=14 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.1.3/llvm/CMakeLists.txt
PYTHON_COMPAT=( python3_{10..11} )
ROCM_VERSION="${PV}"
inherit cmake docs edo flag-o-matic multiprocessing prefix llvm python-any-r1 rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz
	-> rocm-${P}.tar.gz
	amdgpu_targets_gfx1031? (
https://media.githubusercontent.com/media/littlewu2508/littlewu2508.github.io/main/gentoo-distfiles/${PN}-5.0.2-Tensile-asm_full-navi22.tar.gz
	)
"

DESCRIPTION="AMD's library for BLAS on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test r2"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
DEPEND="
	>=dev-cpp/msgpack-cxx-6.0.0
	~dev-util/hip-${PV}:${SLOT}
	test? (
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		dev-cpp/gtest
		virtual/blas
	)
	benchmark? (
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		virtual/blas
	)
"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/clang:${LLVM_MAX_SLOT}
	~dev-util/rocm-cmake-${PV}:${SLOT}
	~dev-util/Tensile-${PV}:${SLOT}
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/${PN}-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-4.3.0-fix-glibc-2.32-and-above.patch"
	"${FILESDIR}/${PN}-5.0.2-change-default-Tensile-library-dir.patch"
	"${FILESDIR}/${PN}-5.0.2-cpp_lib_filesystem.patch"
	"${FILESDIR}/${PN}-5.0.2-unbundle-Tensile.patch"
)

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	if use amdgpu_targets_gfx1031 ; then
		cp -a \
			"${WORKDIR}/asm_full/" \
			"library/src/blas3/Tensile/Logic/" \
			|| die
	fi
	# Fit for Gentoo FHS rule
	sed \
		-e "/PREFIX rocblas/d" \
		-e "/<INSTALL_INTERFACE/s:include:include/rocblas:" \
		-e "s:rocblas/include:include/rocblas:" \
		-e "s:\\\\\${CPACK_PACKAGING_INSTALL_PREFIX}rocblas/lib:${EPREFIX}/usr/$(get_libdir)/rocblas:" \
		-e "s:share/doc/rocBLAS:share/doc/${P}:" \
		-e "/rocm_install_symlink_subdir( rocblas )/d" \
		-i \
		library/src/CMakeLists.txt \
		|| die

	sed \
		-e "s:,-rpath=.*\":\":" \
		-i \
		clients/CMakeLists.txt \
		|| die

	eprefixify library/src/tensile_host.cpp
}

src_configure() {
	addpredict /dev/random
	addpredict /dev/kfd
	addpredict /dev/dri/

	# Prevent error below for miopen
	# undefined reference to `rocblas_status_ rocblas_internal_check_numerics_matrix_template
	replace-flags '-O0' '-O1'

	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_TESTING=OFF
		-DBUILD_WITH_TENSILE=ON
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocblas"
		-DCMAKE_SKIP_RPATH=On
		-Dpython="${PYTHON}"
		-DTensile_CODE_OBJECT_VERSION="V3"
		-DTensile_COMPILER="hipcc"
		-DTensile_CPU_THREADS=$(makeopts_jobs)
		-DTensile_LIBRARY_FORMAT="msgpack"
		-DTensile_LOGIC="asm_full"
		-DTensile_ROOT="${EPREFIX}/usr/share/Tensile"
		-DTensile_TEST_LOCAL_PATH="${EPREFIX}/usr/share/Tensile"
	)

	CXX="hipcc" \
	cmake_src_configure
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
	edob "${PN,,}-test"
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dolib.so clients/librocblas_fortran_client.so
		dobin clients/staging/rocblas-bench
	fi
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
