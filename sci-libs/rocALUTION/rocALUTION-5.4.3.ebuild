# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
)
CMAKE_MAKEFILE_GENERATOR="emake"
ROCM_VERSION="${PV}"
LLVM_MAX_SLOT=15

inherit cmake llvm rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocALUTION/archive/rocm-${PV}.tar.gz
	-> rocALUTION-${PV}.tar.gz
"

DESCRIPTION="Next generation library for iterative sparse solvers for ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocALUTION"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="
rocm samples +openmp mpi r1
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
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		=sys-devel/gcc-11*
		sys-devel/clang:${LLVM_MAX_SLOT}
	)
	rocm? (
		~dev-util/hip-${PV}:${SLOT}
		~sci-libs/rocBLAS-${PV}:${SLOT}
		~sci-libs/rocPRIM-${PV}:${SLOT}
		~sci-libs/rocRAND-${PV}:${SLOT}
		~sci-libs/rocSPARSE-${PV}:${SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.5
	~dev-util/rocm-cmake-${PV}:${SLOT}
"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/rocALUTION-5.6.0-invalid-operands-fix.patch"
)
CMAKE_BUILD_TYPE="RelWithDebInfo"

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
		-DCMAKE_MODULE_PATH="${ESYSROOT}/usr/$(get_libdir)/cmake/hip"
		-DSUPPORT_HIP=$(usex rocm ON OFF)
		-DSUPPORT_MPI=$(usex mpi ON OFF)
		-DSUPPORT_OMP=$(usex openmp ON OFF)
	)

	export CXX="${HIP_CXX:-hipcc}"

	if [[ "${CXX}" =~ (^|-)"g++" ]] ; then
eerror
eerror "Only hipcc or clang++ allowed for HIP_CXX"
eerror
		die
	fi

	if use openmp ; then
		has_version "sys-devel/gcc:11" || die "Reinstall gcc-11"
		if ver_test $(gcc-major-version) -ne 11 ; then
# For libstdc++ 11.
eerror
eerror "GCC 11 required for openmp.  You must do the following:"
eerror
eerror "  eselect gcc set ${CHOST}-gcc-11"
eerror
eerror "to change to gcc-11"
eerror
			die
		fi
		mycmakeargs+=(
			-DOpenMP_CXX_FLAGS="-fopenmp=libomp"
			-DOpenMP_CXX_LIB_NAMES="libomp"
			-DOpenMP_libomp_LIBRARY="omp"
		)
	fi

	if use rocm ; then
		export ROCM_PATH="${ESYSROOT}/usr"
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DROCM_PATH="${ESYSROOT}/usr"
		)
	fi

	cmake_src_configure
}

src_install() {
        cmake_src_install
        chrpath --delete "${D}/usr/lib64/librocalution.so.0.1" || die
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
