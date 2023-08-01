# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipBLAS/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="ROCm BLAS marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLAS"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE+=" cuda +rocm"
REQUIRED_USE="
	^^ (
		cuda
		rocm
	)
"
RDEPEND="
	~dev-util/hip-${PV}:${SLOT}[cuda?,rocm?]
	cuda? (
		dev-util/nvidia-cuda-toolkit
	)
	rocm? (
		~sci-libs/rocBLAS-${PV}:${SLOT}[rocm]
		~sci-libs/rocSOLVER-${PV}:${SLOT}[rocm(+)]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"
S="${WORKDIR}/hipBLAS-rocm-${PV}"

src_prepare() {
	sed \
		-e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/hipblas/:" \
		-i \
		library/src/CMakeLists.txt \
		|| die
	sed \
		-e "/PREFIX hipblas/d" \
		-i \
		library/src/CMakeLists.txt \
		|| die
	sed \
		-e "/rocm_install_symlink_subdir( hipblas )/d" \
		-i \
		library/src/CMakeLists.txt \
		|| die
	sed \
		-e "s:hipblas/include:include/hipblas:" \
		-i \
		library/src/CMakeLists.txt \
		|| die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENTS_BENCHMARKS=OFF

	# Currently hipBLAS is a wrapper of rocBLAS which has tests, so no need
	# to perform the test here.
		-DBUILD_CLIENTS_TESTS=OFF

		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DUSE_CUDA=$(usex cuda ON OFF)
	)
	if use cuda ; then
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DHIP_COMPILER="cuda"
			-DHIP_RUNTIME="nvcc"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DHIP_COMPILER="clang"
			-DHIP_RUNTIME="rocclr"
		)
	fi
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
