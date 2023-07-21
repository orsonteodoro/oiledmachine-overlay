# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_OVERRIDE=(
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1010
	gfx1012
	gfx1030
	 gfx1031
	gfx1100
	gfx1101
	gfx1102
)
DOCS_BUILDER="doxygen"
DOCS_DIR="docs"
DOCS_DEPEND="
	media-gfx/graphviz
"
LLVM_MAX_SLOT=15 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.4.2/llvm/CMakeLists.txt
ROCM_VERSION="${PV}"
inherit cmake docs edo multiprocessing llvm rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz
	-> rocm-${P}.tar.gz
https://media.githubusercontent.com/media/littlewu2508/littlewu2508.github.io/main/gentoo-distfiles/${PN}-5.4.2-Tensile-asm_full-navi22.tar.gz
"

DESCRIPTION="AMD's library for BLAS on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
DEPEND="
	>=dev-cpp/msgpack-cxx-6.0.0
	~dev-util/hip-${PV}
	test? (
		dev-cpp/gtest
		sys-libs/libomp
		virtual/blas
	)
	benchmark? (
		sys-libs/libomp
		virtual/blas
	)
"
BDEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}
	~dev-util/rocm-cmake-${PV}
	~dev-util/Tensile-${PV}:${SLOT}
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/${PN}-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-5.4.2-cpp_lib_filesystem.patch"
	"${FILESDIR}/${PN}-5.4.2-unbundle-Tensile.patch"
	"${FILESDIR}/${PN}-5.4.2-add-missing-header.patch"
	"${FILESDIR}/${PN}-5.4.2-link-cblas.patch"
)
QA_FLAGS_IGNORED="/usr/lib64/rocblas/library/.*"

src_prepare() {
	cmake_src_prepare
	cp -a \
		"${WORKDIR}/asm_full/" \
		"library/src/blas3/Tensile/Logic/" \
		|| die
	sed \
		-e "s:,-rpath=.*\":\":" \
		-i \
		clients/CMakeLists.txt \
		|| die
}

src_configure() {
	addpredict /dev/random
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DBUILD_WITH_TENSILE=ON
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocblas"
		-DCMAKE_SKIP_RPATH=On
		-DROCM_SYMLINK_LIBS=OFF
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
		dolib.a clients/librocblas_fortran_client.a
		dobin clients/staging/rocblas-bench
	fi
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
