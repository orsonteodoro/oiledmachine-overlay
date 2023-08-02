# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16
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
		dev-util/nvidia-cuda-toolkit
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
	>=dev-util/cmake-3.7
	~dev-util/rocm-cmake-${PV}:${SLOT}
	test? (
		dev-cpp/gtest
	)
"
S="${WORKDIR}/hipSOLVER-rocm-${PV}"
PATCHES=(
)

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
}

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
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
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
		append-cxxflags -ccbin "${EPREFIX}/usr/${CHOST}/gcc-bin/${s}/${CHOST}-g++"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="nvcc"
		)
		CXX="nvcc" \
		cmake_src_configure
	elif use rocm ; then
		export HIP_CLANG_PATH=$(get_llvm_prefix ${LLVM_SLOT})"/bin"
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
		CXX="hipcc" \
		cmake_src_configure
	fi
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	edob ./${PN,,}-test
}

# OILEDMACHINE-OVERLAY-META:  builds-without-problems
