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
rocm +openmp mpi
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
		>=sys-devel/libomp-${LLVM_MAX_SLOT}
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
CMAKE_BUILD_TYPE="RelWithDebInfo"

src_prepare() {
	export ROCM_TARGET_LST="${T}/target.lst"
	echo "gfx000" > "${ROCM_TARGET_LST}" || die
	if use amdgpu_targets_gfx803 ; then
		echo "gfx803" > "${ROCM_TARGET_LST}" || die
	fi
	if use amdgpu_targets_gfx900 ; then
		echo "gfx900" > "${ROCM_TARGET_LST}" || die
	fi
	if use amdgpu_targets_gfx906 ; then
		echo "gfx906" > "${ROCM_TARGET_LST}" || die
	fi
	if use amdgpu_targets_gfx908 ; then
		echo "gfx908" > "${ROCM_TARGET_LST}" || die
	fi

	sed \
		-e "s: PREFIX rocalution):):" \
		-i \
		src/CMakeLists.txt \
		|| die

	sed \
		-e "s:/opt/rocm/hip/cmake:${EPREFIX}/usr/$(get_libdir)/cmake/hip:" \
		-i \
		"${S}/CMakeLists.txt" \
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
	local mycmakeargs=(
		-DBUILD_CLIENTS_BENCHMARKS=OFF
		-DBUILD_CLIENTS_SAMPLES=ON
		-DBUILD_CLIENTS_TESTS=OFF
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocALUTION"
		-DCMAKE_MODULE_PATH="${ESYSROOT}/usr/$(get_libdir)/cmake/hip"
		-DSUPPORT_HIP=$(usex rocm ON OFF)
		-DSUPPORT_MPI=$(usex mpi ON OFF)
		-DSUPPORT_OMP=$(usex openmp ON OFF)
	)

	if use rocm ; then
		export ROCM_PATH="${ESYSROOT}/usr"
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DBUILD_HIPRAND=ON
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi

	CXX="${HIP_CXX:-hipcc}" \
	cmake_src_configure
}

src_install() {
        cmake_src_install
        chrpath --delete "${D}/usr/lib64/librocalution.so.0.1" || die
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
