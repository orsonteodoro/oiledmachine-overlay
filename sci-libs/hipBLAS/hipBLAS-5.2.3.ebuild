# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipBLAS/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="ROCm BLAS marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLAS"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
IUSE+=" cuda +rocm system-llvm r2"
REQUIRED_USE="
	^^ (
		cuda
		rocm
	)
"
RDEPEND="
	dev-util/hip-compiler:${ROCM_SLOT}[system-llvm=]
	~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?,system-llvm=]
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
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
"
S="${WORKDIR}/hipBLAS-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-5.2.3-path-changes.patch"
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
		local s=11
		strip-flags
		filter-flags \
			-pipe \
			-Wl,-O1 \
			-Wl,--as-needed \
			-Wno-unknown-pragmas
		if [[ "${HIP_CXX}" == "nvcc" ]] ; then
			append-cxxflags -ccbin "${EPREFIX}/usr/${CHOST}/gcc-bin/${s}/${CHOST}-g++"
		fi
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
	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"
	rocm_src_configure
}

src_install() {
	cmake_src_install

	# The build script is bugged.
	rm -f "${ED}/usr/include/hipblas/hipblas_module.f90"
	insinto "${EPREFIX}/${EROCM_PATH}/include/hipblas"
	if [[ -e "library/src/hipblas_module.f90" ]] ; then
		doins library/src/hipblas_module.f90
	fi
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
