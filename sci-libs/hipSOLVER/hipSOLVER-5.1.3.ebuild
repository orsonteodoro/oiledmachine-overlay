# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
ROCM_VERSION="${PV}"

inherit cmake edo flag-o-matic llvm rocm toolchain-funcs

# Some test datasets are shared with rocSPARSE.
SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipSOLVER/archive/refs/tags/rocm-${PV}.tar.gz
	-> hipSOLVER-${PV}.tar.gz
"

DESCRIPTION="ROCm SOLVER marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipSOLVER"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="test cuda +rocm"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
	^^ (
		rocm
		cuda
	)
"
RESTRICT="
	!test? (
		test
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

		~dev-util/rocm-smi-${PV}:${SLOT}
	)
	virtual/blas
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.5
	~dev-util/rocm-cmake-${PV}:${SLOT}
	test? (
		dev-cpp/gtest
	)
"
S="${WORKDIR}/hipSOLVER-rocm-${PV}"
PATCHES=(
)

src_prepare() {
	sed \
		-e "s/PREFIX hipsolver//" \
		-e "/<INSTALL_INTERFACE/s,include,include/hipsolver," \
		-e "s:rocm_install_symlink_subdir( hipsolver ):#rocm_install_symlink_subdir( hipsolver ):" \
		-i \
		library/src/CMakeLists.txt \
		|| die

	cmake_src_prepare

	# Fixed the install path.
	sed -i \
		-e "s.set(CMAKE_INSTALL_LIBDIR.#set(CMAKE_INSTALL_LIBDIR." \
		CMakeLists.txt \
		|| die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DCMAKE_INSTALL_INCLUDEDIR="include/hipsolver"
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

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	edob ./${PN,,}-test
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
