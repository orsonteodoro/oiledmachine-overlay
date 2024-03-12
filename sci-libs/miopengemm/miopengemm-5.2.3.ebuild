# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic rocm

KEYWORDS="~amd64"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/MIOpenGEMM/archive/rocm-${PV}.tar.gz
	-> miopengemm-${PV}.tar.gz
"
S="${WORKDIR}/MIOpenGEMM-rocm-${PV}"

DESCRIPTION="An OpenCL general matrix multiplication (GEMM) API and kernel generator"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="-benchmark r1"
RDEPEND="
	virtual/blas
	virtual/opencl
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.0
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-v5.3.3-gentoo-rocm-overlay-fixes.patch"
	"${FILESDIR}/${PN}-5.5.0-path-changes.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
	if use benchmark; then
		mycmakeargs+=(
			-DAPI_BENCH_CLBLAST=OFF
			-DAPI_BENCH_ISAAC=OFF
			-DAPI_BENCH_MIOGEMM=ON
		)
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
