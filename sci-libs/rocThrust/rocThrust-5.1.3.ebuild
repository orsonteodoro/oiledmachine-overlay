# Copyright 1999-2022 Gentoo Authors
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
LLVM_MAX_SLOT=14
ROCM_VERSION="${PV}"

inherit cmake llvm rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocThrust/archive/rocm-${PV}.tar.gz
	-> rocThrust-${PV}.tar.gz
"

DESCRIPTION="HIP back-end for the parallel algorithm library Thrust"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocThrust"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="
benchmark test -tbb
"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
#[${ROCM_USEDEP}]
RDEPEND="
	~dev-util/hip-${PV}:${SLOT}
	~sci-libs/rocPRIM-${PV}:${SLOT}
	test? (
		dev-cpp/gtest
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.15
	~dev-util/rocm-cmake-${PV}:${SLOT}
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/rocThrust-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-4.0-operator_new.patch"
)

src_prepare() {
	sed \
		-e "/PREFIX rocthrust/d" \
		-e "/DESTINATION/s:rocthrust/include/thrust:include/thrust:" \
		-e "/rocm_install_symlink_subdir(rocthrust)/d" \
		-e "/<INSTALL_INTERFACE/s:rocthrust/include/:include/:" \
		-i \
		thrust/CMakeLists.txt \
		|| die

	sed \
		-e "s:\${CMAKE_INSTALL_INCLUDEDIR}:&/rocthrust:" \
		-e "s:\${ROCM_INSTALL_LIBDIR}:\${CMAKE_INSTALL_LIBDIR}:" \
		-i \
		cmake/ROCMExportTargetsHeaderOnly.cmake \
		|| die

	# Disabled downloading googletest and googlebenchmark
	sed  -r \
		-e '/Downloading/{:a;N;/\n *\)$/!ba; d}' \
		-i \
		cmake/Dependencies.cmake \
		|| die

	# Remove the GIT dependency.
	sed  -r \
		-e '/find_package\(Git/{:a;N;/\nendif/!ba; d}' \
		-i \
		cmake/Dependencies.cmake \
		|| die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	export HIP_PLATFORM="amd"
	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_TEST=$(usex test ON OFF)
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
		-DSKIP_RPATH=ON
	)

	CXX="${HIP_CXX:-hipcc}" \
	cmake_src_configure
}

src_test() {
	check_amdgpu
	MAKEOPTS="-j1" \
	cmake_src_test
}

src_install() {
	cmake_src_install
	use benchmark && \
	dobin "${BUILD_DIR}/benchmarks/benchmark_thrust_bench"
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
