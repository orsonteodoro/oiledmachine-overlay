# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=13
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/MIOpenGEMM-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/MIOpenGEMM/archive/rocm-${PV}.tar.gz
	-> miopengemm-${PV}.tar.gz
"

DESCRIPTION="An OpenCL general matrix multiplication (GEMM) API and kernel generator"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="-benchmark ebuild-revision-4"
RDEPEND="
	virtual/blas
	virtual/opencl
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.0
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-v4.3.0-gentoo-rocm-overlay-fixes.patch"
	"${FILESDIR}/${PN}-5.1.3-hardcoded-paths.patch"
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
	rocm_set_default_gcc
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
