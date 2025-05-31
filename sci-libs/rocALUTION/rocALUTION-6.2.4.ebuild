# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# FIXME:
#/usr/lib/gcc/@CHOST@/12/include/omp.h:308:45: error: '__malloc__' attribute takes no arguments
#  __GOMP_NOTHROW __attribute__((__malloc__, __malloc__ (omp_free),
#                                            ^
# Still happens when USE=opemp CC=hipcc CXX=hipcc OR USE=openmp CC=${CHOST}-clang-${LLVM_SLOT} CXX=hipcc

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx940
	gfx941
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
CMAKE_BUILD_TYPE="RelWithDebInfo"
CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_SLOT=18
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocALUTION/archive/rocm-${PV}.tar.gz
	-> rocALUTION-${PV}.tar.gz
"

DESCRIPTION="Next generation library for iterative sparse solvers for ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocALUTION"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
rocm samples +openmp mpi
ebuild_revision_7
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
	|| (
		rocm
		openmp
		mpi
	)
"
RDEPEND="
	mpi? (
		virtual/mpi
	)
	openmp? (
		${ROCM_CLANG_DEPEND}
		~sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}[${LLVM_ROC_LIBOMP_6_2_AMDGPU_USEDEP}]
	)
	rocm? (
		~dev-util/hip-${PV}:${ROCM_SLOT}
		~sci-libs/rocBLAS-${PV}:${ROCM_SLOT}[${ROCBLAS_6_2_AMDGPU_USEDEP}]
		~sci-libs/rocPRIM-${PV}:${ROCM_SLOT}[${ROCPRIM_6_2_AMDGPU_USEDEP}]
		~sci-libs/rocRAND-${PV}:${ROCM_SLOT}[${ROCRAND_6_2_AMDGPU_USEDEP}]
		~sci-libs/rocSPARSE-${PV}:${ROCM_SLOT}[${ROCSPARSE_6_2_AMDGPU_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.5
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-5.6.0-invalid-operands-fix.patch"
	"${FILESDIR}/${PN}-5.3.3-hardcoded-paths.patch"
)

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-e "s: PREFIX rocalution):):" \
		-i \
		"${S}/src/CMakeLists.txt" \
		|| die
	sed \
		-e "s:PREFIX rocalution:#PREFIX rocalution:" \
		-i \
		"${S}/src/CMakeLists.txt" \
		|| die
	sed \
		-e "s:rocm_install_symlink_subdir(rocalution):#rocm_install_symlink_subdir(rocalution):" \
		-i \
		"${S}/src/CMakeLists.txt" \
		|| die

	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	# Grant access to the device to omit a sandbox violation
	addwrite "/dev/kfd"
	addpredict "/dev/dri/"
	local mycmakeargs=(
		-DBUILD_CLIENTS_BENCHMARKS=OFF
		-DBUILD_CLIENTS_SAMPLES=$(usex samples ON OFF)
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DCMAKE_INSTALL_INCLUDEDIR="include"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_MODULE_PATH="${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/cmake/hip"
		-DSUPPORT_HIP=$(usex rocm ON OFF)
		-DSUPPORT_MPI=$(usex mpi ON OFF)
		-DSUPPORT_OMP=$(usex openmp ON OFF)
	)

	rocm_set_default_hipcc

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if use openmp ; then
		mycmakeargs+=(
			-DOpenMP_CXX_FLAGS="-I${ESYSROOT}${EROCM_LLVM_PATH}/include -fopenmp=libomp"
			-DOpenMP_CXX_LIB_NAMES="libomp"
			-DOpenMP_libomp_LIBRARY="${ESYSROOT}${EROCM_LLVM_PATH}/$(rocm_get_libdir)/libomp.so"
		)
	fi

	if use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DROCM_PATH="${ESYSROOT}${EROCM_PATH}"
		)
	fi

	rocm_src_configure
}

src_install() {
        cmake_src_install
        chrpath --delete "${D}${EROCM_PATH}/$(rocm_get_libdir)/librocalution.so.0.1" || die
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
