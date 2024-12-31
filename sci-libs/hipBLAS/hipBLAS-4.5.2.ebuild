# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

HIP_SUPPORT_CUDA=1
LLVM_SLOT=13
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/hipBLAS-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipBLAS/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="ROCm BLAS marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLAS"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE+=" cuda +rocm ebuild_revision_6"
REQUIRED_USE="
	^^ (
		cuda
		rocm
	)
"
RDEPEND="
	~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	rocm? (
		~sci-libs/rocBLAS-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/rocSOLVER-${PV}:${ROCM_SLOT}[rocm(+)]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
"
PATCHES=(
	"${FILESDIR}/${PN}-4.5.2-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENTS_BENCHMARKS=OFF

	# Currently hipBLAS is a wrapper of rocBLAS which has tests, so no need
	# to perform the test here.
		-DBUILD_CLIENTS_TESTS=OFF

		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DUSE_CUDA=$(usex cuda ON OFF)
	)
	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi
	rocm_set_default_hipcc
	rocm_src_configure
}

src_install() {
	cmake_src_install

	# The build script is bugged.
	rm -f "${ED}/usr/include/hipblas/hipblas_module.f90"
	insinto "${EPREFIX}/${EROCM_PATH}/include/hipblas"
	if [[ -e "library/src/hipblas_module.f90" ]] ; then
		doins "library/src/hipblas_module.f90"
	fi
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
