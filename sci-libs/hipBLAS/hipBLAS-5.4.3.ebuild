# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15

inherit cmake flag-o-matic llvm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipBLAS/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="ROCm BLAS marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLAS"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE+=" cuda +rocm r1"
REQUIRED_USE="
	^^ (
		cuda
		rocm
	)
"
RDEPEND="
	~dev-util/hip-${PV}:${SLOT}[cuda?,rocm?]
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
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
	CXX="${HIP_CXX:-hipcc}" \
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# The build script is bugged.
	rm "${ED}/usr/include/hipblas/hipblas_module.f90" || die
	insinto "${EPREFIX}/usr/include/hipblas"
	doins library/src/hipblas_module.f90
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
