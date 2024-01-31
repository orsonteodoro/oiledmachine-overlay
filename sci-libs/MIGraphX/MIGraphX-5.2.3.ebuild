# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="AMDMIGraphX"
MY_P="${CATEGORY}/${MY_PN}-${PV}"

AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
	gfx1030
)
LLVM_MAX_SLOT=14
PYTHON_COMPAT=( python3_{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake llvm python-r1 rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/AMDMIGraphX/"
	inherit git-r3
else
	SRC_URI="
https://github.com/ROCmSoftwarePlatform/AMDMIGraphX/archive/rocm-${PV}.tar.gz
	-> ${MY_PN}-${PV}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-rocm-${PV}"
fi

DESCRIPTION="AMD's graph optimization engine"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/AMDMIGraphX"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
-cpu -fpga -hip-rtc -mlir +rocm system-llvm test
r2
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| (
		rocm
		cpu
		fpga
	)
	mlir? (
		rocm
	)
"
# protobuf is relaxed
RDEPEND="
	>=dev-db/sqlite-3.17
	>=dev-cpp/msgpack-cxx-3.3.0
	>=dev-cpp/nlohmann_json-3.8.0
	>=dev-libs/half-1.12.0
	>=dev-libs/protobuf-3.11:0/3.21
	>=dev-python/pybind11-2.6.0[${PYTHON_USEDEP}]
	dev-libs/msgpack
	cpu? (
		dev-libs/oneDNN
		sys-libs/libomp:${LLVM_MAX_SLOT}
	)
	rocm? (
		~sci-libs/miopen-${PV}:${ROCM_SLOT}
		~sci-libs/rocBLAS-${PV}:${ROCM_SLOT}
	)
	test? (
		~dev-util/hip-${PV}:${ROCM_SLOT}
	)
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/blaze-3.8:=
"
BDEPEND="
	!system-llvm? (
		sys-devel/llvm-roc:=
		~sys-devel/llvm-roc-${PV}
	)
	>=dev-util/cmake-3.5
	sys-devel/hip-compiler:${ROCM_SLOT}[system-llvm=]
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	rocm? (
		sys-devel/rocm-compiler:${ROCM_SLOT}[system-llvm=]
	)
	system-llvm? (
		sys-devel/clang:${LLVM_MAX_SLOT}[extra]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.2.3-path-changes.patch"
)

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	python_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	sed \
		-i \
		-e "s|msgpackc-cxx|msgpack-cxx|g" \
		"src/CMakeLists.txt" \
		|| die
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DMIGRAPHX_ENABLE_CPU=$(usex cpu ON OFF)
		-DMIGRAPHX_ENABLE_FPGA=$(usex fpga ON OFF)
		-DMIGRAPHX_ENABLE_GPU=$(usex rocm ON OFF)
		-DMIGRAPHX_ENABLE_MLIR=$(usex mlir ON OFF)
		-DMIGRAPHX_USE_HIPRTC=$(usex hip-rtc ON OFF)
	)

	if use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi

	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
