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
CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_SLOT=17
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake rocm

KEYWORDS="~amd64"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocALUTION/archive/rocm-${PV}.tar.gz
	-> rocALUTION-${PV}.tar.gz
"
S="${WORKDIR}/${PN}-rocm-${PV}"

DESCRIPTION="Next generation library for iterative sparse solvers for ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocALUTION"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
rocm samples +openmp mpi system-llvm r1
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
	dev-util/rocm-compiler:${ROCM_SLOT}[system-llvm=]
	mpi? (
		virtual/mpi
	)
	openmp? (
		!system-llvm? (
			~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
			~sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}
		)
		system-llvm? (
			sys-devel/clang:${LLVM_SLOT}
			sys-libs/libomp:${LLVM_SLOT}
		)
	)
	rocm? (
		~dev-util/hip-${PV}:${ROCM_SLOT}
		~sci-libs/rocBLAS-${PV}:${ROCM_SLOT}
		~sci-libs/rocPRIM-${PV}:${ROCM_SLOT}
		~sci-libs/rocRAND-${PV}:${ROCM_SLOT}
		~sci-libs/rocSPARSE-${PV}:${ROCM_SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.5
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/rocALUTION-5.6.0-invalid-operands-fix.patch"
	"${FILESDIR}/rocALUTION-5.7.0-path-changes.patch"
)
CMAKE_BUILD_TYPE="RelWithDebInfo"

pkg_setup() {
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
	addwrite /dev/kfd
	addpredict /dev/dri/
	local mycmakeargs=(
		-DBUILD_CLIENTS_BENCHMARKS=OFF
		-DBUILD_CLIENTS_SAMPLES=$(usex samples ON OFF)
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocALUTION"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_MODULE_PATH="${ESYSROOT}${EROCM_PATH}/$(get_libdir)/cmake/hip"
		-DSUPPORT_HIP=$(usex rocm ON OFF)
		-DSUPPORT_MPI=$(usex mpi ON OFF)
		-DSUPPORT_OMP=$(usex openmp ON OFF)
	)

	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"

	if [[ "${CXX}" =~ (^|-)"g++" ]] ; then
eerror
eerror "Only hipcc or clang++ allowed for HIP_CXX"
eerror
		die
	fi

	if use openmp ; then
		mycmakeargs+=(
			-DOpenMP_CXX_FLAGS="-I${ESYSROOT}${EROCM_LLVM_PATH}/include -fopenmp=libomp"
			-DOpenMP_CXX_LIB_NAMES="libomp"
			-DOpenMP_libomp_LIBRARY="${ESYSROOT}${EROCM_LLVM_PATH}/$(get_libdir)/libomp.so.${LLVM_SLOT}"
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

	cmake_src_configure
}

src_install() {
        cmake_src_install
        chrpath --delete "${D}/usr/$(get_libdir)/librocalution.so.0.1" || die
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
