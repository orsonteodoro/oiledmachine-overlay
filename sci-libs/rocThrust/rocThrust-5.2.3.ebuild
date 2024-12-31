# Copyright 1999-2025 Gentoo Authors
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

inherit cmake rocm

KEYWORDS="~amd64"
S="${WORKDIR}/rocThrust-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocThrust/archive/rocm-${PV}.tar.gz
	-> rocThrust-${PV}.tar.gz
https://github.com/NVlabs/cub/archive/${CUB_COMMIT}.tar.gz
	-> cub-${CUB_COMMIT:0:7}.tar.gz
"

DESCRIPTION="A ported Thrust parallel library for AMD GPUs"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocThrust"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	BSD
	MIT
"
# The distro's Apache-2.0 license template does not have All rights reserved.
RESTRICT="
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
benchmark test ebuild_revision_4
"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
#[${ROCM_USEDEP}]
RDEPEND="
	~dev-util/hip-${PV}:${ROCM_SLOT}
	~sci-libs/rocPRIM-${PV}:${ROCM_SLOT}[${ROCPRIM_5_2_AMDGPU_USEDEP}]
	test? (
		dev-cpp/gtest
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.15
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-4.0-operator_new.patch"
	"${FILESDIR}/${PN}-5.2.3-hardcoded-paths.patch"
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
		"cmake/Dependencies.cmake" \
		|| die

	# Remove the GIT dependency.
	sed  -r \
		-e '/find_package\(Git/{:a;N;/\nendif/!ba; d}' \
		-i \
		"cmake/Dependencies.cmake" \
		|| die

	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"

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

	rocm_set_default_hipcc
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
