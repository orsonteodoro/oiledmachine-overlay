# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

SRC_URI="
https://github.com/ROCmSoftwarePlatform/MIOpenGEMM/archive/rocm-${PV}.tar.gz
	-> miopengemm-${PV}.tar.gz
"

DESCRIPTION="An OpenCL general matrix multiplication (GEMM) API and kernel generator"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
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
	~dev-util/rocm-cmake-${PV}:${SLOT}
"
PATCHES=(
	"${FILESDIR}/miopengemm-v4.3.0-gentoo-rocm-overlay-fixes.patch"
)
S="${WORKDIR}/MIOpenGEMM-rocm-${PV}"

src_prepare() {
	sed \
		-e "s:set( miopengemm_INSTALL_DIR miopengemm):set( miopengemm_INSTALL_DIR \"\"):" \
		-i \
		"${S}/miopengemm/CMakeLists.txt" \
		|| die
	sed \
		-e "s:rocm_install_symlink_subdir(\${miopengemm_INSTALL_DIR}):#rocm_install_symlink_subdir(\${miopengemm_INSTALL_DIR}):" \
		-i \
		"${S}/miopengemm/CMakeLists.txt" \
		|| die
	cmake_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
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

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
