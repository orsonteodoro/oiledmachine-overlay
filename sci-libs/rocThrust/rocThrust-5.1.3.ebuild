# Copyright 1999-2023 Gentoo Authors
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
CUB_COMMIT="0905d7effcb3395d4157895e1d77bbcb252e55c8"
LLVM_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake rocm

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
benchmark system-llvm test -tbb r2
"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
#[${ROCM_USEDEP}]
RDEPEND="
	~dev-util/hip-${PV}:${ROCM_SLOT}[system-llvm=]
	~sci-libs/rocPRIM-${PV}:${ROCM_SLOT}
	test? (
		dev-cpp/gtest
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.15
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/rocThrust-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-4.0-operator_new.patch"
	"${FILESDIR}/${PN}-5.1.3-path-changes.patch"
)

pkg_setup() {
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
		-DBUILD_TEST=$(usex test ON OFF)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
		-DSKIP_RPATH=ON
	)

	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"
	rocm_src_configure
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
