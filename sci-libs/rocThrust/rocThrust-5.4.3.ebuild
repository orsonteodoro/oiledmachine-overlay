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
	gfx1100
	gfx1102
)
CUB_COMMIT="cdaa9558a85e45d849016e5fe7b6e4ee79113f95"
LLVM_MAX_SLOT=15
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake llvm rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocThrust/archive/rocm-${PV}.tar.gz
	-> rocThrust-${PV}.tar.gz
https://github.com/NVlabs/cub/archive/${CUB_COMMIT}.tar.gz
	-> cub-${CUB_COMMIT:0:7}.tar.gz
"

DESCRIPTION="HIP back-end for the parallel algorithm library Thrust"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocThrust"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
benchmark test r1
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
	"${FILESDIR}/${PN}-5.4.3-path-changes.patch"
)

pkg_setup() {
	llvm_pkg_setup
	rocm_pkg_setup
}

src_unpack() {
	unpack ${A}
	rm -rf "${S}/dependencies/cub" || die
	ln -s \
		"${WORKDIR}/cub-${CUB_COMMIT}" \
		"${S}/dependencies/cub" \
		|| die
}

src_prepare() {
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

	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	export HIP_PLATFORM="amd"
	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DBUILD_TEST=$(usex test ON OFF)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
		-DSKIP_RPATH=ON
	)

	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"
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
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
