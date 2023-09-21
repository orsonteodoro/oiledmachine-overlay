# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/MIOpenGEMM/archive/rocm-${PV}.tar.gz
	-> miopengemm-${PV}.tar.gz
"

DESCRIPTION="An OpenCL general matrix multiplication (GEMM) API and kernel generator"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="-benchmark"
RDEPEND="virtual/opencl"
RDEPEND="
	virtual/blas
	virtual/opencl
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.0
	|| (
		~dev-util/rocm-cmake-${PV}:${SLOT}
		=dev-util/rocm-cmake-5.5*:0/5.5
		=dev-util/rocm-cmake-5.6*:0/5.6
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-v5.3.3-gentoo-rocm-overlay-fixes.patch"
	"${FILESDIR}/${PN}-5.5.0-path-changes.patch"
)
S="${WORKDIR}/MIOpenGEMM-rocm-${PV}"

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

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
