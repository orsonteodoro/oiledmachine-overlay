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
	gfx1101
	gfx1102
)
LLVM_MAX_SLOT=15
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake edo flag-o-matic llvm rocm

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rccl"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/rccl/archive/rocm-${PV}.tar.gz
	-> rccl-${PV}.tar.gz
"
LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="test"
RDEPEND="
	!dev-libs/rccl:0
	~dev-util/hip-${PV}:${ROCM_SLOT}[rocm]
	~dev-util/rocm-smi-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.5
	~dev-util/rocm-cmake-${PV}:${ROCM_SLOT}
	test? (
		>=dev-cpp/gtest-1.11
	)
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/rccl-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-5.3.3-remove-chrpath.patch"
	"${FILESDIR}/${PN}-5.4.3-path-changes.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	replace-flags '-O0' '-O1'

	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"

	local rocm_path="/usr/$(get_libdir)/rocm/${ROCM_SLOT}"
	if [[ "${CXX}" =~ "hipcc" ]] ; then
		# Prevent configure test issues
		append-flags \
			--rocm-path="${ESYSROOT}${rocm_path}" \
			--rocm-device-lib-path="${ESYSROOT}${rocm_path}/$(get_libdir)/amdgcn/bitcode"
	fi

	export HIP_PLATFORM="amd"
	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_TESTS=$(usex test ON OFF)
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
		-DROCM_PATH="${ESYSROOT}${rocm_path}"
		-DSKIP_RPATH=ON
		-Wno-dev
	)

	cmake_src_configure
}

src_test() {
	check_amdgpu
	LD_LIBRARY_PATH="${BUILD_DIR}" edob test/UnitTests
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
